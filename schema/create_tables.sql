-- ============================================================================
-- UniTrack — Relational DDL Schema Definition (Stage 4)
-- Author: K. Jyoshna (AU25UG-026)
-- Role: Logical Designer & DDL Engineer
-- Target RDBMS: MySQL 8.0+ / InnoDB Engine
-- Total Tables: 11 
-- ============================================================================

-- 1. REMOVE OLD DATABASE
DROP DATABASE IF EXISTS unitrack;

-- 2. CREATE NEW DATABASE
CREATE DATABASE unitrack;

-- 3. SELECT DATABASE
USE unitrack;

-- 4. DEPARTMENT
CREATE TABLE DEPARTMENT (
    department_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    hod_faculty_id INT UNIQUE
);

-- 5. PROGRAM
CREATE TABLE PROGRAM (
    program_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    duration_years INT NOT NULL DEFAULT 4,
    department_id INT NOT NULL,

    CONSTRAINT fk_program_department
        FOREIGN KEY (department_id)
        REFERENCES DEPARTMENT(department_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_program_duration
        CHECK (duration_years > 0)
);


-- 6. FACULTY
CREATE TABLE FACULTY (
    faculty_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    designation VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    department_id INT NOT NULL,

    CONSTRAINT fk_faculty_department
        FOREIGN KEY (department_id)
        REFERENCES DEPARTMENT(department_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- 7. COURSE
CREATE TABLE COURSE (
    course_id INT PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    title VARCHAR(150) NOT NULL,
    credits INT NOT NULL DEFAULT 3,
    department_id INT NOT NULL,

    CONSTRAINT fk_course_department
        FOREIGN KEY (department_id)
        REFERENCES DEPARTMENT(department_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_course_credits
        CHECK (credits > 0)
);

-- 8. CLASSROOM
CREATE TABLE CLASSROOM (
    classroom_id INT PRIMARY KEY,
    building VARCHAR(100) NOT NULL,
    room_no VARCHAR(20) NOT NULL,
    capacity INT NOT NULL,

    CONSTRAINT chk_classroom_capacity
        CHECK (capacity > 0)
);

-- 9. STUDENT
CREATE TABLE STUDENT (
    student_id INT PRIMARY KEY,
    usn VARCHAR(30) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    admission_year INT NOT NULL,
    program_id INT NOT NULL,

    CONSTRAINT fk_student_program
        FOREIGN KEY (program_id)
        REFERENCES PROGRAM(program_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- 10. COURSE_OFFERING
CREATE TABLE COURSE_OFFERING (
    offering_id INT PRIMARY KEY,
    course_id INT NOT NULL,
    faculty_id INT NOT NULL,
    classroom_id INT NOT NULL,
    semester VARCHAR(20) NOT NULL,
    year INT NOT NULL,

    CONSTRAINT fk_offering_course
        FOREIGN KEY (course_id)
        REFERENCES COURSE(course_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_offering_faculty
        FOREIGN KEY (faculty_id)
        REFERENCES FACULTY(faculty_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_offering_classroom
        FOREIGN KEY (classroom_id)
        REFERENCES CLASSROOM(classroom_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- 11. ENROLLMENT
CREATE TABLE ENROLLMENT (
    enrollment_id INT PRIMARY KEY,
    student_id INT NOT NULL,
    offering_id INT NOT NULL,
    grade VARCHAR(20) DEFAULT 'In Progress',

    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id)
        REFERENCES STUDENT(student_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_enrollment_offering
        FOREIGN KEY (offering_id)
        REFERENCES COURSE_OFFERING(offering_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT uq_student_offering
        UNIQUE (student_id, offering_id)
);

-- 12. ATTENDANCE
CREATE TABLE ATTENDANCE (
    attendance_id INT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    class_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Present',

    CONSTRAINT fk_attendance_enrollment
        FOREIGN KEY (enrollment_id)
        REFERENCES ENROLLMENT(enrollment_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- 13. ASSIGNMENT
CREATE TABLE ASSIGNMENT (
    assignment_id INT PRIMARY KEY,
    offering_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    due_date DATE NOT NULL,
    max_marks INT NOT NULL,

    CONSTRAINT fk_assignment_offering
        FOREIGN KEY (offering_id)
        REFERENCES COURSE_OFFERING(offering_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_assignment_marks
        CHECK (max_marks > 0)
);


-- 14. SUBMISSION
CREATE TABLE SUBMISSION (
    submission_id INT PRIMARY KEY,
    assignment_id INT NOT NULL,
    student_id INT NOT NULL,
    submitted_on DATETIME DEFAULT CURRENT_TIMESTAMP,
    marks DECIMAL(5,2),

    CONSTRAINT fk_submission_assignment
        FOREIGN KEY (assignment_id)
        REFERENCES ASSIGNMENT(assignment_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_submission_student
        FOREIGN KEY (student_id)
        REFERENCES STUDENT(student_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- 15. DEPARTMENT HEAD / HOD RELATIONSHIP
-- This is added last because DEPARTMENT and FACULTY
-- reference each other.


ALTER TABLE DEPARTMENT
ADD CONSTRAINT fk_department_hod
    FOREIGN KEY (hod_faculty_id)
    REFERENCES FACULTY(faculty_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL;


-- 16. VERIFY TABLES
SHOW TABLES;


-- CHECK TABLE ROW COUNTS
SELECT 'DEPARTMENT' AS table_name, COUNT(*) AS row_count
FROM DEPARTMENT

UNION ALL

SELECT 'PROGRAM', COUNT(*)
FROM PROGRAM

UNION ALL

SELECT 'FACULTY', COUNT(*)
FROM FACULTY

UNION ALL

SELECT 'COURSE', COUNT(*)
FROM COURSE

UNION ALL

SELECT 'CLASSROOM', COUNT(*)
FROM CLASSROOM

UNION ALL

SELECT 'STUDENT', COUNT(*)
FROM STUDENT

UNION ALL

SELECT 'COURSE_OFFERING', COUNT(*)
FROM COURSE_OFFERING

UNION ALL

SELECT 'ENROLLMENT', COUNT(*)
FROM ENROLLMENT

UNION ALL

SELECT 'ATTENDANCE', COUNT(*)
FROM ATTENDANCE

UNION ALL

SELECT 'ASSIGNMENT', COUNT(*)
FROM ASSIGNMENT

UNION ALL

SELECT 'SUBMISSION', COUNT(*)
FROM SUBMISSION;

-- CHECK DATA IN ALL TABLES
SELECT * FROM DEPARTMENT;

SELECT * FROM PROGRAM;

SELECT * FROM FACULTY;

SELECT * FROM COURSE;

SELECT * FROM CLASSROOM;

SELECT * FROM STUDENT;

SELECT * FROM COURSE_OFFERING;

SELECT * FROM ENROLLMENT;

SELECT * FROM ATTENDANCE;

SELECT * FROM ASSIGNMENT;

SELECT * FROM SUBMISSION;
