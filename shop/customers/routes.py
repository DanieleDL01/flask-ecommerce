from flask import redirect, render_template, request, url_for, flash, session, current_app
from shop import db, app, photos, bcrypt, login_manager
from .forms import CustomerRegistrationForm, CustomerLoginForm, OrderForm, NotificationForm
from .models import Register, CustomerOrder, Notification
from flask_login import login_required, current_user, logout_user, login_user
import secrets, os
from ..products.routes import brands, categories, notifications
from ..products.models import Addproduct


@app.route('/customer/register', methods=['GET', 'POST'])
def customer_registration():
    form = CustomerRegistrationForm()
    if form.validate_on_submit():

        hash_password = bcrypt.generate_password_hash(form.password.data).decode('utf-8')

        profile = None
        if form.profile.data:
            try:
                profile_filename = secrets.token_hex(10) + os.path.splitext(form.profile.data.filename)[1]
                profile = photos.save(form.profile.data, name=profile_filename)
            except Exception as e:
                flash(f"Errore durante il salvataggio dell'immagine: {str(e)}", 'danger')
                return redirect(request.url)

        seller_value = request.form.get('seller')
        seller_value = bool(int(seller_value))

        register = Register(
            name=form.name.data,
            username=form.username.data,
            email=form.email.data,
            password=hash_password,
            country=form.country.data,
            state=form.state.data,
            city=form.city.data,
            zipcode=form.zipcode.data,
            address=form.address.data,
            contact=form.contact.data,
            profile=profile,
            seller=seller_value
        )
        db.session.add(register)
        db.session.commit()
        flash(f'Benvenuto {form.username.data}! Grazie per esserti registrato', 'success')
        return redirect(url_for('customerLogin'))
    return render_template('customer/register.html', form=form)


@app.route('/customer/login', methods=['GET', 'POST'])
def customerLogin():
    form=CustomerLoginForm()
    if form.validate_on_submit():
        user=Register.query.filter_by(email=form.email.data).first()
        if user and bcrypt.check_password_hash(user.password, form.password.data):
            login_user(user)
            flash(f'You are logged in as {user.username}', 'success')
            next=request.args.get('next')
            return redirect(next or url_for('home'))
        flash('Invalid email or password', 'danger')
        return redirect(url_for('customerLogin'))
    return render_template('/customer/login.html', form=form)


@app.route('/customer/logout')
def customerLogout():
    logout_user()
    return redirect(url_for('home'))

@app.route('/getorder')
@login_required
def getorder():
    if current_user.is_authenticated:
        customer_id=current_user.id
        invoice=secrets.token_hex(5)
        try:
            order=CustomerOrder(invoice=invoice,customer_id=customer_id, orders=session['Shoppingcart'])

            for product_id, product in order.orders.items():
                product['status']="Pending"
                product_quantity = int(product['quantity'])
                updateproduct=Addproduct.query.get_or_404(product_id)
                updateproduct.stock-=product_quantity

            db.session.add(order)
            db.session.commit()

            for product_id, product in order.orders.items():
                updateproduct = Addproduct.query.get_or_404(product_id)
                messaggio = "Someone ordered " + str(product['quantity']) + " " + str(product['name']) + "(id:" + str(
                    updateproduct.id) + ")"
                notification = Notification(int(updateproduct.seller_id), order.invoice, messaggio);
                db.session.add(notification)
                db.session.commit()

            session.pop('Shoppingcart')
            flash(f'Order {invoice} is created', 'success')
            return redirect(url_for('orders', invoice=invoice))

        except Exception as e:
            db.session.rollback()
            print(e)
            flash('Something went wrong', 'danger')
            return redirect(url_for('getcart'))

@app.route('/orders/<invoice>')
@login_required
def orders(invoice):
    grandtotal = 0;
    lista=[]
    if current_user.is_authenticated:
        orders = CustomerOrder.query.filter_by(invoice=invoice).first()
        subtotal=0;
        customer_id=orders.customer_id
        customer=Register.query.filter_by(id=customer_id).first()
        for key, product in orders.orders.items():
            discount=(product['discount']/100)*float(product['price'])
            tmp=float(product['price'])*int(product['quantity'])
            tmp-=discount
            subtotal+=tmp

            nots=Notification.query.filter_by(order_invoice=invoice)
            tmp=-1;
            for notification in nots:
                if notification.text.startswith("Someone"):
                    tmp=notification.customer_id

            if tmp!=-1:
                user = Register.query.filter_by(id=tmp).first()
                if user:
                    lista.append([product, True, user])
                else:
                    lista.append([product, False])
            else:
                lista.append([product, False])

        grandtotal=float("%.2f" % subtotal)
    else:
        return redirect(url_for('customerLogin'))
    return render_template('/customer/order.html', invoice=invoice, orders=orders, grandtotal=grandtotal, subtotal=subtotal, customer=customer, lista=lista, notifications=notifications(), brands=brands(), categories=categories())


@app.route('/profile')
@login_required
def profile():
    if current_user.is_authenticated:
        customer_id = current_user.id
        customer = Register.query.filter_by(id=customer_id).first()
    else:
        return redirect(url_for('customerLogin'))

    if customer.seller == True:
        products = Addproduct.query.filter_by(seller_id=customer_id).all()

        seller_id = customer_id
        products_sold_by_seller = Addproduct.query.filter_by(seller_id=seller_id).all()
        order_data = []
        product_ids = [product.id for product in products_sold_by_seller]

        orders = CustomerOrder.query.order_by(CustomerOrder.date_created.desc())
        for order in orders:
            for product_id, details in order.orders.items():
                if int(product_id) in product_ids:
                    order_data.append({
                        'order_invoice': order.invoice,
                        'product_id': product_id,
                        'quantity': details['quantity'],
                        'color': details['color'],
                        'date': order.date_created,
                        'customer_id': order.customer_id,
                        'status': details['status'],
                    })
        return render_template('/customer/profile.html', customer=customer, categories=categories(), brands=brands(), products=products, order_data=order_data, orders=orders, notifications=notifications())
    else:
        products = Addproduct.query.all()
        order_data = []
        orders = CustomerOrder.query.filter_by(customer_id=customer_id).order_by(CustomerOrder.date_created.desc())
        for order in orders:
            for product_id, details in order.orders.items():
                order_data.append({
                    'order_invoice': order.invoice,
                    'product_id': product_id,
                    'quantity': details['quantity'],
                    'color': details['color'],
                    'date': order.date_created,
                    'customer_id': Addproduct.query.filter_by(id=int(product_id)).first().seller_id,
                    'status': details['status'],
                })
        return render_template('/customer/profile.html', customer=customer, categories=categories(), brands=brands(), products=products, order_data=order_data, orders=orders, notifications=notifications())


@app.route('/profile/edit', methods=['GET', 'POST'])
@login_required
def edit_profile():
    if current_user.is_authenticated:
        customer_id = current_user.id
    else:
        return redirect(url_for('customerLogin'))
    customer = Register.query.get_or_404(customer_id)
    form = CustomerRegistrationForm()
    if request.method == "POST":
        if customer.username != form.username.data:
            customer.username = form.username.data
        customer.name=form.name.data
        customer.contact=form.contact.data
        customer.country=form.country.data
        customer.city=form.city.data
        customer.state=form.state.data
        customer.zipcode=form.zipcode.data
        customer.address=form.address.data

        if request.files.get("profile"):
            try:
                os.unlink(os.path.join(current_app.root_path, "static/images/"+customer.profile))
                customer.profile = photos.save(request.files.get('profile'), name=secrets.token_hex(10) + ".")
            except:
                customer.profile = photos.save(request.files.get('profile'), name=secrets.token_hex(10) + ".")

        db.session.commit()
        flash(f'Your profile has been updated', 'success')
        return redirect(url_for('profile'))

    form.username.data = customer.username
    form.name.data = customer.name
    form.contact.data = customer.contact
    form.country.data = customer.country
    form.city.data = customer.city
    form.state.data = customer.state
    form.zipcode.data = customer.zipcode
    form.address.data = customer.address


    return render_template('customer/edit_profile.html', title='Update Profile', form=form, customer=customer , categories=categories(), brands=brands(), notifications=notifications())

@app.route('/updatestatus/<invoice>/<product_id>', methods=['POST'])
@login_required
def update_status(invoice, product_id):
    if current_user.is_authenticated:
        customer_id = current_user.id
    else:
        return redirect(url_for('customerLogin'))

    form = OrderForm(request.form)
    order=CustomerOrder.query.filter_by(invoice=invoice).first()
    orders_dict = order.orders.copy()
    orders_dict[product_id]['status'] = form.status.data

    order.orders = "!"

    db.session.commit()

    messaggio = "The status of "+str(orders_dict[product_id]['name'])+"("+product_id+")"+" of the order '"+str(invoice)+"' has been updated by the seller to: "+str(orders_dict[product_id]['status'])
    notification = Notification(int(order.customer_id),order.invoice, messaggio);
    db.session.add(notification)


    order.orders=orders_dict
    db.session.commit()

    flash(f'The status has been updated', 'success')
    return redirect(url_for('profile'))


@app.route('/profile/delete', methods=['GET', 'POST'])
@login_required
def delete_profile():
    if 'email' not in session:
        if current_user.is_authenticated:
            customer_id = current_user.id
        else:
            return redirect(url_for('customerLogin'))
    else:
        return redirect(url_for('admin'))
    try:
        customer = Register.query.get_or_404(customer_id)
        logout_user()
        db.session.delete(customer)
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        print(e)
        flash('Something went wrong', 'danger')
        return redirect(url_for('profile'))
    finally:
        return redirect(url_for('home'))
