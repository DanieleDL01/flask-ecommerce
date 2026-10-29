from flask import render_template, session, request, redirect, url_for, flash
from shop import app, db, bcrypt
from .forms import RegistrationForm, LoginForm
from .models import User
from shop.products.models import Addproduct, Brand, Category
import os

def brands_():
    brands = Brand.query.join(Addproduct, (Brand.id == Addproduct.brand_id)).all()
    return brands

def categories_():
    categories = Category.query.join(Addproduct, (Category.id == Addproduct.category_id)).all()
    return categories
@app.route('/admin')
def admin():
    if 'email' not in session:
        flash('Please login first', 'danger')
        return redirect(url_for('login'))
    products=Addproduct.query.all()
    return render_template('admin/index.html', title='Admin Page', products=products)



@app.route('/admin/brands')
def brands():
    if 'email' not in session:
        flash('Please login first', 'danger')
        return redirect(url_for('login'))
    brands=Brand.query.order_by(Brand.id.desc()).all()
    return render_template('admin/brand.html', title='Brand Page', brands=brands)


@app.route('/admin/categories')
def category():
    if 'email' not in session:
        flash('Please login first', 'danger')
        return redirect(url_for('login'))
    categories=Category.query.order_by(Category.id.desc()).all()
    return render_template('admin/brand.html', title='Brand Page', categories=categories)


@app.route('/admin/register', methods=['GET', 'POST'])
def register():
    form = RegistrationForm(request.form)
    if request.method == 'POST' and form.validate():
        hash_password=bcrypt.generate_password_hash(form.password.data).decode('utf-8')
        user = User(name=form.name.data, username=form.username.data, email=form.email.data, password=hash_password)
        db.session.add(user)
        db.session.commit()
        flash(f'Welcome {form.name.data} Thanks for registering', 'success')
        return redirect(url_for('admin'))
    return render_template('admin/register.html', form=form, title="Registration page")

@app.route('/admin/login', methods=['GET', 'POST'])
def login():
    form=LoginForm(request.form)
    if request.method=='POST'and form.validate():
        user=User.query.filter_by(email=form.email.data).first()
        try:
            if user and bcrypt.check_password_hash(user.password, form.password.data):
                session['email'] = form.email.data
                flash(f'Welcome {user.username} You are logged in now', 'success')
                return redirect(request.args.get('next') or url_for('admin'))
            else:
                flash('Wrong password, please try again', 'danger')
        except ValueError as e:
            flash("There was an issue with your login. Retry", "danger")

    return render_template('admin/login.html', form=form, title="Login Page")

@app.route('/admin/result')
def adminresult():
    if 'email' not in session:
        flash('Please login first', 'danger')
        return redirect(url_for('login'))

    searchword = f"%{request.args.get('q')}%"

    products = Addproduct.query.join(Brand, Addproduct.brand_id == Brand.id).join(
        Category, Addproduct.category_id == Category.id
    ).filter(
        (Addproduct.name.ilike(searchword)) |
        (Addproduct.description.ilike(searchword)) |
        (Brand.name.ilike(searchword)) |
        (Category.name.ilike(searchword))
    ).order_by(Addproduct.id.desc())
    return render_template('admin/index.html', products=products, brands=brands_(), categories=categories_())

@app.route('/admin/logout')
def adminlogout():
    if 'email' not in session:
        flash('Please login first', 'danger')
        return redirect(url_for('login'))
    session.pop('email')
    return redirect(url_for('login'))