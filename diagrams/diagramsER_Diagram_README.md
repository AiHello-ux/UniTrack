# UniTrack — Conceptual ER Diagram

> **Role:** ER Diagram Designer (Conceptual ER Design)  
> **Project:** UniTrack — University Academic Management Database  
> **Course:** Database Management Systems (DBMS)  
> **Deliverable:** Conceptual Entity-Relationship (ER) Diagram

---

## 1. Purpose of the ER Diagram

The Entity-Relationship (ER) diagram presents the conceptual design of the UniTrack database. It shows the main academic entities, their attributes, the relationships between them, and the cardinalities of those relationships. The diagram covers departments, programs, students, faculty, courses, classrooms, course offerings, enrollments, attendance, assignments, and submissions.

![UniTrack ER diagram in Chen notation](ER_Diagram.png)

*Editable diagram source:* [`UniTrack - ER Diagram.drawio`](UniTrack%20-%20ER%20Diagram.drawio)

## 2. Entities Identified

The ER diagram contains these 11 strong entities:

1. **DEPARTMENT** — department details and its head of department (HOD).
2. **PROGRAM** — academic degree programs offered by departments.
3. **STUDENT** — student details and the program they belong to.
4. **FACULTY** — faculty details and department assignment.
5. **COURSE** — the university's course catalog.
6. **CLASSROOM** — room, building, and seating capacity details.
7. **COURSE_OFFERING** — a course scheduled for a particular semester and year, with an instructor and classroom.
8. **ENROLLMENT** — connects a student to a specific course offering.
9. **ATTENDANCE** — attendance records associated with an enrollment.
10. **ASSIGNMENT** — assignments created for a course offering.
11. **SUBMISSION** — a student's submission for an assignment, including submission time and marks.

## 3. Attributes and Keys Shown

The diagram shows the attributes belonging to each entity. Underlined attributes indicate primary keys, and attributes marked **(FK)** indicate foreign-key references in the relational implementation.

- **DEPARTMENT:** `department_id`, `name`, `hod_faculty_id`
- **PROGRAM:** `program_id`, `name`, `duration_years`, `department_id`
- **STUDENT:** `student_id`, `usn`, `name`, `admission_year`, `program_id`
- **FACULTY:** `faculty_id`, `name`, `designation`, `email`, `department_id`
- **COURSE:** `course_id`, `code`, `title`, `credits`, `department_id`
- **CLASSROOM:** `classroom_id`, `building`, `room_no`, `capacity`
- **COURSE_OFFERING:** `offering_id`, `semester`, `year`, `course_id`, `faculty_id`, `classroom_id`
- **ENROLLMENT:** `enrollment_id`, `student_id`, `offering_id`, `grade`
- **ATTENDANCE:** `attendance_id`, `enrollment_id`, `class_date`, `status`
- **ASSIGNMENT:** `assignment_id`, `offering_id`, `title`, `due_date`, `max_marks`
- **SUBMISSION:** `submission_id`, `assignment_id`, `student_id`, `submitted_on`, `marks`

## 4. Relationships and Cardinalities

The diagram represents the following relationships:

| Relationship | Cardinality | Meaning |
|---|:---:|---|
| DEPARTMENT — Offers — PROGRAM | 1:M | One department may offer multiple programs. |
| DEPARTMENT — Owns — COURSE | 1:M | One department may own multiple courses. |
| DEPARTMENT — Employs — FACULTY | 1:M | One department may employ multiple faculty members. |
| DEPARTMENT — Heads — FACULTY (HOD) | 1:1 | A department has at most one HOD. |
| PROGRAM — Admits — STUDENT | 1:M | One program may have many students. |
| COURSE — Scheduled As — COURSE_OFFERING | 1:M | A course may have multiple offerings over different terms. |
| FACULTY — Teaches — COURSE_OFFERING | 1:M | A faculty member may teach multiple offerings. |
| CLASSROOM — Hosts — COURSE_OFFERING | 1:M | A classroom may host multiple offerings at different times. |
| STUDENT — Registers — ENROLLMENT | 1:M | A student may have multiple enrollment records. |
| COURSE_OFFERING — Contains — ENROLLMENT | 1:M | An offering may have multiple enrolled students. |
| COURSE_OFFERING — Sets — ASSIGNMENT | 1:M | An offering may have multiple assignments. |
| ENROLLMENT — Records — ATTENDANCE | 1:M | An enrollment may have multiple attendance records. |
| ASSIGNMENT — Receives — SUBMISSION | 1:M | An assignment may receive multiple submissions. |
| STUDENT — Submits — SUBMISSION | 1:M | A student may submit multiple assignments. |



## 5. ER Diagram Notation

- **Rectangle:** entity
- **Diamond:** relationship
- **Ellipse:** attribute
- **Underlined attribute:** primary key
- **(FK):** foreign-key attribute in the relational implementation
- **1 and M labels:** relationship cardinality

## 7. My Contribution

My contribution to UniTrack was the **conceptual ER diagram**. I identified the entities and their attributes, marked the key attributes, and represented the relationships, cardinalities. 
