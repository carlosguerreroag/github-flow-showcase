from flask import Flask, render_template, request, redirect, url_for, session, flash
import psycopg2
from werkzeug.security import check_password_hash
import os
import time
import traceback

# FUNCTIONS
def get_env_or_file(var_name):
    file_var = f"{var_name}_FILE"
    file_path = os.environ.get(file_var)

    if file_path and os.path.exists(file_path):
        try:
            with open(file_path, "r") as f:
                return f.read().strip()
        except Exception as e:
            raise RuntimeError(f"Error reading {file_var}: {e}")

    value = os.environ.get(var_name)
    if not value:
        raise RuntimeError(f"Environment variable {var_name} is not set")

    return value

def get_secret_key():
    return get_env_or_file("SESSION_SECRET_KEY")

def get_password():
    return get_env_or_file("DB_PASSWORD")

def get_db_connection():
    return psycopg2.connect(
        host=os.environ.get('DB_HOST'),
        database=os.environ.get('DB_NAME'),
        user=os.environ.get('DB_USER'),
        password=get_password()
    )

# APP BODY
app = Flask(__name__)
app.secret_key = get_secret_key() 

### API ENDPOINTS
@app.route('/')
def index():
    if 'username' in session:
        return render_template('index.html', username=session['username'])
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        try:
            conn = get_db_connection()
            cur = conn.cursor()
            cur.execute('SELECT password FROM users WHERE username = %s', (username,))
            user = cur.fetchone()
            cur.close()
            conn.close()

            if user and check_password_hash(user[0], password):
                session['username'] = username
                return redirect(url_for('index'))
            
            flash('Username or password incorrect.')
        except Exception as e:
            print("DB ERROR:", repr(e), flush=True)
            flash('Connection to db failed.')
            
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('username', None)
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
