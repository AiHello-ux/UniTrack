# UniTrack - Database Normalisation

## 1. Normalisation Overview


Normalisation is the process of organising data into relations to reduce data redundancy and avoid insertion, update and deletion anomalies.

The UniTrack database was analysed using functional dependencies, candidate keys and normalisation principles.

The final database contains the following relations:

- DEPARTMENT
- PROGRAM
- FACULTY
- COURSE
- CLASSROOM
- STUDENT
- COURSE_OFFERING
- ENROLLMENT
- ATTENDANCE
- ASSIGNMENT
- SUBMISSION

The database is designed to satisfy First Normal Form (1NF), Second Normal Form (2NF), and Third Normal Form (3NF).

---

## 2. Functional Dependencies and 3NF Analysis

### 2.1 DEPARTMENT

**Relation Schema**

`DEPARTMENT(department_id, name, hod_faculty_id)`

**Candidate Key**

`department_id`

**Functional Dependency**

`department_id → name, hod_faculty_id`

**Verification**

`department_id` is the primary key of DEPARTMENT and uniquely identifies each department.

`hod_faculty_id` is not treated as a candidate key because it is not declared UNIQUE and it can contain NULL values.

**Conclusion**

All non-key attributes depend on the candidate key `department_id`. Therefore, DEPARTMENT satisfies 3NF.

---

### 2.2 PROGRAM

**Relation Schema**

`PROGRAM(program_id, name, duration_years, department_id)`

**Candidate Key**

`program_id`

**Functional Dependency**

`program_id → name, duration_years, department_id`

**Verification**

`program_id` is the primary key and uniquely identifies each programme.

**Conclusion**

All non-key attributes depend directly on `program_id`. Therefore, PROGRAM satisfies 3NF.

---

### 2.3 FACULTY

**Relation Schema**

`FACULTY(faculty_id, name, designation, email, department_id)`

**Candidate Key**

`faculty_id`

**Functional Dependency**

`faculty_id → name, designation, email, department_id`

**Verification**

`faculty_id` is the primary key and uniquely identifies each faculty member.

Although `email` has a UNIQUE constraint, it is nullable in the current schema. Therefore, it is not treated as a candidate key.

**Conclusion**

All non-key attributes depend directly on `faculty_id`. Therefore, FACULTY satisfies 3NF.

---

### 2.4 COURSE

**Relation Schema**

`COURSE(course_id, code, title, credits, department_id)`

**Candidate Keys**

- `course_id`
- `code`

**Functional Dependencies**

`course_id → code, title, credits, department_id`

`code → course_id, title, credits, department_id`

**Verification**

`course_id` is the primary key.

`code` is declared NOT NULL and UNIQUE, so it also uniquely identifies a course and can be treated as a candidate key.

**Conclusion**

The non-key attributes depend on a candidate key. Therefore, COURSE satisfies 3NF.

---

### 2.5 CLASSROOM

**Relation Schema**

`CLASSROOM(classroom_id, building, room_no, capacity)`

**Candidate Key**

`classroom_id`

**Functional Dependency**

`classroom_id → building, room_no, capacity`

**Verification**

`classroom_id` is the primary key and uniquely identifies each classroom.

**Conclusion**

All non-key attributes depend directly on `classroom_id`. Therefore, CLASSROOM satisfies 3NF.

---

### 2.6 STUDENT

**Relation Schema**

`STUDENT(student_id, usn, name, admission_year, program_id)`

**Candidate Keys**

- `student_id`
- `usn`

**Functional Dependencies**

`student_id → usn, name, admission_year, program_id`

`usn → student_id, name, admission_year, program_id`

**Verification**

`student_id` is the primary key.

`usn` is declared NOT NULL and UNIQUE, so it also uniquely identifies a student and can be treated as a candidate key.

**Conclusion**

The non-key attributes depend on a candidate key and there is no partial or transitive dependency within the relation. Therefore, STUDENT satisfies 3NF.

---

### 2.7 COURSE_OFFERING

**Relation Schema**

`COURSE_OFFERING(offering_id, course_id, faculty_id, classroom_id, semester, year)`

**Candidate Key**

`offering_id`

**Functional Dependency**

`offering_id → course_id, faculty_id, classroom_id, semester, year`

**Verification**

`offering_id` is the primary key and uniquely identifies each course offering.

**Conclusion**

All non-key attributes depend directly on `offering_id`. Therefore, COURSE_OFFERING satisfies 3NF.

---

### 2.8 ENROLLMENT

**Relation Schema**

`ENROLLMENT(enrollment_id, student_id, offering_id, grade)`

**Candidate Keys**

- `enrollment_id`
- `(student_id, offering_id)`

**Functional Dependencies**

`enrollment_id → student_id, offering_id, grade`

`(student_id, offering_id) → enrollment_id, grade`

**Verification**

`enrollment_id` is the primary key.

The combination `(student_id, offering_id)` has a UNIQUE constraint. This ensures that a student can be enrolled only once in a particular course offering.

**2NF Analysis**

The relation is in 1NF.

The non-key attribute `grade` depends on the complete candidate key `(student_id, offering_id)` and not on only `student_id` or only `offering_id`.

Therefore, there is no partial dependency.

**Conclusion**

ENROLLMENT satisfies 3NF.

---

### 2.9 ATTENDANCE

**Relation Schema**

`ATTENDANCE(attendance_id, enrollment_id, class_date, status)`

**Candidate Key**

`attendance_id`

**Functional Dependency**

`attendance_id → enrollment_id, class_date, status`

**Verification**

`attendance_id` is the primary key and uniquely identifies each attendance record.

**Conclusion**

All non-key attributes depend directly on `attendance_id`. Therefore, ATTENDANCE satisfies 3NF.

---

### 2.10 ASSIGNMENT

**Relation Schema**

`ASSIGNMENT(assignment_id, offering_id, title, due_date, max_marks)`

**Candidate Key**

`assignment_id`

**Functional Dependency**

`assignment_id → offering_id, title, due_date, max_marks`

**Verification**

`assignment_id` is the primary key and uniquely identifies each assignment.

**Conclusion**

All non-key attributes depend directly on `assignment_id`. Therefore, ASSIGNMENT satisfies 3NF.

---

### 2.11 SUBMISSION

**Relation Schema**

`SUBMISSION(submission_id, assignment_id, student_id, submitted_on, marks)`

**Candidate Key**

`submission_id`

**Functional Dependency**

`submission_id → assignment_id, student_id, submitted_on, marks`

**Verification**

`submission_id` is the primary key and uniquely identifies each submission.

**Conclusion**

All non-key attributes depend directly on `submission_id`. Therefore, SUBMISSION satisfies 3NF.

---

# 3. First Normal Form (1NF)

The UniTrack database satisfies First Normal Form (1NF) because:

- Each attribute contains a single atomic value.
- There are no repeating groups.
- Each relation has a primary key.
- Multiple values are not stored in a single attribute.
- Each row represents a single record.

For example:

`STUDENT(student_id, usn, name, admission_year, program_id)`

stores each student attribute separately.

Therefore, the UniTrack relations satisfy 1NF.

---

# 4. Second Normal Form (2NF)

A relation must first satisfy 1NF before it can satisfy 2NF.

Most UniTrack relations have a single-attribute primary key, such as:

- `department_id`
- `program_id`
- `faculty_id`
- `course_id`
- `student_id`
- `offering_id`
- `attendance_id`
- `assignment_id`
- `submission_id`

Since these keys contain only one attribute, partial dependency cannot occur.

The important case is ENROLLMENT:

`ENROLLMENT(enrollment_id, student_id, offering_id, grade)`

The alternate candidate key is:

`(student_id, offering_id)`

The `grade` attribute depends on the complete combination of `student_id` and `offering_id`, not on only one part of the key.

Therefore, there is no partial dependency.

Hence, the UniTrack database satisfies 2NF.

---

# 5. Third Normal Form (3NF)

A relation must first satisfy 2NF before it can satisfy 3NF.

For 3NF, we check that non-key attributes do not depend on other non-key attributes.

An important example is the relationship between STUDENT, PROGRAM and DEPARTMENT.

Student-specific information is stored in:

`STUDENT(student_id, usn, name, admission_year, program_id)`

Programme-specific information is stored in:

`PROGRAM(program_id, name, duration_years, department_id)`

Department-specific information is stored in:

`DEPARTMENT(department_id, name, hod_faculty_id)`

The dependency chain is:

`student_id → program_id → department_id`

Therefore, programme and department information is not unnecessarily repeated in the STUDENT relation.

Similarly, course information is stored separately from course offerings.

Course information is stored in:

`COURSE(course_id, code, title, credits, department_id)`

Course offering information is stored in:

`COURSE_OFFERING(offering_id, course_id, faculty_id, classroom_id, semester, year)`

This prevents course information such as title and credits from being repeated for every course offering.

Faculty information is also stored separately in FACULTY and referenced by `faculty_id`.

Therefore, entity-specific information is separated into appropriate relations and non-key attributes do not depend on other non-key attributes within the relations.

Hence, the UniTrack database satisfies 3NF.

---

# 6. Normalisation Summary

| Relation | 1NF | 2NF | 3NF |
|---|---|---|---|
| DEPARTMENT | Yes | Yes | Yes |
| PROGRAM | Yes | Yes | Yes |
| FACULTY | Yes | Yes | Yes |
| COURSE | Yes | Yes | Yes |
| CLASSROOM | Yes | Yes | Yes |
| STUDENT | Yes | Yes | Yes |
| COURSE_OFFERING | Yes | Yes | Yes |
| ENROLLMENT | Yes | Yes | Yes |
| ATTENDANCE | Yes | Yes | Yes |
| ASSIGNMENT | Yes | Yes | Yes |
| SUBMISSION | Yes | Yes | Yes |

---

# 7. Examples of Normalised Data

## Student, Programme and Department

Student-specific information is stored in:

`STUDENT(student_id, usn, name, admission_year, program_id)`

Programme-specific information is stored in:

`PROGRAM(program_id, name, duration_years, department_id)`

Department-specific information is stored in:

`DEPARTMENT(department_id, name, hod_faculty_id)`

These relations can be joined when combined information is required.

---

## Course and Course Offering

Course information is stored in:

`COURSE(course_id, code, title, credits, department_id)`

Course offering information is stored in:

`COURSE_OFFERING(offering_id, course_id, faculty_id, classroom_id, semester, year)`

This avoids repeating course details such as title and credits for every course offering.

---

## Student and Course Offering

The relationship between students and course offerings is represented using:

`ENROLLMENT(enrollment_id, student_id, offering_id, grade)`

This allows one student to have multiple enrollments and one course offering to have multiple students.

---

# 8. SQL Verification

The normalization design was verified using SQL queries in `normalization.sql`.

The verification includes:

- Duplicate primary-key checks
- Duplicate student USN checks
- Duplicate course-code checks
- Duplicate student-course-offering enrollment checks
- Functional-dependency consistency checks
- Foreign-key reference checks
- JOIN queries demonstrating relationships between normalized tables

The duplicate and invalid-reference verification queries should return zero rows when the corresponding constraints are satisfied.

The functional-dependency checks verify that a determinant identifies only one corresponding value.

For example:

- One `student_id` corresponds to one `program_id`.
- One `program_id` corresponds to one `department_id`.
- One `course_id` corresponds to one `department_id`.
- One `faculty_id` corresponds to one `department_id`.

JOIN queries demonstrate that information stored in separate normalized relations can be correctly combined when required.

---

# 9. Conclusion

The UniTrack database was analysed using candidate keys and functional dependencies.

The final relational design satisfies:

- **1NF** by storing atomic values without repeating groups.
- **2NF** by eliminating partial dependencies.
- **3NF** by separating entity-specific information and avoiding transitive dependencies.

The final design contains separate relations for departments, programmes, faculty, courses, classrooms, students, course offerings, enrollments, attendance, assignments and submissions.

Primary keys uniquely identify records, while foreign keys establish relationships between the relations.

The normalised structure reduces unnecessary data redundancy, helps prevent insertion, update and deletion anomalies, and maintains referential integrity.

Therefore, the final UniTrack relational database satisfies **Third Normal Form (3NF)**.
