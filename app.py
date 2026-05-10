from flask import Flask, render_template, request, redirect, session
import mysql.connector

app = Flask(__name__)
app.secret_key = 'your_secret_key'

# Connect to MySQL
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="your_password",
    database="fir_system"
)
cursor = db.cursor(dictionary=True)

@app.route('/')
def home():
    return render_template('login.html')

@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']
    cursor.execute("SELECT * FROM Users WHERE username=%s AND password=%s", (username, password))
    user = cursor.fetchone()
    if user:
        session['user_id'] = user['user_id']
        session['role'] = user['role']
        return redirect('/dashboard')
    else:
        return "Login Failed"

@app.route('/dashboard')
def dashboard():
    if 'user_id' not in session:
        return redirect('/')
    role = session['role']
    return render_template(f'{role}_dashboard.html')

@app.route('/file-fir', methods=['GET', 'POST'])
def file_fir():
    if request.method == 'POST':
        citizen_id = request.form['citizen_id']
        station_id = request.form['station_id']
        officer_id = request.form['officer_id']
        description = request.form['description']
        cursor.execute("INSERT INTO FIRs (citizen_id, station_id, officer_id, date_filed, description) VALUES (%s, %s, %s, CURDATE(), %s)",
                       (citizen_id, station_id, officer_id, description))
        db.commit()
        return "FIR Filed Successfully"
    cursor.execute("SELECT * FROM Police_Stations")
    stations = cursor.fetchall()
    cursor.execute("SELECT * FROM Police_Officers")
    officers = cursor.fetchall()
    return render_template('file_fir.html', stations=stations, officers=officers)

@app.route('/view-firs')
def view_firs():
    cursor.execute("SELECT f.*, c.name as citizen_name, p.name as officer_name FROM FIRs f JOIN Citizens c ON f.citizen_id = c.citizen_id JOIN Police_Officers p ON f.officer_id = p.officer_id")
    firs = cursor.fetchall()
    return render_template('view_firs.html', firs=firs)

if __name__ == '__main__':
    app.run(debug=True)
