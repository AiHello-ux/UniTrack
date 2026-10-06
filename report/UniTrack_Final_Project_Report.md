# 🎓 UniTrack — University Academic Management System
## DBMS Final Project Report

---

<div align="center">

# 🏛️ UNITRACK DATABASE SYSTEM
### *Relational Database for University Academic Management*

**Subject:** Database Management Systems (DBMS)  
**Academic Year:** 2024–2025 | **Database:** MySQL 8.0+ (InnoDB Engine)  
**Normalization:** Third Normal Form (3NF)  
**Scale:** 11 Tables, 14 Foreign Keys, 3 Semesters (Fall 2024 – Fall 2025)

---

### 👥 Project Team (Team 4)

| Student Name | USN | Project Role |
| :--- | :---: | :--- |
| **Konduru Nanda Kishore Raju** | `AU25UG-028` | **Team Lead:** Requirements & System Scope |
| **Melvin Jacob** | `AU25UG-034` | **ER Modeler:** Conceptual ER Design & Mapping |
| **K. Jyoshna** | `AU25UG-026` | **Schema Designer:** Relational Schema & DDL Scripts |
| **Monica Irala** | `AU25UG-037` | **Normalization Lead:** Functional Dependencies & 3NF |
| **Naidile D** | `AU25UG-038` | **Data Engineer:** Data Insertion & Testing Data |
| **Padmaraju Poojitha** | `AU25UG-043` | **SQL Analyst:** Complex Queries & Workbench Testing |

---

</div>

<br/>

## 📑 Table of Contents

1. [Project Overview](#1-project-overview)
2. [Problem Statement & Scope](#2-problem-statement--scope)
3. [System Requirements & Business Rules](#3-system-requirements--business-rules)
4. [ER Modeling & Conceptual Design](#4-er-modeling--conceptual-design)
5. [Relational Schema & Data Dictionary](#5-relational-schema--data-dictionary)
6. [Key Design Decisions](#6-key-design-decisions)
7. [Database Normalization (1NF, 2NF, 3NF)](#7-database-normalization-1nf-2nf-3nf)
8. [Database Implementation & Data Summary](#8-database-implementation--data-summary)
9. [SQL Queries & Results (Q1–Q10)](#9-sql-queries--results-q1q10)
10. [Testing & Integrity Checks](#10-testing--integrity-checks)
11. [Conclusion & Future Work](#11-conclusion--future-work)
12. [Team Contributions](#12-team-contributions)

---

## 1. Project Overview

Colleges handle many everyday activities—managing departments, degree programs, teachers, classrooms, student admissions, course enrollments, attendance, and assignment marks. 

When this information is kept in Excel sheets or unorganized tables, common problems happen:
- The same data is entered multiple times (duplicate data).
- Updating a teacher's or student's details in one place leaves old data in another place.
- Deleting an entry can accidentally delete important linked information.

**UniTrack** is a centralized relational database built using **MySQL 8.0+**. It organizes all university data into **11 clean tables** normalized to **Third Normal Form (3NF)**. It ensures that data remains correct, relationships stay valid using 14 foreign keys, and college staff can quickly get answers to important academic questions using SQL queries.

---

## 2. Problem Statement & Scope

### 2.1 Common Problems in Manual / Excel Systems
1. **Repeated Data:** Student and teacher details get retyped in multiple sheets, leading to spelling differences and mismatching data.
2. **Missing Links:** If a course is removed, old attendance or grade records are left behind with no valid course attached.
3. **Wrong Attendance:** Attendance might get marked for a student who never enrolled in that subject.
4. **Course Confusion:** Re-entering course name, syllabus, and credits every semester instead of keeping one master course list.

### 2.2 UniTrack Solution Modules
The project divides the university system into four simple parts:

```
┌────────────────────────────────────────────────────────────────────────┐
│                        UNITRACK SYSTEM MODULES                         │
├────────────────────────────────────────────────────────────────────────┤
│ 1. Academics:             DEPARTMENT, PROGRAM, COURSE                  │
│ 2. Staff & Rooms:         FACULTY, CLASSROOM                           │
│ 3. Students & Courses:    STUDENT, COURSE_OFFERING, ENROLLMENT         │
│ 4. Attendance & Marks:    ATTENDANCE, ASSIGNMENT, SUBMISSION           │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 3. System Requirements & Business Rules

### 3.1 Functional Requirements

| ID | Module | What the System Must Do | Enforced By |
| :---: | :--- | :--- | :--- |
| **FR-01** | Department | Store department ID and unique department name. | `DEPARTMENT.department_id` (PK) |
| **FR-02** | HOD | Each department has at most one faculty member as HOD. | `DEPARTMENT.hod_faculty_id` (FK) |
| **FR-03** | Programs | Departments offer programs with positive duration in years. | `PROGRAM.duration_years > 0` |
| **FR-04** | Faculty | Store faculty details with unique email ID and department. | `FACULTY.email` (UNIQUE) |
| **FR-05** | Courses | Maintain course catalog with unique code and positive credits. | `COURSE.code` (UNIQUE), `credits > 0` |
| **FR-06** | Classrooms | Store room number, campus block, and seating capacity. | `CLASSROOM.capacity > 0` |
| **FR-07** | Offerings | Create semester class sections with one teacher and room. | `COURSE_OFFERING` (FKs) |
| **FR-08** | Students | Track students with unique University Seat Numbers (USN). | `STUDENT.usn` (UNIQUE) |
| **FR-09** | Enrollment | Allow students to enroll in courses; stop duplicate enrollment. | `UNIQUE(student_id, offering_id)` |
| **FR-10** | Attendance | Mark daily attendance only for enrolled students. | `ATTENDANCE.enrollment_id` (FK) |
| **FR-11** | Assignments | Teachers post assignments with due dates and maximum marks. | `ASSIGNMENT.max_marks > 0` |
| **FR-12** | Submissions | Record student submissions with submission time and marks. | `SUBMISSION.marks` [0, max_marks] |

### 3.2 Main Business Rules
1. **One HOD per Department:** A department can have only one HOD at a time.
2. **One Program per Student:** A student is enrolled in exactly one degree program.
3. **No Duplicate Registration:** A student cannot register for the same course offering section twice.
4. **Attendance Needs Enrollment:** Attendance can only be recorded for students who are actively registered in that course section.
5. **Attendance Values:** Status can be `Present` or `Absent` (default is `'Present'`).
6. **Marks Limit:** A student's marks cannot be negative and cannot exceed `max_marks`.

---

## 4. ER Modeling & Conceptual Design

### 4.1 Entities in the System
UniTrack has **11 Strong Entities**:
`DEPARTMENT`, `PROGRAM`, `FACULTY`, `COURSE`, `CLASSROOM`, `STUDENT`, `COURSE_OFFERING`, `ENROLLMENT`, `ATTENDANCE`, `ASSIGNMENT`, `SUBMISSION`.

Every table in UniTrack has its own dedicated primary key. For example, `ATTENDANCE` has `attendance_id` as its primary key, making it a regular strong entity that references `ENROLLMENT` through the foreign key `enrollment_id`.

### 4.2 Entity Keys & Identification
In database modeling, an entity that has its own primary key is a strong entity. In UniTrack:
- **`ATTENDANCE` is a Strong Entity:** It has its own unique primary key (`attendance_id`).
- **Foreign Key Link:** It links to `ENROLLMENT` via `enrollment_id` (`NOT NULL`) to connect attendance sessions to the student's registration.
- **Session Attributes:** `class_date` records the lecture date, and `status` stores attendance (`Present`, `Absent`, etc.).

### 4.3 Relationship Summary

| Relationship | Entities Involved | Type | Meaning |
| :--- | :--- | :---: | :--- |
| **Offers** | `DEPARTMENT` -> `PROGRAM` | 1:M | A department offers one or more programs. |
| **Employs** | `DEPARTMENT` -> `FACULTY` | 1:M | A department employs faculty members. |
| **Owns** | `DEPARTMENT` -> `COURSE` | 1:M | A department owns courses in the catalog. |
| **Heads** | `FACULTY` -> `DEPARTMENT` | 1:1 | One faculty member heads a department as HOD. |
| **Admits** | `PROGRAM` -> `STUDENT` | 1:M | A program admits students. |
| **Schedules** | `COURSE` -> `COURSE_OFFERING` | 1:M | A course is scheduled across different semesters. |
| **Instructs** | `FACULTY` -> `COURSE_OFFERING` | 1:M | A faculty member teaches a course section. |
| **Hosts** | `CLASSROOM` -> `COURSE_OFFERING` | 1:M | A classroom hosts a course offering. |
| **Registers** | `STUDENT` -> `ENROLLMENT` | 1:M | A student registers for course offerings. |
| **Populates** | `COURSE_OFFERING` -> `ENROLLMENT` | 1:M | Course offerings have enrolled students. |
| **Records** | `ENROLLMENT` -> `ATTENDANCE` | 1:M | Enrolled students have session attendance. |
| **Issues** | `COURSE_OFFERING` -> `ASSIGNMENT` | 1:M | A course offering gives assignments. |
| **Evaluates** | `ASSIGNMENT` -> `SUBMISSION` | 1:M | An assignment receives student submissions. |
| **Submits** | `STUDENT` -> `SUBMISSION` | 1:M | A student submits completed coursework. |

### 4.4 Conceptual Peter Chen ER Diagram

<p align="center">
  <img src="../diagrams/ER_Diagram.png" alt="UniTrack Conceptual ER Diagram in Peter Chen Notation" width="100%"/>
</p>

*Figure 4.1: Final Conceptual ER Diagram in Peter Chen Notation (Authored by Melvin Jacob, AU25UG-034).*

```
+--------------------------------------------------------------------------------------------------+
|                                    UNITRACK ER DIAGRAM SUMMARY                                   |
|                                                                                                  |
|   [DEPARTMENT] <---(Offers)---> [PROGRAM] <---(Admits)---> [STUDENT]                             |
|        |                                                      |                                  |
|     (Heads) / (Employs)                                   (Registers)                            |
|        |                                                      |                                  |
|        v                                                      v                                  |
|    [FACULTY] <---(Instructs)----+                       [ENROLLMENT] <---(Records)---> [ATTENDANCE]
|                                 |                             ^                                  |
|                                 v                             |                                  |
|    [COURSE] <---(Schedules)---> [COURSE_OFFERING] <---(Populates)                                |
|                                 |          |                                                     |
|                               (Hosts)    (Issues)                                                |
|                                 |          |                                                     |
|                                 v          v                                                     |
|                            [CLASSROOM]  [ASSIGNMENT] <---(Evaluates)---> [SUBMISSION]            |
|                                                                                ^                 |
|                                                                                |                 |
|                                                                           (Submits)              |
|                                                                                |                 |
|                                                                            [STUDENT]             |
+--------------------------------------------------------------------------------------------------+
```

---

## 5. Relational Schema & Data Dictionary

### 5.1 Schema Notation
- `DEPARTMENT` (**department_id**, name, hod_faculty_id [FK])
- `PROGRAM` (**program_id**, name, duration_years, department_id [FK])
- `FACULTY` (**faculty_id**, name, designation, email, department_id [FK])
- `COURSE` (**course_id**, code, title, credits, department_id [FK])
- `CLASSROOM` (**classroom_id**, building, room_no, capacity)
- `STUDENT` (**student_id**, usn, name, admission_year, program_id [FK])
- `COURSE_OFFERING` (**offering_id**, course_id [FK], faculty_id [FK], classroom_id [FK], semester, year)
- `ENROLLMENT` (**enrollment_id**, student_id [FK], offering_id [FK], grade)
- `ATTENDANCE` (**attendance_id**, enrollment_id [FK], class_date, status)
- `ASSIGNMENT` (**assignment_id**, offering_id [FK], title, due_date, max_marks)
- `SUBMISSION` (**submission_id**, assignment_id [FK], student_id [FK], submitted_on, marks)

---

### 5.2 Data Dictionary (All 11 Tables)

#### 1. DEPARTMENT
| Column | Key | Type | Null? | Default | Description |
| :--- | :---: | :---: | :---: | :---: | :--- |
| `department_id` | **PK** | `INT` | No | None | Unique department ID |
| `name` | — | `VARCHAR(100)` | No | None | Department name (e.g. Computer Science) |
| `hod_faculty_id` | **FK** | `INT` | Yes | `NULL` | Faculty member who is HOD |

#### 2. PROGRAM
| Column | Key | Type | Null? | Default | Description |
| :--- | :---: | :---: | :---: | :---: | :--- |
| `program_id` | **PK** | `INT` | No | None | Unique program ID |
| `name` | — | `VARCHAR(100)` | No | None | Program title (e.g. B.Tech CS) |
| `duration_years` | — | `INT` | No | `4` | Course duration in years |
| `department_id` | **FK** | `INT` | No | None | Offering department ID |

#### 3. FACULTY
| Column | Key | Type | Null? | Default | Description |
| :--- | :---: | :---: | :---: | :---: | :--- |
| `faculty_id` | **PK** | `INT` | No | None | Unique faculty ID |
| `name` | — | `VARCHAR(100)` | No | None | Faculty full name |
| `designation` | — | `VARCHAR(100)` | Yes | `NULL` | Professor, Associate Professor, etc. |
| `email` | **UNIQUE** | `VARCHAR(150)` | Yes | `NULL` | Faculty official email address |
| `department_id` | **FK** | `INT` | No | None | Home department ID |

#### 4. COURSE
| Column | Key | Type | Null? | Default | Description |
| :--- | :---: | :---: | :---: | :---: | :--- |
| `course_id` | **PK** | `INT` | No | None | Unique course ID |
| `code` | **UNIQUE** | `VARCHAR(20)` | No | None | Course code (e.g. CS201) |
| `title` | — | `VARCHAR(150)` | No | None | Course title |
| `credits` | — | `INT` | No | `3` | Course credit value |
| `department_id` | **FK** | `INT` | No | None | Department offering this course |

#### 5. CLASSROOM
| Column | Key | Type | Null? | Default | Description |
| :--- | :---: | :---: | :---: | :---: | :--- |
| `classroom_id` | **PK** | `INT` | No | None | Unique room ID |
| `building` | — | `VARCHAR(100)` | No | None | Campus block name |
| `room_no` | — | `VARCHAR(20)` | No | None | Room number |
| `capacity` | — | `INT` | No | None | Maximum seating capacity |

#### 6. STUDENT
| Column | Key | Type | Null? | Default | Description |
| :--- | :---: | :---: | :---: | :---: | :--- |
| `student_id` | **PK** | `INT` | No | None | Unique student ID |
| `usn` | **UNIQUE** | `VARCHAR(30)` | No | None | University Seat Number |
| `name` | — | `VARCHAR(100)` | No | None | Student full name |
| `admission_year` | — | `INT` | No | None | Year of joining |
| `program_id` | **FK** | `INT` | No | None | Enrolled degree program ID |

#### 7. COURSE_OFFERING
| Column | Key | Type | Null? | Default | Description |
| :--- | :---: | :---: | :---: | :---: | :--- |
| `offering_id` | **PK** | `INT` | No | None | Unique offering ID |
| `course_id` | **FK** | `INT` | No | None | Subject from catalog |
| `faculty_id` | **FK** | `INT` | No | None | Assigned teacher |
| `classroom_id` | **FK** | `INT` | No | None | Assigned lecture hall |
| `semester` | — | `VARCHAR(20)` | No | None | Fall, Spring, or Summer |
| `year` | — | `INT` | No | None | Academic year |

#### 8. ENROLLMENT
| Column | Key | Type | Null? | Default | Description |
| :--- | :---: | :---: | :---: | :---: | :--- |
| `enrollment_id` | **PK** | `INT` | No | None | Unique enrollment ID |
| `student_id` | **FK** | `INT` | No | None | Enrolled student ID |
| `offering_id` | **FK** | `INT` | No | None | Course section ID |
| `grade` | — | `VARCHAR(20)` | Yes | `'In Progress'` | Final grade or status |

*Rule:* `UNIQUE (student_id, offering_id)` ensures a student cannot enroll twice in the same section.

#### 9. ATTENDANCE
| Column | Key | Type | Null? | Default | Description |
| :--- | :---: | :---: | :---: | :---: | :--- |
| `attendance_id` | **PK** | `INT` | No | None | Unique attendance ID |
| `enrollment_id` | **FK** | `INT` | No | None | Links to student's enrollment |
| `class_date` | — | `DATE` | No | None | Date of the lecture |
| `status` | — | `VARCHAR(20)` | No | `'Present'` | Present, Absent |

#### 10. ASSIGNMENT
| Column | Key | Type | Null? | Default | Description |
| :--- | :---: | :---: | :---: | :---: | :--- |
| `assignment_id` | **PK** | `INT` | No | None | Unique assignment ID |
| `offering_id` | **FK** | `INT` | No | None | Course section giving the work |
| `title` | — | `VARCHAR(150)` | No | None | Assignment title |
| `due_date` | — | `DATE` | No | None | Last date for submission |
| `max_marks` | — | `INT` | No | None | Maximum achievable marks |

#### 11. SUBMISSION
| Column | Key | Type | Null? | Default | Description |
| :--- | :---: | :---: | :---: | :---: | :--- |
| `submission_id` | **PK** | `INT` | No | None | Unique submission ID |
| `assignment_id` | **FK** | `INT` | No | None | Assignment being submitted |
| `student_id` | **FK** | `INT` | No | None | Submitting student ID |
| `submitted_on` | — | `DATETIME` | Yes | `CURRENT_TIMESTAMP` | Date and time submitted |
| `marks` | — | `DECIMAL(5,2)` | Yes | `NULL` | Marks given by teacher |

---

## 6. Key Design Decisions

1. **Department and Faculty Circular Reference:**  
   A department needs an HOD (from `FACULTY`), and a faculty member belongs to a `DEPARTMENT`.  
   *Solution:* We create `DEPARTMENT` first with `hod_faculty_id` set to `NULL`, create `FACULTY`, and then link the HOD using `ALTER TABLE`. If an HOD leaves, `ON DELETE SET NULL` keeps the department safe while marking HOD as empty.
2. **Separating Course Catalog from Offerings:**  
   The basic syllabus (`COURSE`: code, title, credits) stays the same for years. The actual class (`COURSE_OFFERING`: teacher, room, term, year) changes every semester. Keeping them separate avoids repeating course titles again and again.
3. **Linking Attendance to Enrollment:**  
   Attendance points to `ENROLLMENT` rather than student and course separately. This physically prevents attendance from being entered for a student who is not registered.

---

## 7. Database Normalization (1NF, 2NF, 3NF)

Normalization is the process of organizing tables to stop duplicate data and avoid errors when inserting, updating, or deleting. UniTrack is fully in **Third Normal Form (3NF)**.

### 1. First Normal Form (1NF)
- **Rule:** Every column must hold a single (atomic) value. No lists or comma-separated items.
- **In UniTrack:** All columns store single values. For example, attendance dates are not stored as a list inside a student's row; each date has its own row in `ATTENDANCE`.

### 2. Second Normal Form (2NF)
- **Rule:** The table must be in 1NF, and every non-key column must depend on the whole primary key (no partial dependencies).
- **In UniTrack:**
  - 10 tables have single-column primary keys (like `student_id`, `course_id`), so partial dependency is impossible.
  - In `ENROLLMENT`, the natural key is `(student_id, offering_id)`. The column `grade` depends on **both** the student and the offering together (a student gets a grade for a specific course offering).

### 3. Third Normal Form (3NF)
- **Rule:** The table must be in 2NF, and no non-key column should depend on another non-key column (no transitive dependencies like A -> B -> C).
- **In UniTrack:**
  - In `STUDENT`, we only store `program_id`. Program duration and department are kept in `PROGRAM`, avoiding transitive links (Student -> Program -> Department).
  - In `COURSE_OFFERING`, we only store `course_id`. Course title and credits are kept in `COURSE`, avoiding transitive links (Offering -> Course -> Credits).
  - All 11 tables satisfy 3NF with zero data anomalies.

---

## 8. Database Implementation & Data Summary

### 8.1 Setup Details
- **RDBMS:** MySQL 8.0+
- **Engine:** InnoDB (Supports ACID transactions and Foreign Keys)
- **Data Insertion Order:** Tables were filled in parent-to-child order so foreign key references never fail.

### 8.2 Total Data in Database

| Table Name | Row Count | Purpose & Notes |
| :--- | :---: | :--- |
| `DEPARTMENT` | **5** | CS, EE, ME, CE, BA departments (all have active HODs). |
| `PROGRAM` | **8** | B.Tech, M.Tech, MBA, Ph.D programs. |
| `FACULTY` | **20** | Professors, Associate Professors, Assistant Professors. |
| `COURSE` | **25** | Core engineering and management subjects. |
| `CLASSROOM` | **10** | Lecture halls across campus blocks. |
| `STUDENT` | **100** | USNs `UT22001` to `UT25100` (Batches 2022 to 2025). |
| `COURSE_OFFERING` | **30** | 10 classes per semester (Fall 2024, Spring 2025, Fall 2025). |
| `ENROLLMENT` | **250** | 8 to 10 students registered per class. |
| `ATTENDANCE` | **2,500** | 10 attendance sessions per enrolled student (2,205 Present [88.2%], 295 Absent [11.8%]). |
| `ASSIGNMENT` | **50** | ~2 assignments per course offering section. |
| `SUBMISSION` | **418** | Assignment submissions with marks [0 to max_marks]; exactly 12 deliberate unsubmitted assignments for audit. |
| **TOTAL** | **3,416 Rows** | **11 Normalized Relations; 100% of constraints and relationships verified.** |

---

## 9. SQL Queries & Results (Q1–Q10)

This section shows the **10 analytical queries (Q1 to Q10)** developed by **Padmaraju Poojitha (`AU25UG-043`)**, along with their SQL code, output tables, and screenshots.

---

### Q1: Students with the Highest Course Load
- **Question:** Which students are enrolled in the most courses?
- **Why it matters:** Helps advisors find students carrying heavy workloads who might need help.

```sql
SELECT s.student_id, s.usn, s.name, COUNT(*) AS course_count
FROM STUDENT s
JOIN ENROLLMENT e ON s.student_id = e.student_id
GROUP BY s.student_id, s.usn, s.name
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM ENROLLMENT
    GROUP BY student_id
)
ORDER BY course_count DESC;
```

#### Output:
| student_id | usn | name | course_count |
| :---: | :---: | :--- | :---: |
| 13 | `UT22013` | Saanvi Singh | 4 |
| 15 | `UT24015` | Tanvi Mishra | 4 |
| 16 | `UT25016` | Varun Reddy | 4 |
| 17 | `UT22017` | Vivek Rao | 4 |

![Q1 Query Execution Screenshot](../queries/screenshots/q1_output.png)

- **Finding:** Exactly 4 students (`Saanvi Singh`, `Tanvi Mishra`, `Varun Reddy`, `Vivek Rao`) share the maximum course load with 4 courses each. All other students take 2 or 3 courses.

---

### Q2: Courses with the Highest Total Enrollment
- **Question:** Which courses have the highest number of students enrolled across all semesters?
- **Why it matters:** Shows popular courses so the college can arrange more sections and teachers.

```sql
SELECT c.course_id, c.code, c.title, COUNT(*) AS enrollment_count
FROM COURSE c
JOIN COURSE_OFFERING co ON c.course_id = co.course_id
JOIN ENROLLMENT e ON co.offering_id = e.offering_id
GROUP BY c.course_id, c.code, c.title
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM COURSE_OFFERING co2
    JOIN ENROLLMENT e2 ON co2.offering_id = e2.offering_id
    GROUP BY co2.course_id
)
ORDER BY enrollment_count DESC;
```

#### Output:
| course_id | code | title | enrollment_count |
| :---: | :---: | :--- | :---: |
| 1 | `CS101` | Python Programming | 17 |
| 3 | `CS201` | Database Management Systems | 17 |
| 7 | `CS301` | Algorithms | 17 |
| 10 | `CS402` | Machine Learning | 17 |

![Q2 Query Execution Screenshot](../queries/screenshots/q2_output.png)

- **Finding:** Core Computer Science subjects (`CS101`, `CS201`, `CS301`, `CS402`) have the highest demand, each with 17 student enrollments.

---

### Q3: Faculty Teaching the Most Courses
- **Question:** Which teacher handles the maximum number of course offerings?
- **Why it matters:** Ensures teaching work is balanced fairly among faculty members.

```sql
SELECT f.faculty_id, f.name, COUNT(*) AS courses_taught
FROM FACULTY f
JOIN COURSE_OFFERING co ON f.faculty_id = co.faculty_id
GROUP BY f.faculty_id, f.name
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM COURSE_OFFERING
    GROUP BY faculty_id
)
ORDER BY courses_taught DESC;
```

#### Output:
| faculty_id | name | courses_taught |
| :---: | :--- | :---: |
| 1 | Amelia Patel | 14 |

![Q3 Query Execution Screenshot](../queries/screenshots/q3_output.png)

- **Finding:** Faculty member **Amelia Patel** taught 14 course sections across the three semesters.

---

### Q4: Average Grade for Each Course
- **Question:** What is the average grade (GPA on 4.0 scale) for each completed course?
- **Why it matters:** Checks whether grading is fair across different subjects.

```sql
SELECT c.code, c.title,
ROUND(AVG(CASE e.grade
    WHEN 'A' THEN 4
    WHEN 'A-' THEN 3.7
    WHEN 'B+' THEN 3.3
    WHEN 'B' THEN 3
    WHEN 'B-' THEN 2.7
    WHEN 'C+' THEN 2.3
    WHEN 'C' THEN 2
    WHEN 'D' THEN 1
    WHEN 'F' THEN 0
END), 2) AS average_grade
FROM COURSE c
JOIN COURSE_OFFERING co ON c.course_id = co.course_id
JOIN ENROLLMENT e ON co.offering_id = e.offering_id
WHERE e.grade <> 'In Progress'
GROUP BY c.course_id, c.code, c.title
ORDER BY average_grade DESC;
```

#### Output (Sample of Top & Bottom):
| code | title | average_grade (4.0 Scale) |
| :---: | :--- | :---: |
| `EE201` | Electrical Machines | 3.13 |
| `EE401` | Power Electronics | 3.13 |
| `ME301` | Fluid Mechanics | 3.13 |
| `CE201` | Structural Engineering | 3.10 |
| `CS301` | Algorithms | 3.05 |
| `CS402` | Machine Learning | 3.01 |
| ... | *(20 Completed Courses in Fall 2024 & Spring 2025)* | ... |
| `CS204` | Software Engineering | 2.74 |

![Q4 Query Execution Screenshot](../queries/screenshots/q4_output.png)

- **Finding:** Course GPAs range naturally between 2.74 (`CS204`) and 3.13 (`EE201`, `EE401`, `ME301`). Active classes with `'In Progress'` grades are filtered out.

---

### Q5: Students with Low Attendance (< 75%)
- **Question:** Which students have attendance below the mandatory 75% cutoff?
- **Why it matters:** Identifies students who are at risk of being barred from semester exams.

```sql
SELECT s.student_id, s.usn, s.name,
ROUND(100 * SUM(a.status = 'Present') / COUNT(*), 2) AS attendance
FROM STUDENT s
JOIN ENROLLMENT e ON s.student_id = e.student_id
JOIN ATTENDANCE a ON e.enrollment_id = a.enrollment_id
GROUP BY s.student_id, s.usn, s.name
HAVING attendance < 75
ORDER BY attendance;
```

#### Output (Production Dataset: Students with Attendance < 75%):
| student_id | usn | name | attendance (%) | Sessions Present | Status |
| :---: | :---: | :--- | :---: | :---: | :---: |
| 7 | `UT24007` | Isha Gupta | 50.00 | 15 / 30 | Critical (< 75%) |
| 15 | `UT24015` | Tanvi Agarwal | 60.00 | 18 / 30 | At-Risk (< 75%) |
| 23 | `UT24023` | Alok Banerjee | 60.00 | 18 / 30 | At-Risk (< 75%) |
| 31 | `UT24031` | Gaurav Sen | 70.00 | 21 / 30 | At-Risk (< 75%) |
| 39 | `UT24039` | Kunal Oberoi | 70.00 | 21 / 30 | At-Risk (< 75%) |

![Q5 Query Execution Screenshot](../queries/screenshots/q5_output.png)
*(Figure 9.5: Live MySQL Workbench execution proof captured during development milestone testing)*

- **Finding:** Enforces statutory university policy requiring $\ge 75\%$ class attendance for semester examination eligibility. In the consolidated production database (`data/insert_data.sql`), exactly 5 students fall below the cutoff, ranging from **50.00%** (Isha Gupta, 15/30 sessions) to **70.00%** (Gaurav Sen and Kunal Oberoi, 21/30 sessions), enabling timely academic counseling. *(Note: The screenshot above reflects the milestone Workbench execution proof captured during earlier testing).*

---

### Q6: Students Who Have Not Submitted Assignments
- **Question:** Which students have missed submitting an assignment?
- **Why it matters:** Allows teachers to remind students before final deadline locks.

```sql
SELECT s.student_id, s.usn, s.name,
       a.assignment_id, a.title
FROM STUDENT s
JOIN ENROLLMENT e ON s.student_id = e.student_id
JOIN ASSIGNMENT a ON e.offering_id = a.offering_id
LEFT JOIN SUBMISSION sub
ON sub.student_id = s.student_id
AND sub.assignment_id = a.assignment_id
WHERE sub.submission_id IS NULL
ORDER BY s.student_id, a.assignment_id;
```

#### Output (Unsubmitted Assignments Sample):
| student_id | usn | name | assignment_id | title |
| :---: | :---: | :--- | :---: | :--- |
| 91 | `UT24091` | Rahul Reddy | 42 | Assignment 2 |
| 92 | `UT25092` | Riya Rao | 12 | Assignment 4 |
| 92 | `UT25092` | Riya Rao | 13 | Assignment 1 |
| 92 | `UT25092` | Riya Rao | 27 | Assignment 3 |
| 92 | `UT25092` | Riya Rao | 42 | Assignment 2 |
| 92 | `UT25092` | Riya Rao | 43 | Assignment 3 |
| 93 | `UT22093` | Saanvi Singh | 13 | Assignment 1 |
| 93 | `UT22093` | Saanvi Singh | 27 | Assignment 3 |
| 93 | `UT22093` | Saanvi Singh | 43 | Assignment 3 |
| 94 | `UT23094` | Siddharth Joshi | 13 | Assignment 1 |
| ... | ... | *(Students 95 to 100)* | ... | ... |

![Q6 Query Execution Screenshot](../queries/screenshots/q6_output.png)

- **Finding:** An anti-join (`LEFT JOIN ... WHERE sub.submission_id IS NULL`) accurately lists all overdue coursework items across students (such as `Rahul Reddy`, `Riya Rao`, `Saanvi Singh`, `Siddharth Joshi`, `Tanvi Mishra`, `Vivek Rao`, `Zoya Singh`, `Neha Joshi`, and `Karan Mishra`).

---

### Q7: Courses with Zero Enrollment
- **Question:** Are there any catalog courses that have never had a single student enroll?
- **Why it matters:** Audits whether any course in the university syllabus is sitting unused.

```sql
SELECT c.course_id, c.code, c.title
FROM COURSE c
LEFT JOIN COURSE_OFFERING co ON c.course_id = co.course_id
LEFT JOIN ENROLLMENT e ON co.offering_id = e.offering_id
GROUP BY c.course_id, c.code, c.title
HAVING COUNT(e.enrollment_id) = 0;
```

#### Output:
```
Empty set (0.00 sec)
```

![Q7 Query Execution Screenshot](../queries/screenshots/q7_output.png)

- **Finding:** The query returns an empty set. This confirms that all 25 courses in the university catalog are actively offered and used.

---

### Q8: Courses with the Highest Average Assignment Marks
- **Question:** Which course has the highest average marks on assignments?
- **Why it matters:** Helps compare student performance across different courses.

```sql
SELECT c.code, c.title, ROUND(AVG(s.marks), 2) AS average_marks
FROM COURSE c
JOIN COURSE_OFFERING co ON c.course_id = co.course_id
JOIN ASSIGNMENT a ON co.offering_id = a.offering_id
JOIN SUBMISSION s ON a.assignment_id = s.assignment_id
GROUP BY c.course_id, c.code, c.title
HAVING AVG(s.marks) >= ALL (
    SELECT AVG(s2.marks)
    FROM COURSE_OFFERING co2
    JOIN ASSIGNMENT a2 ON co2.offering_id = a2.offering_id
    JOIN SUBMISSION s2 ON a2.assignment_id = s2.assignment_id
    GROUP BY co2.course_id
)
ORDER BY average_marks DESC;
```

#### Output:
| code | title | average_marks |
| :---: | :--- | :---: |
| `BA201` | Financial Management | 24.90 |

![Q8 Query Execution Screenshot](../queries/screenshots/q8_output.png)

- **Finding:** `BA201` (Financial Management) achieved the highest average assignment score across all offerings at **24.90 marks**.

---

### Q9: Semester with the Highest Student Enrollments
- **Question:** Which semester and year had the maximum student registrations?
- **Why it matters:** Helps administrators plan classroom space and teacher hiring for upcoming terms.

```sql
SELECT co.year, co.semester, COUNT(*) AS enrollment_count
FROM COURSE_OFFERING co
JOIN ENROLLMENT e ON co.offering_id = e.offering_id
GROUP BY co.year, co.semester
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM COURSE_OFFERING co2
    JOIN ENROLLMENT e2 ON co2.offering_id = e2.offering_id
    GROUP BY co2.year, co2.semester
)
ORDER BY enrollment_count DESC;
```

#### Output:
| year | semester | enrollment_count |
| :---: | :---: | :---: |
| 2024 | Fall | 100 |

![Q9 Query Execution Screenshot](../queries/screenshots/q9_output.png)

- **Finding:** **Fall 2024** had the highest student intake with 100 course enrollments (Spring 2025 had 80, Fall 2025 had 70).

---

### Q10: Course with the Most Recorded Absences
- **Question:** Which course had the highest number of student absences?
- **Why it matters:** Highlights difficult or early-morning subjects where attendance issues are common.

```sql
SELECT c.code, c.title, COUNT(*) AS absent_count
FROM COURSE c
JOIN COURSE_OFFERING co ON c.course_id = co.course_id
JOIN ENROLLMENT e ON co.offering_id = e.offering_id
JOIN ATTENDANCE a ON e.enrollment_id = a.enrollment_id
WHERE a.status = 'Absent'
GROUP BY c.course_id, c.code, c.title
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM COURSE_OFFERING co2
    JOIN ENROLLMENT e2 ON co2.offering_id = e2.offering_id
    JOIN ATTENDANCE a2 ON e2.enrollment_id = a2.enrollment_id
    WHERE a2.status = 'Absent'
    GROUP BY co2.course_id
)
ORDER BY absent_count DESC;
```

#### Output (Courses with Highest Absences):
| code | title | absent_count |
| :---: | :--- | :---: |
| `CS201` | Database Management Systems | 6 |
| `CS402` | Machine Learning | 6 |

![Q10 Query Execution Screenshot](../queries/screenshots/q10_output.png)
*(Figure 9.10: Live MySQL Workbench execution proof captured during testing)*

- **Finding:** `CS201` (Database Management Systems) and `CS402` (Machine Learning) tied for the highest absence count with **6 recorded absences** each.

---

## 10. Testing & Integrity Checks

All tables and constraints were tested directly in MySQL:
1. **Primary & Unique Key Check:** No duplicate student USNs, course codes, or emails exist.
2. **Duplicate Enrollment Check:** Verified that no student can be registered twice in the same section.
3. **Foreign Key Cascade Test:** Deleting a test enrollment automatically deleted its attendance rows (`ON DELETE CASCADE`).
4. **Foreign Key Restrict Test:** Deleting a student who has enrollments was stopped with a foreign key error (`ON DELETE RESTRICT`).
5. **CHECK Constraints:** Values like negative credits, 0-year programs, and negative assignment marks are blocked by MySQL.

---

## 11. Conclusion & Future Work

### 11.1 Summary
The **UniTrack** database system provides a complete, working solution for university academic management. By organizing data into 11 tables normalized to 3NF, the system prevents duplicate data and ensures all records stay connected and consistent. The 10 analytical SQL queries provide quick, clear answers for university decision-making.

### 11.2 Future Enhancements
1. **User Logins & Roles:** Add separate login accounts for Students, Teachers, and HODs with appropriate permissions.
2. **Prerequisites Table:** Add a table to automatically check if a student passed prerequisite courses before enrolling in advanced subjects.
3. **Web Dashboard:** Build a simple web frontend so students can view their attendance and grades directly from their phone or browser.

---

## 12. Team Contributions

| Team Member & USN | Assigned Role | Main Responsibilities & Deliverables |
| :--- | :--- | :--- |
| **Konduru Nanda Kishore Raju**<br/>`AU25UG-028` | **Team Lead & Report Author** | Authored the comprehensive final project report, system requirements, business rules, and conducted final project audits. |
| **Melvin Jacob**<br/>`AU25UG-034` | **ER Modeler** | Conceptual ER design, Chen notation diagram, and entity classification. |
| **K. Jyoshna**<br/>`AU25UG-026` | **Schema Designer** | Relational schema, DDL scripts, circular dependency resolution, and data dictionary. |
| **Monica Irala**<br/>`AU25UG-037` | **Normalization Lead** | Functional dependencies, 1NF/2NF/3NF proofs, and normalization verification. |
| **Naidile D**<br/>`AU25UG-038` | **Data Engineer** | Test data creation, insertion order sequencing, and database population. |
| **Padmaraju Poojitha**<br/>`AU25UG-043` | **SQL Analyst** | Analytical queries Q1–Q10, query optimization, and Workbench execution proofs. |

---

<div align="center">

**UniTrack: University Academic Tracking System — Team 4**  
*Department of Computer Science & Engineering • DBMS Final Project*

</div>
