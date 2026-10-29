from wtforms import Form,StringField, PasswordField, TextAreaField, SubmitField, validators, ValidationError, BooleanField
from flask_wtf.file import FileAllowed, FileRequired, FileField
from flask_wtf import FlaskForm
from .models import Register


class CustomerRegistrationForm(FlaskForm):
    name=StringField('Name: ')
    username=StringField('Username: ', [validators.DataRequired()])
    email=StringField('Email: ', [validators.Email(), validators.DataRequired()])
    password=PasswordField('Password: ', [validators.DataRequired(), validators.EqualTo('confirm', message='Passwords must match')])
    confirm=PasswordField('Confirm Password: ', [validators.DataRequired()])

    country=StringField('Country: ', [validators.DataRequired()])
    state=StringField('State/Region: ', [validators.DataRequired()])
    city=StringField('City: ', [validators.DataRequired()])
    contact=StringField('Contact Number: ', [validators.DataRequired()])
    address=TextAreaField('Address: ', [validators.DataRequired()])
    zipcode=StringField('Zip Code: ', [validators.DataRequired()])

    seller=BooleanField('Seller: ', [validators.DataRequired()])

    profile = FileField(
        'profile',
        validators=[
            FileAllowed(['jpg', 'jpeg', 'png', 'gif'], 'Only image files are allowed!')
        ]
    )

    submit=SubmitField('Register')

    def validate_username(self, username):
        if Register.query.filter_by(username=username.data).first():
            raise ValidationError('username already in use')

    def validate_email(self, email):
        if Register.query.filter_by(email=email.data).first():
            raise ValidationError('email already in use')


class CustomerLoginForm(FlaskForm):
    email = StringField('Email: ', [validators.Email(), validators.DataRequired()])
    password = PasswordField('Password: ', [validators.DataRequired()])

class OrderForm(FlaskForm):
    status = StringField('Status',[validators.DataRequired()])
    submit = SubmitField('Update Order Status')

class NotificationForm(FlaskForm):
    text = StringField('Text', [validators.DataRequired()])
    submit = SubmitField('Notification')






