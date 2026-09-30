# UniTrack — Logical Design & Architectural Rationale

> **Author:** K. Jyoshna — `AU25UG-026`  
> **Role:** Logical Designer & DDL Engineer (Logical Design + DDL + Design Rationale)  
> **Course:** Database Management Systems (DBMS)  
> **Deliverable:** Stage 4 — Logical Design & Architectural Rationale Report  
> **Companion Script:** [`schema/create_tables.sql`](../schema/create_tables.sql)

---

## 1. Overview & ER-to-Relational Mapping

The logical database design transforms the conceptual Chen ER model into an **Eleven-Relation Normalized Relational Schema** implemented on **MySQL 8.0+ / InnoDB**. The primary goals are:
- Strictly preserving all functional dependencies and integrity constraints.
- Eliminating relational anomalies (insertion, deletion, update) through Third Normal Form (3NF).
- Providing deterministic referential actions (`CASCADE`, `RESTRICT`, `SET NULL`) across all 14 foreign keys.

---

## 2. Architectural Design Rationales

### 2.1. Resolution of the Circular Foreign Key Dependency
- **Problem:** A mutually recursive dependency exists between `DEPARTMENT` and `FACULTY`:
  - A department must have a Head of Department (`hod_faculty_id` referencing `FACULTY.faculty_id`).
  - A faculty member must belong to an academic department (`department_id` referencing `DEPARTMENT.department_id`).
  - Creating both tables with mandatory `NOT NULL` foreign keys at table creation time causes a fatal chicken-and-egg failure during DDL execution.
- **Engineered Solution:**
  1. `DEPARTMENT` is created first with `hod_faculty_id INT NULL` (without an inline foreign key constraint).
  2. `FACULTY` is created second with `department_id INT NOT NULL REFERENCES DEPARTMENT(department_id)`.
  3. An `ALTER TABLE` statement is executed to attach the foreign key:
     ```sql
     ALTER TABLE DEPARTMENT
     ADD CONSTRAINT fk_department_hod
         FOREIGN KEY (hod_faculty_id)
         REFERENCES FACULTY(faculty_id)
         ON UPDATE CASCADE
         ON DELETE SET NULL;
     ```
  4. When inserting initial records, departments are inserted with `NULL` for `hod_faculty_id`. Faculty members are then inserted, and a single `UPDATE DEPARTMENT SET hod_faculty_id = ...` attaches the heads.
  5. **Why this is superior:** This completely avoids disabling foreign key checks (`SET FOREIGN_KEY_CHECKS = 0`), upholding enterprise database engineering standards.

---

### 2.2. Separation of Courses from Semester Offerings
- **Design Decision:** The system splits course management into two separate entities:
  - `COURSE`: Master course catalog definition (`course_id`, `code`, `title`, `credits`, `department_id`).
  - `COURSE_OFFERING`: Specific temporal term section (`offering_id`, `course_id`, `faculty_id`, `classroom_id`, `semester`, `year`).
- **Rationale:** A course like *Database Management Systems (CS201)* has static academic attributes that persist for decades. However, its semester offerings change dynamically by instructor, room, and term. Merging them into a single relation would introduce severe redundancy and violate 2NF, requiring course credits and titles to be repeated across every semester offering.

---

### 2.3. Direct Attendance Linking via Enrollment Bridge
- **Design Decision:** `ATTENDANCE` references `ENROLLMENT(enrollment_id)` rather than storing composite `(student_id, offering_id, class_date)`.
- **Rationale:**
  - If `ATTENDANCE` referenced `STUDENT` and `COURSE_OFFERING` independently, an application error or rogue query could insert an attendance log for a student in a course offering they were never registered in.
  - By foreign-key referencing `ENROLLMENT.enrollment_id`, the database engine physically guarantees that an attendance record can only exist for a student who possesses an active, valid enrollment row.

---

### 2.4. Surrogate Primary Keys vs. Composite Natural Keys
- **Design Decision:** All 11 relations utilize single-column integer surrogate primary keys (`table_id`), combined with explicit `UNIQUE` candidate key constraints where natural uniqueness exists (e.g., `STUDENT.usn`, `COURSE.code`, `FACULTY.email`, `(student_id, offering_id)`).
- **Rationale:**
  - **Index Efficiency:** In MySQL's InnoDB storage engine, secondary indexes store the clustered index key. Using compact integer primary keys minimizes B-tree index depth and I/O overhead.
  - **Foreign Key Join Performance:** Joining on a single 4-byte integer `enrollment_id` is vastly faster than multi-column composite joins on `(student_id, offering_id)`.
  - **Cascading Stability:** Natural keys like email addresses or roll numbers occasionally undergo institutional reformatting. Isolating primary keys from business values prevents massive cascading updates across millions of child rows.

---

### 2.5. Default Constraints for Academic Workflows
- **Design Decision:** Incorporating standard default values for key attributes:
  - `PROGRAM.duration_years`: `DEFAULT 4` (standard undergraduate bachelor's degree duration).
  - `COURSE.credits`: `DEFAULT 3` (standard lecture credit weight).
  - `ENROLLMENT.grade`: `DEFAULT 'In Progress'` (default lifecycle state until semester grading concludes).
  - `ATTENDANCE.status`: `DEFAULT 'Present'` (standard assumption during class attendance calls).
  - `SUBMISSION.submitted_on`: `DEFAULT CURRENT_TIMESTAMP` (automated timestamping upon file upload).
- **Rationale:** Eliminates boilerplate in client applications, prevents unintended NULLs in analytical queries, and satisfies Stage 4 constraint criteria.

---

## 3. Referential Integrity Policy Matrix

| Foreign Key Constraint | Source Table & Column | Target Table & Column | ON UPDATE | ON DELETE | Architectural Justification |
|:---|:---|:---|:---:|:---:|:---|
| `fk_program_department` | `PROGRAM(department_id)` | `DEPARTMENT(department_id)` | `CASCADE` | `RESTRICT` | Prevent deletion of a department while it still hosts active degree programs. |
| `fk_faculty_department` | `FACULTY(department_id)` | `DEPARTMENT(department_id)` | `CASCADE` | `RESTRICT` | Prevent orphaned faculty records if a department is targeted for deletion. |
| `fk_course_department` | `COURSE(department_id)` | `DEPARTMENT(department_id)` | `CASCADE` | `RESTRICT` | Prevent deletion of a department while its academic courses remain in the catalog. |
| `fk_department_hod` | `DEPARTMENT(hod_faculty_id)` | `FACULTY(faculty_id)` | `CASCADE` | `SET NULL` | If an HOD retires or leaves, the department remains intact; headship becomes temporarily vacant (NULL). |
| `fk_student_program` | `STUDENT(program_id)` | `PROGRAM(program_id)` | `CASCADE` | `RESTRICT` | A degree program cannot be purged if active students are matriculated within it. |
| `fk_offering_course` | `COURSE_OFFERING(course_id)` | `COURSE(course_id)` | `CASCADE` | `RESTRICT` | Historical semester offerings must preserve their catalog course linkage. |
| `fk_offering_faculty` | `COURSE_OFFERING(faculty_id)` | `FACULTY(faculty_id)` | `CASCADE` | `RESTRICT` | Prevents removing faculty records that are assigned to past or current semester offerings. |
| `fk_offering_classroom` | `COURSE_OFFERING(classroom_id)` | `CLASSROOM(classroom_id)` | `CASCADE` | `RESTRICT` | Classrooms cannot be deleted while assigned to scheduled course offerings. |
| `fk_enrollment_student` | `ENROLLMENT(student_id)` | `STUDENT(student_id)` | `CASCADE` | `RESTRICT` | Protects academic transcripts; students with enrollment records cannot be deleted accidentally. |
| `fk_enrollment_offering` | `ENROLLMENT(offering_id)` | `COURSE_OFFERING(offering_id)` | `CASCADE` | `RESTRICT` | Offerings with enrolled students cannot be dropped from the system. |
| `fk_attendance_enrollment` | `ATTENDANCE(enrollment_id)` | `ENROLLMENT(enrollment_id)` | `CASCADE` | `RESTRICT` | Attendance history is strictly bounded by active course enrollments. |
| `fk_assignment_offering` | `ASSIGNMENT(offering_id)` | `COURSE_OFFERING(offering_id)` | `CASCADE` | `RESTRICT` | Coursework assignments must be anchored to an offering. |
| `fk_submission_assignment` | `SUBMISSION(assignment_id)` | `ASSIGNMENT(assignment_id)` | `CASCADE` | `RESTRICT` | Student submissions cannot be orphaned from their parent assignment. |
| `fk_submission_student` | `SUBMISSION(student_id)` | `STUDENT(student_id)` | `CASCADE` | `RESTRICT` | Student attribution on submitted coursework is permanently preserved. |

---

## 4. DDL Implementation Blueprint

The physical schema is implemented in [`schema/create_tables.sql`](../schema/create_tables.sql). The script follows strict sequential stages:
1. `DROP DATABASE IF EXISTS unitrack` & `CREATE DATABASE unitrack`.
2. Creation of standalone/parent entities (`DEPARTMENT`, `PROGRAM`, `FACULTY`, `COURSE`, `CLASSROOM`, `STUDENT`).
3. Creation of dependent offering and bridge entities (`COURSE_OFFERING`, `ENROLLMENT`).
4. Creation of leaf transaction entities (`ATTENDANCE`, `ASSIGNMENT`, `SUBMISSION`).
5. Execution of `ALTER TABLE DEPARTMENT ADD CONSTRAINT fk_department_hod`.
6. Verification commands: `SHOW TABLES;` and row count checks.
