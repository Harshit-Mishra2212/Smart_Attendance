-- ==============================================
-- Create database if not exists
-- ==============================================
CREATE DATABASE IF NOT EXISTS attendance_system;
USE attendance_system;

-- ==============================================
-- Teachers table
-- ==============================================
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS teachers;

CREATE TABLE IF NOT EXISTS teachers (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50)
);

-- ==============================================
-- Students table (branch + class)
-- ==============================================
CREATE TABLE IF NOT EXISTS students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    roll_number VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    branch VARCHAR(50),
    year INT,
    class VARCHAR(10)
);

-- ==============================================
-- Classes table
-- ==============================================
CREATE TABLE IF NOT EXISTS classes (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_name VARCHAR(100) NOT NULL,     -- e.g., "DBMS"
    teacher_id INT,
    year INT,
    class VARCHAR(10),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

-- ==============================================
-- Enrollments (student -> class mapping)
-- ==============================================
CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    class_id INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

-- ==============================================
-- Attendance table
-- ==============================================
CREATE TABLE IF NOT EXISTS attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    class_id INT,
    student_id INT,
    date DATE,
    status ENUM('Present','Absent') NOT NULL,
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);
