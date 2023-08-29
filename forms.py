from flask_wtf import FlaskForm, Form
from wtforms import StringField, SubmitField, PasswordField, SelectField, FieldList, FormField
from wtforms.validators import DataRequired, EqualTo


''' Forms Utilitários '''
# Create Login Form
class LoginForm(FlaskForm):
    username = StringField('Usuário', validators=[DataRequired()])
    password = PasswordField('Senha', validators=[DataRequired()])
    submit = SubmitField("Entrar")

''' Forms de Cadastros '''
# Form do Usuário
class UserForm(FlaskForm):
    login = StringField('Usuário', validators=[DataRequired()])
    senha = PasswordField('Senha', validators=[DataRequired(), EqualTo('senha2', message='Repita a senha!')])
    senha2 = PasswordField('Repita a Senha', validators=[DataRequired()])
    nome = StringField('Nome', validators=[DataRequired()])
    submit = SubmitField("Adicionar")

# Form da Empresa
class EmpresaForm(FlaskForm):
    cnpj_empresa = StringField('CNPJ', validators=[DataRequired()])
    razao_social = StringField('Razão Social', validators=[DataRequired()])
    nome_fantasia = StringField('Nome Fantasia', validators=[DataRequired()])
    submit = SubmitField("Adicionar")

# Form da Conta
class ContaForm(FlaskForm):
    id_conta = StringField('Código da Conta', validators=[DataRequired()])
    nome_conta = StringField('Nome da Conta', validators=[DataRequired()])
    tipo_conta = SelectField('Tipo da Conta', choices=[('A', 'Ativo'), ('P', 'Passivo'), ('L', 'Patrimônio Liquido'), ('R', 'Receita'), ('D', 'Despesa')])
    ordem = StringField('Ordenação', validators=[DataRequired()])
    submit = SubmitField("Adicionar")

# Form do Estoque
class EstoqueForm(FlaskForm):
    id_estoque = StringField('Código do Estoque', validators=[DataRequired()])
    id_empresa = StringField('Empresa', validators=[DataRequired()])
    nome_estoque = StringField('Nome do Estoque', validators=[DataRequired()])
    submit = SubmitField("Adicionar")

# Form do Item
class ItemForm(FlaskForm):
    id_item = StringField('Código do Item', validators=[DataRequired()])
    nome_item = StringField('Nome do Item', validators=[DataRequired()])
    submit = SubmitField("Submit")

# Form do Parceiro
class ParceiroForm(FlaskForm):
    id_item = StringField('cnpj_empresa', validators=[DataRequired()])
    nome_item = StringField('razao_social', validators=[DataRequired()])
    submit = SubmitField("Submit")

''' Forms de Documentos '''
# Form do Parceiro
class ParceiroForm(FlaskForm):
    # Cabeçalho
    customer_id = StringField('ID Parceiro', validators=[DataRequired()])
    invoice_date = StringField('Data de Lançamento', validators=[DataRequired()])
    due_date = StringField('Data de Vencimento', validators=[DataRequired()])
    # Linhas
    id_product = StringField('ID Produto', validators=[DataRequired()])
    quantity = StringField('Quantidade', validators=[DataRequired()])
    unit_price = StringField('Preço Unitário', validators=[DataRequired()])
    submit = SubmitField("Submit")

'''Form teste'''

class EmailLineForm(Form): 
    email = StringField('Email', validators=[DataRequired()])
    nome = StringField('Nome', validators=[DataRequired()])

class EmailForm(FlaskForm):
    email_list = FieldList(FormField(EmailLineForm), min_entries=1)
    submit = SubmitField('Submit')
