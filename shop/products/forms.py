from flask_wtf.file import FileAllowed, FileRequired, FileField
from wtforms import Form, IntegerField, StringField, BooleanField, TextAreaField, validators, DateField, DecimalField


class Addproducts(Form):
    name = StringField('Name', [validators.DataRequired()])
    price = DecimalField('Price', [validators.DataRequired()])
    discount = IntegerField('Discount', [validators.DataRequired()])
    stock = IntegerField('Stock', [validators.DataRequired()])
    description = TextAreaField('Description', [validators.DataRequired()])
    colors= TextAreaField('Colors', [validators.DataRequired()])
    pub_date=DateField('Publish Date', [validators.DataRequired()])
    seller_id = IntegerField('Seller_id: ', [validators.DataRequired()])

    image_1=FileField('Image 1', validators=[FileAllowed(['jpg', 'jpeg', 'png', 'gif'], 'images only pls')])
    image_2=FileField('Image 2', validators=[FileAllowed(['jpg', 'jpeg', 'png', 'gif'], 'images only pls')])
    image_3=FileField('Image 3', validators=[FileAllowed(['jpg', 'jpeg', 'png', 'gif'], 'images only pls')])


