from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_uploads import IMAGES, UploadSet, configure_uploads
import os
from flask_login import LoginManager

basedir=os.path.abspath(os.path.dirname(__file__))
app=Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql+pg8000://postgres:postgres@localhost/ShopData_anon'
app.config['SECRET_KEY']='mysecretkey'
app.config['UPLOADED_PHOTOS_DEST']=os.path.join(basedir, 'static/images')

photos=UploadSet('photos',IMAGES)
configure_uploads(app,photos)


db=SQLAlchemy(app)
bcrypt=Bcrypt(app)

login_manager=LoginManager()
login_manager.init_app(app)
login_manager.login_view='customerLogin'
login_manager.needs_refresh_message_category='danger'
login_manager.login_message=u"Please Login first"


from shop.admin import routes
from shop.products import routes
from shop.carts import carts
from shop.customers import routes