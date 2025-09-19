import mysql.connector
from flask import Flask, request, jsonify

# ================================
# Flask App
# ================================
app = Flask(__name__)

# ✅ Connect to MySQL database
db = mysql.connector.connect(
    host="localhost",
    user="root",          # change if you have a different user
    password="gaurish16", # change to your MySQL root password
    database="attendance_system"
)

cursor = db.cursor(dictionary=True)  # dictionary=True → results as dict for JSON

# ================================
# Functions (same as before, using INSERT IGNORE)
# ================================

def add_student(roll_number, name, branch, year, class_name):
    query = """
        INSERT IGNORE INTO students (roll_number, name, branch, year, class)
        VALUES (%s, %s, %s, %s, %s)
    """
    values = (roll_number, name, branch, year, class_name)
    cursor.execute(query, values)
    db.commit()

def add_teacher(name, department):
    query = """
        INSERT IGNORE INTO teachers (name, department)
        VALUES (%s, %s)
    """
    cursor.execute(query, (name, department))
    db.commit()

def add_class(subject_name, teacher_id, year, class_name):
    query = """
        INSERT IGNORE INTO classes (subject_name, teacher_id, year, class)
        VALUES (%s, %s, %s, %s)
    """
    cursor.execute(query, (subject_name, teacher_id, year, class_name))
    db.commit()

def enroll_student(student_id, class_id):
    query = """
        INSERT IGNORE INTO enrollments (student_id, class_id)
        VALUES (%s, %s)
    """
    cursor.execute(query, (student_id, class_id))
    db.commit()

def mark_attendance(class_id, student_id, date, status):
    query = """
        INSERT IGNORE INTO attendance (class_id, student_id, date, status)
        VALUES (%s, %s, %s, %s)
    """
    cursor.execute(query, (class_id, student_id, date, status))
    db.commit()

# ================================
# API Endpoints
# ================================

@app.route("/")
def home():
    return {"message": "✅ Attendance API is running!"}

# ---- Add entities ----
@app.route("/add_student", methods=["POST"])
def api_add_student():
    data = request.json
    add_student(data["roll_number"], data["name"], data["branch"], data["year"], data["class"])
    return {"message": f"Student {data['name']} added (or ignored if duplicate)."}

@app.route("/add_teacher", methods=["POST"])
def api_add_teacher():
    data = request.json
    add_teacher(data["name"], data["department"])
    return {"message": f"Teacher {data['name']} added (or ignored if duplicate)."}

@app.route("/add_class", methods=["POST"])
def api_add_class():
    data = request.json
    add_class(data["subject_name"], data["teacher_id"], data["year"], data["class"])
    return {"message": f"Class {data['subject_name']} added (or ignored if duplicate)."}

@app.route("/enroll_student", methods=["POST"])
def api_enroll_student():
    data = request.json
    enroll_student(data["student_id"], data["class_id"])
    return {"message": f"Student {data['student_id']} enrolled in class {data['class_id']}."}

@app.route("/mark_attendance", methods=["POST"])
def api_mark_attendance():
    data = request.json
    mark_attendance(data["class_id"], data["student_id"], data["date"], data["status"])
    return {"message": f"Attendance marked for student {data['student_id']}."}

# ---- Reports ----
@app.route("/class/<int:class_id>", methods=["GET"])
def api_get_class_attendance(class_id):
    query = """
        SELECT s.name, 
               COUNT(CASE WHEN a.status='Present' THEN 1 END) AS attended,
               COUNT(*) AS total_classes
        FROM students s
        JOIN enrollments e ON s.student_id = e.student_id
        JOIN attendance a ON a.student_id = s.student_id AND a.class_id = e.class_id
        WHERE e.class_id = %s
        GROUP BY s.student_id
    """
    cursor.execute(query, (class_id,))
    return jsonify(cursor.fetchall())

@app.route("/student/<int:student_id>", methods=["GET"])
def api_get_student_attendance(student_id):
    query = """
        SELECT c.subject_name,
               COUNT(CASE WHEN a.status='Present' THEN 1 END) AS attended,
               COUNT(*) AS total_classes
        FROM classes c
        JOIN enrollments e ON c.class_id = e.class_id
        JOIN attendance a ON a.class_id = c.class_id AND a.student_id = e.student_id
        WHERE e.student_id = %s
        GROUP BY c.class_id
    """
    cursor.execute(query, (student_id,))
    return jsonify(cursor.fetchall())

# ================================
# Run Flask Server
# ================================
if __name__ == "__main__":
    app.run(debug=True)
