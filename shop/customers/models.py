from shop import db, login_manager
from datetime import datetime
from flask_login import UserMixin
import json


@login_manager.user_loader
def user_loader(user_id):
    return Register.query.get(user_id)


class Register(db.Model, UserMixin):
    id=db.Column(db.Integer, primary_key=True)
    name=db.Column(db.String(50), unique=False, nullable=False)
    username=db.Column(db.String(50), unique=True, nullable=False)
    email=db.Column(db.String(50), unique=True, nullable=False)
    password=db.Column(db.String(200), unique=False, nullable=False)

    country=db.Column(db.String(50), unique=False, nullable=False)
    state=db.Column(db.String(50), unique=False, nullable=False)
    city=db.Column(db.String(50), unique=False, nullable=False)
    contact=db.Column(db.String(50), unique=False, nullable=False)
    address=db.Column(db.String(100), unique=False, nullable=False)
    zipcode=db.Column(db.String(50), unique=False, nullable=False)

    profile=db.Column(db.String(200), unique=False, default='profile.jpg')
    date_created=db.Column(db.DateTime,  nullable=False, default=datetime.now)

    seller=db.Column(db.Boolean, nullable=False, default=False)

    def __repr__(self):
        return '<Register %r>' % self.username


class JsonDict(db.TypeDecorator):
    impl = db.Text

    def process_bind_param(self, value, dialect):
        if value is None:
            return '{}'
        else:
            return json.dumps(value)

    def process_result_value(self, value, dialect):
        if value is None:
            return {}
        else:
            return json.loads(value)


class CustomerOrder(db.Model):
    id=db.Column(db.Integer, primary_key=True)
    invoice=db.Column(db.String(20), unique=True, nullable=False)
    customer_id=db.Column(db.Integer, unique=False, nullable=False)
    date_created=db.Column(db.DateTime, nullable=False, default=datetime.now)
    orders=db.Column(JsonDict)

    def __repr__(self):
        return '<CustomerOrder %r>' % self.invoice


class Notification(db.Model):
    id=db.Column(db.Integer, primary_key=True)
    customer_id=db.Column(db.Integer, unique=False, nullable=False)
    order_invoice=db.Column(db.String(20), unique=False, nullable=False)
    text=db.Column(db.String(200), unique=False, nullable=True)
    date_created=db.Column(db.DateTime, nullable=False, default=datetime.now)

    def __init__(self, customer_id, order_invoice, text):
        self.customer_id = customer_id
        self.order_invoice = order_invoice
        self.text = text
