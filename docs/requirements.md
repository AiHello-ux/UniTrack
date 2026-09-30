# UniTrack — System Requirements Analysis & Specifications

> **Author:** Konduru Nanda Kishore Raju (Nandu) — `AU25UG-028`  
> **Role:** Team Lead (Requirement Analysis + Final Review)  
> **Course:** Database Management Systems (DBMS)  
> **Deliverable:** Stage 1 — System Specification & Requirement Analysis Report  
> **Target System:** UniTrack (University Course, Student & Academic Management System)

---

## 1. System Vision & Problem Statement

Higher education institutions face significant administrative complexity across departments, degree programs, faculty allocations, course schedules, student enrollments, session attendance, and continuous assessment. Traditional decentralized or spreadsheet-based records suffer from:
- **Redundancy and Desynchronization:** Duplicate student and faculty records leading to conflicting contact or enrollment information.
- **Referential Inconsistency:** Attendance logs or assignment submissions recorded for courses in which students were never officially registered.
- **Administrative Friction:** Inability for academic deans and heads of departments (HODs) to quickly compute semester GPAs, track faculty teaching loads, or identify students at risk due to poor attendance.

**UniTrack** provides a centralized, relational database management system (RDBMS) architecture engineered to enforce strict data integrity, eliminate update/deletion anomalies, and provide high-performance query analytics for academic administration.

---

## 2. Operational Domain Modules

The system is decomposed into five core functional modules:

```
┌────────────────────────────────────────────────────────────────────────┐
│                   UNITRACK OPERATIONAL SUBSYSTEMS                      │
├────────────────────────────────────────────────────────────────────────┤
│ 1. Administrative & Academic Structure  │ DEPARTMENT, PROGRAM          │
│ 2. Faculty & Instructional Resource     │ FACULTY, CLASSROOM           │
│ 3. Curriculum & Course Scheduling       │ COURSE, COURSE_OFFERING      │
│ 4. Student Lifecycle & Registration     │ STUDENT, ENROLLMENT          │
│ 5. Assessment, Attendance & Grading     │ ATTENDANCE, ASSIGNMENT, SUB. │
└────────────────────────────────────────────────────────────────────────┘
```

1. **Administrative & Program Hierarchy:** Maintains academic departments and degree programs (e.g., B.Tech, M.Tech, MBA), tracking their durations and departmental ownership.
2. **Faculty & Physical Venue Management:** Tracks instructional personnel, academic designations, institutional communications, and physical classroom facilities with seating capacities.
3. **Course Catalog & Semester Offerings:** Maintains permanent catalog course definitions and instantiates specific semester offerings paired with instructors and classrooms.
4. **Student Master & Course Registration:** Manages student admissions under academic programs and registers students into semester course offerings while enforcing unique registration rules.
5. **Continuous Assessment & Attendance Logging:** Records daily lecture-by-lecture attendance status and tracks assignment releases, due dates, student submissions, and evaluated marks.

---

## 3. Functional Requirements (FR)

| Requirement ID | Module | Functional Description | System Enforcement |
|:---:|:---|:---|:---|
| **FR-01** | Department | System shall record academic departments with unique identifiers and names. | `DEPARTMENT.department_id` (PK), `name` NOT NULL. |
| **FR-02** | Department HOD | Each department shall be headed by at most one faculty member. | `hod_faculty_id` (FK referencing `FACULTY.faculty_id`). |
| **FR-03** | Program | Department shall offer one or more degree programs with defined duration in years. | `PROGRAM.program_id` (PK), `department_id` (FK), `CHECK (duration_years > 0)`. |
| **FR-04** | Faculty | System shall record faculty members with institutional email and department affiliation. | `FACULTY.faculty_id` (PK), `email` UNIQUE, `department_id` (FK). |
| **FR-05** | Course Catalog | Master course catalog shall define course code, title, credit weight, and owning department. | `COURSE.course_id` (PK), `code` UNIQUE, `CHECK (credits > 0)`. |
| **FR-06** | Classroom | Classrooms shall specify building, room number, and seating capacity. | `CLASSROOM.classroom_id` (PK), `CHECK (capacity > 0)`. |
| **FR-07** | Course Scheduling | System shall schedule course offerings for a specific semester and year, assigning one instructor and one classroom. | `COURSE_OFFERING.offering_id` (PK), `course_id` (FK), `faculty_id` (FK), `classroom_id` (FK). |
| **FR-08** | Student Admission | System shall record admitted students with university serial numbers (USN) and degree programs. | `STUDENT.student_id` (PK), `usn` UNIQUE, `program_id` (FK). |
| **FR-09** | Course Enrollment | Students shall register for course offerings; duplicate enrollment in the same offering is strictly prohibited. | `ENROLLMENT.enrollment_id` (PK), `UNIQUE (student_id, offering_id)`. |
| **FR-10** | Attendance Tracking | System shall record daily attendance per enrolled student with valid status flags. | `ATTENDANCE.attendance_id` (PK), `enrollment_id` (FK), `DEFAULT 'Present'`. |
| **FR-11** | Coursework Evaluation | Instructors shall create assignments for course offerings with deadlines and positive maximum marks. | `ASSIGNMENT.assignment_id` (PK), `offering_id` (FK), `CHECK (max_marks > 0)`. |
| **FR-12** | Submission Logging | Enrolled students shall submit work against assignments; system captures submission timestamp and marks awarded. | `SUBMISSION.submission_id` (PK), `assignment_id` (FK), `student_id` (FK), `DEFAULT CURRENT_TIMESTAMP`. |

---

## 4. Operational Assumptions & Business Rules

1. **Academic Program Ownership:** Every degree program belongs to exactly one department. Interdisciplinary programs are administratively hosted under a primary governing department.
2. **Catalog vs. Offering Distinction:** A course (e.g., *Database Systems*) exists permanently in the catalog, but cannot enroll students directly. Students only enroll in specific semester instantiations (`COURSE_OFFERING`).
3. **Circular Dependency Handling:** A department must have an HOD (who is a faculty member), and a faculty member must belong to a department. To avoid chicken-and-egg insertion errors, `DEPARTMENT.hod_faculty_id` is created as nullable and populated after faculty records exist.
4. **Attendance Linkage Rule:** Attendance is linked directly to `ENROLLMENT` rather than `(student_id, offering_id)`. This structurally guarantees that attendance cannot be marked for a student unless they are officially registered.
5. **Grading Lifecycle:** When a semester is active, enrolled student grades remain `'In Progress'`. Final letter grades (`A`, `B+`, `B`, `C+`, `C`, `F`) are awarded only upon semester completion.
6. **Non-Zero Constraints:** Physical capacities, program durations, course credits, and assignment maximum marks must be strictly greater than zero.

---

## 5. Entities, Cardinality & Participation Matrix

| Parent Entity | Relationship | Child Entity | Cardinality | Parent Participation | Child Participation | Foreign Key in Child |
|:---|:---:|:---|:---:|:---:|:---:|:---|
| `DEPARTMENT` | Offers | `PROGRAM` | 1 : M | Partial | **Total** | `PROGRAM.department_id` |
| `DEPARTMENT` | Employs | `FACULTY` | 1 : M | Partial | **Total** | `FACULTY.department_id` |
| `DEPARTMENT` | Owns | `COURSE` | 1 : M | Partial | **Total** | `COURSE.department_id` |
| `FACULTY` | Heads | `DEPARTMENT` | 1 : 1 | Partial | Partial | `DEPARTMENT.hod_faculty_id` |
| `PROGRAM` | Admits | `STUDENT` | 1 : M | Partial | **Total** | `STUDENT.program_id` |
| `COURSE` | Scheduled In | `COURSE_OFFERING` | 1 : M | Partial | **Total** | `COURSE_OFFERING.course_id` |
| `FACULTY` | Instructs | `COURSE_OFFERING` | 1 : M | Partial | **Total** | `COURSE_OFFERING.faculty_id` |
| `CLASSROOM` | Accommodates | `COURSE_OFFERING` | 1 : M | Partial | **Total** | `COURSE_OFFERING.classroom_id` |
| `STUDENT` | Registers | `ENROLLMENT` | 1 : M | Partial | **Total** | `ENROLLMENT.student_id` |
| `COURSE_OFFERING` | Enrolls | `ENROLLMENT` | 1 : M | Partial | **Total** | `ENROLLMENT.offering_id` |
| `COURSE_OFFERING` | Sets | `ASSIGNMENT` | 1 : M | Partial | **Total** | `ASSIGNMENT.offering_id` |
| `ENROLLMENT` | Logs | `ATTENDANCE` | 1 : M | Partial | **Total** | `ATTENDANCE.enrollment_id` |
| `ASSIGNMENT` | Receives | `SUBMISSION` | 1 : M | Partial | **Total** | `SUBMISSION.assignment_id` |
| `STUDENT` | Submits | `SUBMISSION` | 1 : M | Partial | **Total** | `SUBMISSION.student_id` |

---

## 6. Final Review & Peer Audit Sign-Off

As Team Lead, I have conducted a comprehensive audit across all project modules before final submission:
- [x] **Conceptual Model Check (Melvin Jacob):** Verified 11 entities, relationships, cardinalities, and participation double lines against requirements.
- [x] **Relational Schema & DDL Check (K. Jyoshna):** Confirmed all 11 tables, PKs, 14 FKs, CHECK constraints, and DEFAULT rules compile error-free in MySQL 8.0+.
- [x] **Normalisation Proofs (Monica Irala):** Validated functional dependencies and verified that no transitive or partial dependencies exist (full 3NF compliance).
- [x] **Data Integrity Verification (Naidile D):** Verified topological insertion order of ~1,000 records without disabling foreign key checks.
- [x] **Query Analytics Verification (Padmaraju Poojitha):** Verified queries Q1–Q10 covering GROUP BY, HAVING, multi-table JOINs, nested subqueries, and set operations.
- [x] **Repository Packaging:** Ensured clean folder hierarchy (`schema/`, `data/`, `queries/`, `diagrams/`, `docs/`) with descriptive Markdown documentation.
