# UniTrack — Conceptual ER & Relational Schema Modeling

> **Author:** Melvin Jacob (`AU25UG-034`)  
> **Role:** Conceptual Modeler (ER Design) & Relational Schema Engineer  
> **Project:** UniTrack — Student, Course and Academic Management Database  
> **Course:** Database Management Systems (DBMS)  
> **Evaluated Deliverables:** Stage 3 (Conceptual ER Model) & Stage 4 (Relational Schema Mapping)

---

## 1. Conceptual Design & ER Diagram (Chen Notation)

The Entity-Relationship (ER) diagram represents the conceptual blueprint of the UniTrack database. It models all enterprise academic operations—spanning departments, academic programs, faculty allocations, student admissions, course scheduling, enrollments, session attendance, and continuous coursework evaluation.

![UniTrack ER diagram in Chen notation](ER_Diagram.png)

*Editable Draw.io source vector:* [`UniTrack - ER Diagram.drawio`](UniTrack%20-%20ER%20Diagram.drawio)

**Reading the diagram (legend):** rectangles are entities (all 11 are strong), diamonds are relationships, and ellipses are attributes — an underlined name is a primary key, `(FK)` marks a foreign-key attribute, and a dotted underline marks a partial key. The `1` / `M` labels beside each entity give the cardinality of that relationship.

---

## 2. Entities and Attribute Classification

The conceptual design identifies **11 strong entities** with distinct single-attribute primary keys:

### 1. DEPARTMENT
*Governing academic and administrative unit.*
| Attribute | Key Type | Domain / Data Type | Constraint | Description |
|:---|:---:|:---:|:---:|:---|
| `department_id` | **PK** | INT | PRIMARY KEY | Unique department identifier |
| `name` | - | VARCHAR(100) | NOT NULL | Official department title |
| `hod_faculty_id` | **FK** | INT | NULLABLE | References `FACULTY(faculty_id)` (Department Head) |

### 2. PROGRAM
*Degree offerings administered under a department.*
| Attribute | Key Type | Domain / Data Type | Constraint | Description |
|:---|:---:|:---:|:---:|:---|
| `program_id` | **PK** | INT | PRIMARY KEY | Unique degree program identifier |
| `name` | - | VARCHAR(100) | NOT NULL | Degree title (e.g., B.Tech Computer Science) |
| `duration_years` | - | INT | DEFAULT 4, CHECK (>0) | Standard duration in years |
| `department_id` | **FK** | INT | NOT NULL | References `DEPARTMENT(department_id)` |

### 3. STUDENT
*Enrolled student demographic master.*
| Attribute | Key Type | Domain / Data Type | Constraint | Description |
|:---|:---:|:---:|:---:|:---|
| `student_id` | **PK** | INT | PRIMARY KEY | Internal system student surrogate key |
| `usn` | - | VARCHAR(30) | NOT NULL, UNIQUE | University serial number / roll number |
| `name` | - | VARCHAR(100) | NOT NULL | Student's full legal name |
| `admission_year` | - | INT | NOT NULL | Year of university admission |
| `program_id` | **FK** | INT | NOT NULL | References `PROGRAM(program_id)` |

### 4. FACULTY
*Academic and instructional teaching staff.*
| Attribute | Key Type | Domain / Data Type | Constraint | Description |
|:---|:---:|:---:|:---:|:---|
| `faculty_id` | **PK** | INT | PRIMARY KEY | Unique faculty member identifier |
| `name` | - | VARCHAR(100) | NOT NULL | Full name of faculty member |
| `designation` | - | VARCHAR(100) | - | Academic title (Professor, Assistant Professor) |
| `email` | - | VARCHAR(150) | UNIQUE | Official institutional email address |
| `department_id` | **FK** | INT | NOT NULL | References `DEPARTMENT(department_id)` |

### 5. COURSE
*Master course catalog definitions.*
| Attribute | Key Type | Domain / Data Type | Constraint | Description |
|:---|:---:|:---:|:---:|:---|
| `course_id` | **PK** | INT | PRIMARY KEY | Unique course catalog identifier |
| `code` | - | VARCHAR(20) | NOT NULL, UNIQUE | Alphanumeric course code (e.g., CS201) |
| `title` | - | VARCHAR(150) | NOT NULL | Course descriptive title |
| `credits` | - | INT | DEFAULT 3, CHECK (>0) | Course credit weight |
| `department_id` | **FK** | INT | NOT NULL | References `DEPARTMENT(department_id)` |

### 6. CLASSROOM
*Physical lecture halls, computer labs, and instructional venues.*
| Attribute | Key Type | Domain / Data Type | Constraint | Description |
|:---|:---:|:---:|:---:|:---|
| `classroom_id` | **PK** | INT | PRIMARY KEY | Unique physical venue identifier |
| `building` | - | VARCHAR(100) | NOT NULL | Campus building / facility name |
| `room_no` | - | VARCHAR(20) | NOT NULL | Room identifier within building |
| `capacity` | - | INT | NOT NULL, CHECK (>0) | Maximum student seating capacity |

### 7. COURSE_OFFERING
*Specific semester instantiation of a catalog course.*
| Attribute | Key Type | Domain / Data Type | Constraint | Description |
|:---|:---:|:---:|:---:|:---|
| `offering_id` | **PK** | INT | PRIMARY KEY | Unique course offering identifier |
| `semester` | - | VARCHAR(20) | NOT NULL | Academic semester (Fall, Spring, Summer) |
| `year` | - | INT | NOT NULL | Academic calendar year |
| `course_id` | **FK** | INT | NOT NULL | References `COURSE(course_id)` |
| `faculty_id` | **FK** | INT | NOT NULL | References `FACULTY(faculty_id)` (Assigned Instructor) |
| `classroom_id` | **FK** | INT | NOT NULL | References `CLASSROOM(classroom_id)` (Allocated Venue) |

### 8. ENROLLMENT
*Student course registration and grading tracking.*
| Attribute | Key Type | Domain / Data Type | Constraint | Description |
|:---|:---:|:---:|:---:|:---|
| `enrollment_id` | **PK** | INT | PRIMARY KEY | Unique registration identifier |
| `student_id` | **FK** | INT | NOT NULL | References `STUDENT(student_id)` |
| `offering_id` | **FK** | INT | NOT NULL | References `COURSE_OFFERING(offering_id)` |
| `grade` | - | VARCHAR(20) | DEFAULT 'In Progress' | Final letter grade or completion status |

### 9. ATTENDANCE
*Session-by-session student presence tracking.*
| Attribute | Key Type | Domain / Data Type | Constraint | Description |
|:---|:---:|:---:|:---:|:---|
| `attendance_id` | **PK** | INT | PRIMARY KEY | Unique attendance event record |
| `enrollment_id` | **FK** | INT | NOT NULL | References `ENROLLMENT(enrollment_id)` |
| `class_date` | *Partial key* | DATE | NOT NULL | Date of lecture session |
| `status` | - | VARCHAR(20) | DEFAULT 'Present' | Attendance flag ('Present', 'Absent') |

> **Note — `class_date`:** the diagram labels the primary key explicitly as `attendance_id(PK)` and marks `class_date` with the dotted underline of the legend's *partial key* notation. `ATTENDANCE` is drawn as a regular (strong) entity, so `attendance_id` remains its primary key.

### 10. ASSIGNMENT
*Continuous assessment tasks and homework issued by faculty.*
| Attribute | Key Type | Domain / Data Type | Constraint | Description |
|:---|:---:|:---:|:---:|:---|
| `assignment_id` | **PK** | INT | PRIMARY KEY | Unique assignment identifier |
| `offering_id` | **FK** | INT | NOT NULL | References `COURSE_OFFERING(offering_id)` |
| `title` | - | VARCHAR(150) | NOT NULL | Assignment name/topic |
| `due_date` | - | DATE | NOT NULL | Submission deadline |
| `max_marks` | - | INT | NOT NULL, CHECK (>0) | Total possible marks |

### 11. SUBMISSION
*Student assignment submissions and evaluations.*
| Attribute | Key Type | Domain / Data Type | Constraint | Description |
|:---|:---:|:---:|:---:|:---|
| `submission_id` | **PK** | INT | PRIMARY KEY | Unique submission transaction identifier |
| `assignment_id` | **FK** | INT | NOT NULL | References `ASSIGNMENT(assignment_id)` |
| `student_id` | **FK** | INT | NOT NULL | References `STUDENT(student_id)` |
| `submitted_on` | - | DATETIME | DEFAULT CURRENT_TIMESTAMP | Timestamp of submission |
| `marks` | - | DECIMAL(5,2) | NULLABLE | Evaluated score |

---

## 3. Relationships, Cardinality & Participation Constraints

The ER diagram records the **cardinality** of every relationship with `1` / `M` labels beside each entity. All connectors are drawn as single lines, so **participation constraints are not drawn on the diagram**; they are specified in the table below and enforced in the relational schema through `NOT NULL` foreign keys. **Participation constraints** specify whether the existence of an entity depends on its being related to another entity:
- **Total Participation:** Every entity occurrence in the entity set MUST participate in at least one relationship instance.
- **Partial Participation:** Some entity occurrences may not participate in any relationship instance.

| Relationship | Entity 1 (Parent/Source) | Entity 2 (Child/Target) | Cardinality | Participation (Entity 1 : Entity 2) | Semantic Rule & Technical Rationale |
|:---|:---|:---|:---:|:---:|:---|
| **Offers** | `DEPARTMENT` | `PROGRAM` | **1 : M** | Partial : **Total** | A department may offer 0 or more programs; each program MUST belong to exactly one department (`NOT NULL`). |
| **Owns** | `DEPARTMENT` | `COURSE` | **1 : M** | Partial : **Total** | A department may own multiple courses; each course MUST be owned by an academic department (`NOT NULL`). |
| **Employs** | `DEPARTMENT` | `FACULTY` | **1 : M** | Partial : **Total** | A department employs multiple faculty; every faculty member MUST be appointed to a department (`NOT NULL`). |
| **Heads** | `DEPARTMENT` | `FACULTY` | **1 : 1** | Partial : Partial | A department has at most 1 HOD (initially NULL during creation); a faculty member may head at most 1 department. |
| **Admits** | `PROGRAM` | `STUDENT` | **1 : M** | Partial : **Total** | A degree program admits many students; every student MUST be admitted to an active program (`NOT NULL`). |
| **Scheduled As** | `COURSE` | `COURSE_OFFERING` | **1 : M** | Partial : **Total** | A catalog course may be offered in multiple terms or none; each offering MUST instantiate a catalog course (`NOT NULL`). |
| **Teaches** | `FACULTY` | `COURSE_OFFERING` | **1 : M** | Partial : **Total** | A faculty member may teach zero, one, or multiple offerings; every offering MUST have an assigned faculty instructor. |
| **Hosts** | `CLASSROOM` | `COURSE_OFFERING` | **1 : M** | Partial : **Total** | A classroom may host multiple classes over the week; each course offering MUST be allocated a classroom (`NOT NULL`). |
| **Registers** | `STUDENT` | `ENROLLMENT` | **1 : M** | Partial : **Total** | A student registers in multiple course offerings; each enrollment record MUST belong to an admitted student (`NOT NULL`). |
| **Contains** | `COURSE_OFFERING` | `ENROLLMENT` | **1 : M** | Partial : **Total** | An offering contains multiple enrolled students; each enrollment MUST refer to a valid course offering (`NOT NULL`). |
| **Sets** | `COURSE_OFFERING` | `ASSIGNMENT` | **1 : M** | Partial : **Total** | An offering may have multiple assignments set; each assignment MUST belong to a specific course offering (`NOT NULL`). |
| **Records** | `ENROLLMENT` | `ATTENDANCE` | **1 : M** | Partial : **Total** | An enrollment contains multiple daily attendance logs; each attendance record MUST belong to an enrollment (`NOT NULL`). |
| **Receives** | `ASSIGNMENT` | `SUBMISSION` | **1 : M** | Partial : **Total** | An assignment receives multiple student submissions; each submission MUST be for an existing assignment (`NOT NULL`). |
| **Submits** | `STUDENT` | `SUBMISSION` | **1 : M** | Partial : **Total** | A student submits multiple assignments; each submission MUST be attributed to a valid student (`NOT NULL`). |

---

## 4. Relational Schema Architecture (Stage 4 Deliverable)

### 4.1. Relational Schema Diagram
Below is the formal **Relational Schema Diagram** demonstrating all 11 tables, their column classifications, primary keys (`PK`), and directed referential arrows pointing from foreign keys (`FK`) to parent primary keys.

<p align="center">
  <img src="relational_schema.png" alt="UniTrack Relational Schema Architecture (Stage 4)" width="100%"/>
</p>

*Formats available:* [`relational_schema.png`](relational_schema.png) (High-Resolution Raster PNG) • [`relational_schema.svg`](relational_schema.svg) (Scalable Vector Graphic)

---

### 4.2. Formal Relational Schema Definition
In standard DBMS schema notation, relation names are capitalised, **Primary Keys are underlined**, and Foreign Keys indicate referential links:

1. **DEPARTMENT** (<ins>department_id</ins>, name, hod_faculty_id)  
   *FK:* `hod_faculty_id` $\rightarrow$ `FACULTY(faculty_id)` `[ON UPDATE CASCADE, ON DELETE SET NULL]`

2. **PROGRAM** (<ins>program_id</ins>, name, duration_years, department_id)  
   *FK:* `department_id` $\rightarrow$ `DEPARTMENT(department_id)` `[ON UPDATE CASCADE, ON DELETE RESTRICT]`

3. **FACULTY** (<ins>faculty_id</ins>, name, designation, email, department_id)  
   *FK:* `department_id` $\rightarrow$ `DEPARTMENT(department_id)` `[ON UPDATE CASCADE, ON DELETE RESTRICT]`

4. **COURSE** (<ins>course_id</ins>, code, title, credits, department_id)  
   *FK:* `department_id` $\rightarrow$ `DEPARTMENT(department_id)` `[ON UPDATE CASCADE, ON DELETE RESTRICT]`

5. **CLASSROOM** (<ins>classroom_id</ins>, building, room_no, capacity)  

6. **STUDENT** (<ins>student_id</ins>, usn, name, admission_year, program_id)  
   *FK:* `program_id` $\rightarrow$ `PROGRAM(program_id)` `[ON UPDATE CASCADE, ON DELETE RESTRICT]`

7. **COURSE_OFFERING** (<ins>offering_id</ins>, course_id, faculty_id, classroom_id, semester, year)  
   *FK1:* `course_id` $\rightarrow$ `COURSE(course_id)` `[ON UPDATE CASCADE, ON DELETE RESTRICT]`  
   *FK2:* `faculty_id` $\rightarrow$ `FACULTY(faculty_id)` `[ON UPDATE CASCADE, ON DELETE RESTRICT]`  
   *FK3:* `classroom_id` $\rightarrow$ `CLASSROOM(classroom_id)` `[ON UPDATE CASCADE, ON DELETE RESTRICT]`

8. **ENROLLMENT** (<ins>enrollment_id</ins>, student_id, offering_id, grade)  
   *FK1:* `student_id` $\rightarrow$ `STUDENT(student_id)` `[ON UPDATE CASCADE, ON DELETE RESTRICT]`  
   *FK2:* `offering_id` $\rightarrow$ `COURSE_OFFERING(offering_id)` `[ON UPDATE CASCADE, ON DELETE RESTRICT]`  
   *Candidate Key / Unique Index:* `(student_id, offering_id)`

9. **ATTENDANCE** (<ins>attendance_id</ins>, enrollment_id, class_date, status)  
   *FK:* `enrollment_id` $\rightarrow$ `ENROLLMENT(enrollment_id)` `[ON UPDATE CASCADE, ON DELETE RESTRICT]`

10. **ASSIGNMENT** (<ins>assignment_id</ins>, offering_id, title, due_date, max_marks)  
    *FK:* `offering_id` $\rightarrow$ `COURSE_OFFERING(offering_id)` `[ON UPDATE CASCADE, ON DELETE RESTRICT]`

11. **SUBMISSION** (<ins>submission_id</ins>, assignment_id, student_id, submitted_on, marks)  
    *FK1:* `assignment_id` $\rightarrow$ `ASSIGNMENT(assignment_id)` `[ON UPDATE CASCADE, ON DELETE RESTRICT]`  
    *FK2:* `student_id` $\rightarrow$ `STUDENT(student_id)` `[ON UPDATE CASCADE, ON DELETE RESTRICT]`

---

### 4.3. ER-to-Relational Mapping Rules Applied
1. **Strong Entity Mapping:** Each strong entity becomes an independent relation with its single attribute primary key.
2. **1:M Relationship Mapping:** For all 1:M relationships (e.g., `DEPARTMENT` $\rightarrow$ `PROGRAM`), the primary key of the "1" side is imported into the "M" side as a foreign key (`department_id` in `PROGRAM`).
3. **M:N Relationship Resolution:** The M:N relationship between `STUDENT` and `COURSE_OFFERING` is resolved via the bridge entity `ENROLLMENT`, with a composite unique constraint `(student_id, offering_id)` preventing duplicate registrations.
4. **Resolution of Circular Dependency:** The mutually recursive 1:1 relationship between `DEPARTMENT` (needs HOD) and `FACULTY` (needs Department) is resolved by allowing `DEPARTMENT.hod_faculty_id` to be nullable initially, creating tables in topological order, and adding the foreign key via `ALTER TABLE` with `ON DELETE SET NULL`.
