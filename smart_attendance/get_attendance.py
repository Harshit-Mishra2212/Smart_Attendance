# <?php
# include 'db_connect.php';  // adjust path if needed

# $class_id = $_GET['class_id'];

# $sql = "SELECT s.name,
#                SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END) AS presents,
#                COUNT(a.attendance_id) AS total_classes
#         FROM students s
#         JOIN enrollments e ON s.student_id = e.student_id
#         JOIN attendance a ON s.student_id = a.student_id AND e.class_id = a.class_id
#         WHERE e.class_id = ?
#         GROUP BY s.student_id";

# $stmt = $conn->prepare($sql);
# $stmt->bind_param("i", $class_id);
# $stmt->execute();
# $result = $stmt->get_result();

# $rows = array();
# while($row = $result->fetch_assoc()) {
#     $row['attendance_percent'] = $row['total_classes'] > 0 
#                                 ? round(($row['presents'] / $row['total_classes']) * 100, 2) 
#                                 : 0;
#     $rows[] = $row;
# }
# echo json_encode($rows);
# ?>
from flask import Flask, request, jsonify
import mysql.connector

app = Flask(__name__)

# DB connection
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",  # add your MySQL password
    database="attendance_system"
)
cursor = db.cursor(dictionary=True)

@app.route('/get_attendance', methods=['GET'])
def get_attendance():
    class_id = request.args.get('class_id')
    query = """
        SELECT s.name,
               SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END) AS presents,
               COUNT(a.attendance_id) AS total_classes
        FROM students s
        JOIN enrollments e ON s.student_id = e.student_id
        JOIN attendance a ON s.student_id = a.student_id AND e.class_id = a.class_id
        WHERE e.class_id = %s
        GROUP BY s.student_id
    """
    cursor.execute(query, (class_id,))
    results = cursor.fetchall()

    for row in results:
        row['attendance_percent'] = round((row['presents'] / row['total_classes']) * 100, 2) if row['total_classes'] > 0 else 0

    return jsonify(results)

if __name__ == '__main__':
    app.run(debug=True, port=5000)
