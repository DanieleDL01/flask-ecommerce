from flask import redirect, render_template, request, url_for, flash, session, current_app
from shop import db, app
from shop.products.models import Addproduct
from shop.products.routes import brands, categories, notifications


def MergeDicts(dict1, dict2):
    if isinstance(dict1, list) and isinstance(dict2, list):
        return dict1+dict2
    elif isinstance(dict1, dict) and isinstance(dict2, dict):
        return dict(list(dict1.items())+list(dict2.items()))
    return False



@app.route('/addcart', methods=['POST'])
def addcart():
    try:
        product_id = request.form.get('product_id')
        quantity = int(request.form.get('quantity'))
        color = request.form.get('colors')
        product = Addproduct.query.filter_by(id=int(product_id)).first()

        if product_id and quantity and color and request.method == 'POST':
            DictItems = {
                product_id: {
                    'name': product.name,
                    'price': product.price,
                    'discount': product.discount,
                    'color': color,
                    'quantity': quantity,
                    'image': product.image_1,
                    'colors': product.colors,
                    'status': "in cart"
                }
            }

            if 'Shoppingcart' in session:
                cart = session['Shoppingcart']
                found = False

                for key, item in cart.items():
                    if int(key) == int(product_id) and item['color'] == color:
                        item['quantity'] = str(int(item['quantity']) + quantity)
                        found = True
                        break

                if not found:
                    cart.update(DictItems)

                session['Shoppingcart'] = cart
            else:
                session['Shoppingcart'] = DictItems

            session.modified = True
            return redirect(request.referrer)

    except Exception as e:
        print(e)
    finally:
        return redirect(request.referrer)




@app.route('/carts')
def getcart():
    grandtotal=0
    subtotal = 0
    if 'Shoppingcart' not in session:
        flash('Your shopping cart is empty', 'warning')
    elif len(session['Shoppingcart']) <= 0:
        session.pop('Shoppingcart', None)
        flash('Your shopping cart is empty', 'warning')
    else:
        for key, product in session['Shoppingcart'].items():
            discount=(product['discount'])/100 * float(product['price'])
            tmp=float(product['price'])*int(product['quantity'])
            tmp-=discount
            subtotal+=tmp

    grandtotal=float("%.2f" % subtotal)

    return render_template('products/carts.html', grandtotal=grandtotal, brands=brands(), categories=categories(), notifications=notifications())

@app.route('/clearcart')
def clear_cart():
    session.pop('Shoppingcart', None)
    return redirect('/carts')


@app.route('/updatecart<int:code>', methods=['POST'])
def updatecart(code):
    if 'Shoppingcart' not in session and len(session['Shoppingcart']) <= 0:
        return redirect(url_for('home'))
    if request.method == 'POST':
        quantity=request.form.get('quantity')
        color=request.form.get('color')
        try:
            session.modified=True
            for key, item in session['Shoppingcart'].items():
                if int(key)==code:
                    item['quantity']=quantity
                    item['color']=color
                    flash('Item is updated')
                    return redirect(url_for('getcart'))
        except Exception as e:
            print(e)
            return redirect(url_for('getcart'))

@app.route('/deleteitem<int:id>')
def deleteitem(id):
    if 'Shoppingcart' not in session and len(session['Shoppingcart']) <= 0:
        return redirect(url_for('home'))
    try:
        session.modified=True
        for key, item in session['Shoppingcart'].items():
            if int(key)==id:
                session['Shoppingcart'].pop(key, None)
                return redirect(url_for('getcart'))
    except Exception as e:
        print(e)
        return redirect(url_for('getcart'))

