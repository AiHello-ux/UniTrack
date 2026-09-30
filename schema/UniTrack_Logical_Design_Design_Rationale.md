# UniTrack — Logical Design & Design Rationale

> **Author:** K. Jyoshna — `AU25UG-026`  
> **Role:** Logical Designer & DDL Engineer (Logical Design + DDL + Design Rationale)  
> **Course:** Database Management Systems (DBMS)  
> **Deliverable:** Stage 4 — Logical Design & Architectural Design Rationale Report  
> **Companion Script:** [`create_tables.sql`](create_tables.sql)  
> **Cross-Reference:** [`docs/design_rationale.md`](../docs/design_rationale.md)

---

## 1. Overview & Logical Design

The UniTrack database is designed as a fully normalized relational database implemented on **MySQL 8.0+ / InnoDB Engine**. Each entity identified in the conceptual ER diagram is mapped directly to a relational table. Primary keys uniquely identify individual records, while foreign keys establish deterministic relationships and preserve referential integrity across the system.

Below is the complete entity-relational specification for all 11 tables:

### 1.1. DEPARTMENT
Represents academic departments that manage degree programs, courses, and faculty members.

| Attribute | Key | Data Type | Nullable | Description |
| :--- | :---: | :---: | :---: | :--- |
| `department_id` | **PK** | `INT` | No | Unique department identifier |
| `name` | — | `VARCHAR(100)` | No | Department name (e.g., Computer Science) |
| `hod_faculty_id` | **FK** | `INT` | Yes | Head of Department; references `FACULTY(faculty_id)` |

---

### 1.2. PROGRAM
Represents formal academic degree programs offered by departments.

| Attribute | Key | Data Type | Nullable | Description |
| :--- | :---: | :---: | :---: | :--- |
| `program_id` | **PK** | `INT` | No | Unique programme identifier |
| `name` | — | `VARCHAR(100)` | No | Programme name (e.g., B.Tech Computer Science) |
| `duration_years` | — | `INT` | No | Length of the programme in years (`DEFAULT 4`) |
| `department_id` | **FK** | `INT` | No | Department that offers the programme; references `DEPARTMENT(department_id)` |

---

### 1.3. STUDENT
Represents matriculated students admitted into specific academic degree programs.

| Attribute | Key | Data Type | Nullable | Description |
| :--- | :---: | :---: | :---: | :--- |
| `student_id` | **PK** | `INT` | No | Unique surrogate student identifier |
| `usn` | **UNIQUE** | `VARCHAR(20)` | No | University serial number (institutional natural key) |
| `name` | — | `VARCHAR(100)` | No | Full student name |
| `admission_year` | — | `INT` | No | Calendar year of university admission |
| `program_id` | **FK** | `INT` | No | Programme the student is enrolled in; references `PROGRAM(program_id)` |

---

### 1.4. FACULTY
Represents academic teaching staff and professors employed by academic departments.

| Attribute | Key | Data Type | Nullable | Description |
| :--- | :---: | :---: | :---: | :--- |
| `faculty_id` | **PK** | `INT` | No | Unique faculty identifier |
| `name` | — | `VARCHAR(100)` | No | Faculty member name |
| `designation` | — | `VARCHAR(50)` | No | Academic rank (Professor, Associate Professor, Assistant Professor, Lecturer) |
| `email` | **UNIQUE** | `VARCHAR(100)` | Yes | Institutional email address |
| `department_id` | **FK** | `INT` | No | Department the faculty belongs to; references `DEPARTMENT(department_id)` |

---

### 1.5. COURSE
Represents master catalog definitions for academic courses.

| Attribute | Key | Data Type | Nullable | Description |
| :--- | :---: | :---: | :---: | :--- |
| `course_id` | **PK** | `INT` | No | Unique course identifier |
| `code` | **UNIQUE** | `VARCHAR(20)` | No | Official course code (e.g., CS101, EE201) |
| `title` | — | `VARCHAR(100)` | No | Descriptive course title |
| `credits` | — | `INT` | No | Academic credit weight (`DEFAULT 3`) |
| `department_id` | **FK** | `INT` | No | Department that owns the course; references `DEPARTMENT(department_id)` |

---

### 1.6. CLASSROOM
Represents physical lecture halls, seminar rooms, and laboratories.

| Attribute | Key | Data Type | Nullable | Description |
| :--- | :---: | :---: | :---: | :--- |
| `classroom_id` | **PK** | `INT` | No | Unique classroom identifier |
| `building` | — | `VARCHAR(50)` | No | Campus building name (e.g., Main Block, Science Block) |
| `room_no` | — | `VARCHAR(20)` | No | Room number within the building |
| `capacity` | — | `INT` | No | Maximum seating capacity of the classroom |

---

### 1.7. COURSE_OFFERING
Represents a specific semester-term instance or section of an academic course.

| Attribute | Key | Data Type | Nullable | Description |
| :--- | :---: | :---: | :---: | :--- |
| `offering_id` | **PK** | `INT` | No | Unique offering identifier |
| `semester` | — | `VARCHAR(20)` | No | Academic term (`Fall`, `Spring`, `Summer`) |
| `year` | — | `INT` | No | Calendar year of the offering |
| `course_id` | **FK** | `INT` | No | Course being offered; references `COURSE(course_id)` |
| `faculty_id` | **FK** | `INT` | No | Faculty member assigned to teach; references `FACULTY(faculty_id)` |
| `classroom_id` | **FK** | `INT` | No | Scheduled venue; references `CLASSROOM(classroom_id)` |

---

### 1.8. ENROLLMENT
Represents a student's active registration in a course offering, acting as the academic bridge entity.

| Attribute | Key | Data Type | Nullable | Description |
| :--- | :---: | :---: | :---: | :--- |
| `enrollment_id` | **PK** | `INT` | No | Unique enrollment identifier |
| `grade` | — | `VARCHAR(20)` | No | Final grade awarded (`DEFAULT 'In Progress'`) |
| `student_id` | **FK** | `INT` | No | Registered student; references `STUDENT(student_id)` |
| `offering_id` | **FK** | `INT` | No | Course offering section; references `COURSE_OFFERING(offering_id)` |

> *Note:* Composite natural candidate key `(student_id, offering_id)` is enforced via a `UNIQUE` constraint to prevent duplicate registrations.

---

### 1.9. ATTENDANCE
Represents daily attendance audit records for enrolled students during class sessions.

| Attribute | Key | Data Type | Nullable | Description |
| :--- | :---: | :---: | :---: | :--- |
| `attendance_id` | **PK** | `INT` | No | Unique attendance record identifier |
| `class_date` | — | `DATE` | No | Date of the scheduled class session |
| `status` | — | `VARCHAR(20)` | No | Attendance status (`Present`, `Absent`, `Late`, `Excused`) |
| `enrollment_id` | **FK** | `INT` | No | Verified enrollment registration; references `ENROLLMENT(enrollment_id)` |

---

### 1.10. ASSIGNMENT
Represents graded coursework tasks, projects, and homework issued for a course offering.

| Attribute | Key | Data Type | Nullable | Description |
| :--- | :---: | :---: | :---: | :--- |
| `assignment_id` | **PK** | `INT` | No | Unique assignment identifier |
| `title` | — | `VARCHAR(100)` | No | Assignment title / topic |
| `due_date` | — | `DATE` | No | Official submission deadline |
| `max_marks` | — | `INT` | No | Maximum marks achievable |
| `offering_id` | **FK** | `INT` | No | Offering section setting the task; references `COURSE_OFFERING(offering_id)` |

---

### 1.11. SUBMISSION
Represents individual student submissions against designated coursework assignments.

| Attribute | Key | Data Type | Nullable | Description |
| :--- | :---: | :---: | :---: | :--- |
| `submission_id` | **PK** | `INT` | No | Unique submission identifier |
| `submitted_on` | — | `DATETIME` | No | Timestamp of submission (`DEFAULT CURRENT_TIMESTAMP`) |
| `marks` | — | `DECIMAL(5,2)` | Yes | Score awarded by the instructor |
| `assignment_id` | **FK** | `INT` | No | Assignment being submitted; references `ASSIGNMENT(assignment_id)` |
| `student_id` | **FK** | `INT` | No | Submitting student; references `STUDENT(student_id)` |

---

## 2. Relationships and Cardinality Matrix

All 14 relationships established in the conceptual Chen ER diagram are mapped losslessly into the relational model:

| Relationship | Participating Entities | Cardinality | Business Meaning & Rule |
| :--- | :--- | :---: | :--- |
| **Offers** | `DEPARTMENT`, `PROGRAM` | 1:M | A department offers many academic programmes; each programme belongs to exactly one department. |
| **Owns** | `DEPARTMENT`, `COURSE` | 1:M | A department owns many courses; each course is cataloged under one department. |
| **Employs** | `DEPARTMENT`, `FACULTY` | 1:M | A department employs multiple faculty members; each faculty member belongs to one home department. |
| **Heads** | `DEPARTMENT`, `FACULTY` | 1:1 | A department is chaired by one Head of Department (HOD); an individual faculty member can head at most one department. |
| **Admits** | `PROGRAM`, `STUDENT` | 1:M | A degree programme admits many students; each student matriculates under exactly one programme. |
| **Scheduled As** | `COURSE`, `COURSE_OFFERING` | 1:M | A catalog course can be offered across multiple semesters; each offering is an instance of one course. |
| **Teaches** | `FACULTY`, `COURSE_OFFERING` | 1:M | A faculty member instructs multiple course offerings; each course offering section has one assigned instructor. |
| **Hosts** | `CLASSROOM`, `COURSE_OFFERING` | 1:M | A classroom hosts multiple course offering time slots; each offering takes place in one assigned classroom. |
| **Registers** | `STUDENT`, `ENROLLMENT` | 1:M | A student registers for multiple course enrollments; each enrollment belongs to one student. |
| **Contains** | `COURSE_OFFERING`, `ENROLLMENT` | 1:M | A course offering section contains many student enrollments; each enrollment belongs to one offering. |
| **Sets** | `COURSE_OFFERING`, `ASSIGNMENT` | 1:M | An offering section issues multiple coursework assignments; each assignment belongs to one offering. |
| **Records** | `ENROLLMENT`, `ATTENDANCE` | 1:M | An enrollment maintains multiple daily attendance logs; each attendance entry belongs to one enrollment. |
| **Receives** | `ASSIGNMENT`, `SUBMISSION` | 1:M | An assignment receives multiple student submissions; each submission corresponds to one assignment. |
| **Submits** | `STUDENT`, `SUBMISSION` | 1:M | A student uploads multiple assignment submissions; each submission is attributed to one student. |

---

## 3. Architectural Design Rationales

### 3.1. Resolution of the Circular Foreign Key Dependency
- **Problem:** A mutually recursive dependency exists between `DEPARTMENT` and `FACULTY`:
  - `DEPARTMENT.hod_faculty_id` references `FACULTY.faculty_id`.
  - `FACULTY.department_id` references `DEPARTMENT.department_id`.
  - Creating both tables with inline mandatory `NOT NULL` foreign keys causes a chicken-and-egg failure during DDL script execution.
- **Engineered Solution:**
  1. `DEPARTMENT` is created first with `hod_faculty_id INT NULL` (without an inline foreign key constraint).
  2. `FACULTY` is created second with `department_id INT NOT NULL REFERENCES DEPARTMENT(department_id)`.
  3. A deferred `ALTER TABLE` statement attaches the foreign key constraint cleanly:
     ```sql
     ALTER TABLE DEPARTMENT
     ADD CONSTRAINT fk_department_hod
         FOREIGN KEY (hod_faculty_id)
         REFERENCES FACULTY(faculty_id)
         ON UPDATE CASCADE
         ON DELETE SET NULL;
     ```
  4. Initial seeding inserts departments with `NULL` for `hod_faculty_id`, inserts faculty members, and subsequently executes `UPDATE DEPARTMENT SET hod_faculty_id = ...`.
  5. **Why this is superior:** This completely avoids disabling foreign key checks (`SET FOREIGN_KEY_CHECKS = 0`), adhering to rigorous enterprise database standards.

---

### 3.2. Separation of Courses from Semester Offerings
- **Design Decision:** The system splits course management into two distinct entities:
  - `COURSE`: Master course catalog definition (`course_id`, `code`, `title`, `credits`, `department_id`).
  - `COURSE_OFFERING`: Specific temporal term section (`offering_id`, `course_id`, `faculty_id`, `classroom_id`, `semester`, `year`).
- **Rationale:** A course such as *Database Management Systems (CS201)* has static academic attributes that persist for decades. However, its semester offerings change dynamically by instructor, room, and term. Merging them into a single relation would introduce severe redundancy and violate 2NF, requiring credits and titles to be repeated across every offering.

---

### 3.3. Direct Attendance Linking via Enrollment Bridge
- **Design Decision:** `ATTENDANCE` references `ENROLLMENT(enrollment_id)` rather than storing composite `(student_id, offering_id, class_date)`.
- **Rationale:**
  - If `ATTENDANCE` referenced `STUDENT` and `COURSE_OFFERING` independently, an application bug or rogue query could insert an attendance log for a student in a course offering they were never registered in.
  - By referencing `ENROLLMENT.enrollment_id`, the database engine physically guarantees that an attendance record can only exist for a student who possesses an active, valid enrollment row.

---

### 3.4. Surrogate Primary Keys vs. Composite Natural Keys
- **Design Decision:** All 11 relations utilize single-column integer surrogate primary keys (`table_id`), combined with explicit `UNIQUE` candidate key constraints where natural uniqueness exists (e.g., `STUDENT.usn`, `COURSE.code`, `FACULTY.email`, `(student_id, offering_id)`).
- **Rationale:**
  - **Index Efficiency:** In MySQL's InnoDB storage engine, secondary indexes store the clustered index key. Using compact integer primary keys minimizes B-tree index depth and I/O overhead.
  - **Foreign Key Join Performance:** Joining on a single 4-byte integer `enrollment_id` is vastly faster than multi-column composite joins on `(student_id, offering_id)`.
  - **Cascading Stability:** Natural keys like email addresses or roll numbers occasionally undergo institutional reformatting. Isolating primary keys from business values prevents massive cascading updates across child rows.

---

### 3.5. Default Constraints for Academic Workflows
- **Design Decision:** Incorporating standard default values for key attributes:
  - `PROGRAM.duration_years`: `DEFAULT 4` (standard undergraduate bachelor's degree duration).
  - `COURSE.credits`: `DEFAULT 3` (standard lecture credit weight).
  - `ENROLLMENT.grade`: `DEFAULT 'In Progress'` (default lifecycle state until semester grading concludes).
  - `ATTENDANCE.status`: `DEFAULT 'Present'` (standard assumption during class attendance calls).
  - `SUBMISSION.submitted_on`: `DEFAULT CURRENT_TIMESTAMP` (automated timestamping upon file upload).
- **Rationale:** Eliminates boilerplate in client applications, prevents unintended NULLs in analytical queries, and satisfies Stage 4 constraint criteria.

---

## 4. Referential Integrity Policy Matrix

| Foreign Key Constraint | Source Table & Column | Target Table & Column | ON UPDATE | ON DELETE | Architectural Justification |
| :--- | :--- | :--- | :---: | :---: | :--- |
| `fk_program_department` | `PROGRAM(department_id)` | `DEPARTMENT(department_id)` | `CASCADE` | `RESTRICT` | Prevent deletion of a department while it still hosts active degree programs. |
| `fk_faculty_department` | `FACULTY(department_id)` | `DEPARTMENT(department_id)` | `CASCADE` | `RESTRICT` | Prevent orphaned faculty records if a department is targeted for deletion. |
| `fk_course_department` | `COURSE(department_id)` | `DEPARTMENT(department_id)` | `CASCADE` | `RESTRICT` | Prevent deletion of a department while its academic courses remain in the catalog. |
| `fk_department_hod` | `DEPARTMENT(hod_faculty_id)` | `FACULTY(faculty_id)` | `CASCADE` | `SET NULL` | If an HOD retires or leaves, the department remains intact; headship becomes temporarily vacant (`NULL`). |
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

## 5. DDL Implementation Blueprint

The physical schema is implemented in [`schema/create_tables.sql`](create_tables.sql). The script follows strict sequential stages:
1. `DROP DATABASE IF EXISTS unitrack;` & `CREATE DATABASE unitrack;`
2. Creation of standalone/parent entities (`DEPARTMENT`, `PROGRAM`, `FACULTY`, `COURSE`, `CLASSROOM`, `STUDENT`).
3. Creation of dependent offering and bridge entities (`COURSE_OFFERING`, `ENROLLMENT`).
4. Creation of leaf transaction entities (`ATTENDANCE`, `ASSIGNMENT`, `SUBMISSION`).
5. Execution of `ALTER TABLE DEPARTMENT ADD CONSTRAINT fk_department_hod`.
6. Verification commands: `SHOW TABLES;` and table row count audits.

---
*Report authored by **K. Jyoshna** (`AU25UG-026`) — Logical Designer & DDL Engineer.*
