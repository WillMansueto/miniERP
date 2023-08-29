import psycopg2
from psycopg2.extras import NamedTupleCursor
from flask import Flask, render_template, flash, request, url_for, redirect, session, g
from forms import LoginForm, UserForm, EmpresaForm, ItemForm, ContaForm, EstoqueForm
from collections import namedtuple


# Configuração Flask
app = Flask(__name__)
app.config['SECRET_KEY'] = "NUTNUTNUT"
app.config['SESSION_TYPE'] = "filesystem"
app.config['TEMPLATES_AUTO_RELOAD'] = True



# Conexão com o Banco
def get_db_connection():
    conn = psycopg2.connect(
        host="localhost",
        database="postgres",
        user="postgres",
        password="postgres")
    return conn

# User Class
class User():
    def __init__(self, user_id: str, login: str, senha: str, nome: str):
        self.id = user_id
        self.login = login
        self.senha = senha
        self.nome = nome
    
    def __repr__(self):
        return f'<User: {self.nome}>'

# User Loader Callback
@app.before_request
def before_request():
    g.user = None
    if 'user_id' in session:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT * FROM select_id_caduser(%s)', (session['user_id'],))
        g.user = cur.fetchone()
        print(g.user)

@app.route('/')
def index():
    return render_template('index.html')

# Cadastro de Usuário
@app.route('/user/add', methods=('GET', 'POST'))
def cadastro_user():
    form = UserForm()
    if form.validate_on_submit():
        login = request.form['login']
        senha = request.form['senha']
        nome  = request.form['nome']
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT insert_into_caduser(%s, %s, %s)', (login, senha, nome))
        conn.commit()
        cur.close()
        conn.close()
        return redirect(url_for('index'))
    else:
        print(form.errors)
    return render_template('cadastro_user.html', form=form)

# Cadastro de Usuário
@app.route('/user/update/<int:id>', methods=('GET', 'POST'))
def user_update(id):
    if not g.user:
        return redirect(url_for('login'))
    form = UserForm()
    cur = conn.cursor()
    cur.execute('SELECT select_id_caduser(%s)', (id))
    user = cur.fetchone()
    if user:
        login = request.form['login']
        senha = request.form['senha']
        nome  = request.form['nome']
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT insert_into_caduser(%s, %s, %s)', (login, senha, nome))
        conn.commit()
        cur.close()
        conn.close()
        return redirect(url_for('index'))
    else:
        print(form.errors)
    return render_template('cadastro_user.html', form=form)

# Deletar Usuário
@app.route('/user/delete/<int:id>', methods=('GET', 'POST'))
def user_delete(id):
    if not g.user:
        return redirect(url_for('login'))
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT * from select_id_caduser(%s)', (id,))
    user = cur.fetchone()
    if user[0] == id:
        cur.execute('SELECT delete_caduser(%s)', (id,))
        conn.commit()
        cur.execute('SELECT * FROM select_all_caduser()')
        users = cur.fetchall()
        cur.close()
        conn.close()
        return render_template('user_all.html', users=users)
    else:
        flash('Erro! Tente novamente mais tarde.')
        cur.execute('SELECT * FROM select_all_caduser()')
        users = cur.fetchall()
        cur.close()
        conn.close()
        return render_template('user_all.html', users=users)

# Users
@app.route('/user/all')
def user_all():
    if not g.user:
        return redirect(url_for('login'))
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM select_all_caduser()')
    users = cur.fetchall()
    cur.close()
    conn.close()
    return render_template('user_all.html', users=users)


# Login do Usuário
@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        session.pop('user_id', None)
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT * FROM LOGIN_USER(%s, %s)',(form.username.data, form.password.data))
        row = cur.fetchone()
        if row:
            user = User(row[0], row[1], row[2], row[3])
            session['user_id'] = user.id
            flash('login successful!')
            return redirect(url_for('index'))
        else:
            flash('Nome ou senha invalidos')
    return render_template('login.html', form=form)

# Logout do Usuário
@app.route('/logout', methods=['GET', 'POST'])
#@login_required
def logout():
    session.pop('user_id', None)
    flash('You have been logged out!')
    return redirect(url_for('login'))

# Cadastro da Empresa
@app.route('/empresa/add', methods=('GET', 'POST'))
def cadastro_empresa():
    if not g.user:
        return redirect(url_for('login'))
    form = EmpresaForm()
    if form.validate_on_submit():
        cnpj_empresa = request.form['cnpj_empresa']
        razao_social = request.form['razao_social']
        nome_fantasia = request.form['nome_fantasia']
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT insert_into_cadempresa(%s, %s, %s)', (cnpj_empresa, razao_social, nome_fantasia))
        conn.commit()
        cur.close()
        conn.close()
        return redirect(url_for('index'))
    return render_template('cadastro_empresa.html', form=form)

# Cadastro do item
@app.route('/item/add', methods=('GET', 'POST'))
def cadastro_item():
    if not g.user:
        return redirect(url_for('login'))
    form = ItemForm()
    if form.validate_on_submit():
        id_item = request.form['id_item']
        nome_item = request.form['nome_item']
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT insert_into_caditem(%s, %s)', (id_item, nome_item))
        conn.commit()
        cur.close()
        conn.close()
        return redirect(url_for('index'))
    return render_template('cadastro_item.html', form=form)

# Teste Itens
@app.route('/itens', methods=('GET', 'POST'))
def itens():
    if not g.user:
        return redirect(url_for('login'))
    conn = get_db_connection()
    cur = conn.cursor()
    form = ItemForm()
    if form.validate_on_submit():
        id_item = request.form['id_item']
        nome_item = request.form['nome_item']
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT insert_into_caditem(%s, %s)', (id_item, nome_item))
        conn.commit()
    cur.execute('SELECT * FROM select_all_caditem();')
    items = cur.fetchall()
    cur.close()
    conn.close()
    return render_template('itens.html', form=form, items=items)

# Deletar Usuário
@app.route('/item/delete/<string:id>', methods=('GET', 'POST'))
def item_delete(id):
    if not g.user:
        return redirect(url_for('login'))
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT * from select_id_caditem(%s)', (id,))
    item = cur.fetchone()
    if item:
        cur.execute('SELECT delete_caditem(%s)', (id,))
        conn.commit()
        cur.execute('SELECT * FROM select_all_caditem()')
        items = cur.fetchall()
        cur.close()
        conn.close()
        return render_template('itens.html', form=ItemForm(), items=items)
    else:
        flash('Erro! Tente novamente mais tarde.')
        cur.execute('SELECT * FROM select_all_caditem()')
        items = cur.fetchall()
        cur.close()
        conn.close()
        return render_template('itens.html', form=ItemForm(), items=items)


# Users
@app.route('/item/all')
def item_all():
    if not g.user:
        return redirect(url_for('login'))
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM select_all_caditem()')
    items = cur.fetchall()
    cur.close()
    conn.close()
    return render_template('item_all.html', items=items)

# Cadastro da Conta
@app.route('/conta/add', methods=('GET', 'POST'))
def cadastro_conta():
    if not g.user:
        return redirect(url_for('login'))
    form = ContaForm()
    if form.validate_on_submit():
        id_conta = request.form['id_conta']
        nome_conta = request.form['nome_conta']
        tipo_conta = request.form['tipo_conta']
        ordem = request.form['ordem']
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT insert_into_cadconta(%s, %s, %s, %s)', (id_conta, nome_conta, tipo_conta, ordem))
        conn.commit()
        cur.close()
        conn.close()
        return redirect(url_for('index'))
    return render_template('cadastro_conta.html', form=form)

# Cadastro da Conta
@app.route('/estoque/add', methods=('GET', 'POST'))
def cadastro_estoque():
    if not g.user:
        return redirect(url_for('login'))
    form = EstoqueForm()
    if form.validate_on_submit():
        id_estoque = request.form['id_estoque']
        id_empresa = request.form['id_empresa']
        nome_estoque = request.form['nome_estoque']
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT insert_into_cadestoque(%s, %s, %s)', (id_estoque, id_empresa, nome_estoque))
        conn.commit()
        cur.close()
        conn.close()
        return redirect(url_for('index'))
    return render_template('cadastro_estoque.html', form=form)


'''
@app.route('/entrada', methods=('GET', 'POST'))
def cadastra_entrada():
    if request.method == 'POST':

@app.route('/notaentrada/add', methods=('GET', 'POST'))
def insere_nota_entrada():
    form = UserForm()
    if form.validate_on_submit():
        login = request.form['login']
        senha = request.form['senha']
        nome  = request.form['nome']
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT insert_into_caduser(%s, %s, %s)', (login, senha, nome))
        conn.commit()
        cur.close()
        conn.close()
        return redirect(url_for('index'))
    else:
        print(form.errors)
    return render_template('cadastro_user.html', form=form)
    
'''
'''
multi lines insert

import psycopg2
from psycopg2.extras import NamedTupleCursor

# Replace these with your actual database connection details
db_params = {
    'dbname': 'postgres',
    'user': 'postgres',
    'password': 'postgres',
    'host': 'localhost',
}

# Define your invoice_line_type as a named tuple
from collections import namedtuple
InvoiceLineType = namedtuple('InvoiceLineType', ['id_product', 'quantity', 'unit_price'])

def insert_invoice_with_lines_array(customer_id, invoice_date, due_date, lines):
    conn = psycopg2.connect(**db_params)
    cursor = conn.cursor(cursor_factory=NamedTupleCursor)

    try:
        # Convert InvoiceLineType objects to tuples for insertion
        lines_data = [(line.id_product, line.quantity, line.unit_price) for line in lines]

        # Execute the function call
        cursor.execute(
            """
            SELECT insert_invoice_with_lines_array(
                %s, %s, %s, %s::invoice_line_type[]
            )
            """,
            (customer_id, invoice_date, due_date, lines_data)
        )

        # Get the returned value from the function
        new_invoice_id = cursor.fetchone()[0]
        conn.commit()

        return new_invoice_id

    finally:
        cursor.close()
        conn.close()

# Example usage
invoice_lines = [
    InvoiceLineType(1, 2, 3),
    InvoiceLineType(4, 5, 6)
]

invoice_id = insert_invoice_with_lines_array(12, '2023-08-01', '2023-08-01', invoice_lines)
print("New invoice ID:", invoice_id)
'''