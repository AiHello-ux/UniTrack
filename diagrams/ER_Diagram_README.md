# UniTrack ER Diagram

## 1. Diagram
![UniTrack ER diagram in Chen notation](ER_Diagram.png)
The ER diagram represents the conceptual design of the UniTrack database. It illustrates the data stored in the system and how the data is connected through entities, attributes, and relationships with their cardinality.

## 2. Entities and Attributes

### DEPARTMENT

| Attribute      | Key | Description                            |
| -------------- | --- | -------------------------------------- |
| department_id  | PK  | Unique department identifier           |
| name           |  -  | Department name                        |
| hod_faculty_id | FK  | Head of department, references FACULTY |

### PROGRAM

| Attribute      | Key | Description                          |
| -------------- | --- | ------------------------------------ |
| program_id     | PK  | Unique programme identifier          |
| name           |  -  | Programme name                       |
| duration_years |  -  | Length of the programme in years     |
| department_id  | FK  | Department that offers the programme |

### STUDENT

| Attribute      | Key | Description                      |
| -------------- | --- | -------------------------------- |
| student_id     | PK  | Unique student identifier        |
| usn            |  -  | University serial number         |
| name           |  -  | Student name                     |
| admission_year |  -  | Year of admission                |
| program_id     | FK  | Programme the student belongs to |

### FACULTY

| Attribute     | Key | Description                                                     |
| ------------- | --- | --------------------------------------------------------------- |
| faculty_id    | PK  | Unique faculty identifier                                       |
| name          |   - | Faculty member name                                             |
| designation   |   - | Professor, Associate Professor, Assistant Professor or Lecturer |
| email         |   - | Email address                                                   |
| department_id | FK  | Department the faculty member belongs to                        |

### COURSE

| Attribute     | Key | Description                     |
| ------------- | --- | ------------------------------- |
| course_id     | PK  | Unique course identifier        |
| code          |  -  | Course code                     |
| title         |  -  | Course title                    |
| credits       |  -  | Credit value of the course      |
| department_id | FK  | Department that owns the course |

### CLASSROOM

| Attribute    | Key | Description                     |
| ------------ | --- | ------------------------------- |
| classroom_id | PK  | Unique classroom identifier     |
| building     |  -  | Building name                   |
| room_no      | -   | Room number within the building |
| capacity     |  -   | Number of seats                 |

### COURSE_OFFERING

| Attribute    | Key | Description                          |
| ------------ | --- | ------------------------------------ |
| offering_id  | PK  | Unique offering identifier           |
| semester     | -   | Fall, Spring or Summer               |
| year         | -   | Calendar year of the offering        |
| course_id    | FK  | Course being offered                 |
| faculty_id   | FK  | Faculty member teaching the offering |
| classroom_id | FK  | Classroom where the offering is held |

### ENROLLMENT

| Attribute     | Key | Description                                        |
| ------------- | --- | -------------------------------------------------- |
| enrollment_id | PK  | Unique enrollment identifier                       |
| grade         | -   | Final grade, empty while the course is in progress |
| student_id    | FK  | Enrolled student                                   |
| offering_id   | FK  | Course offering the student is registered in       |

### ATTENDANCE

| Attribute     | Key | Description                         |
| ------------- | --- | ----------------------------------- |
| attendance_id | PK  | Unique attendance record identifier |
| class_date    | -   | Date of the class session           |
| status        | -   | Present, Absent, Late or Excused    |
| enrollment_id | FK  | Enrollment the record belongs to    |

### ASSIGNMENT

| Attribute     | Key | Description                               |
| ------------- | --- | ----------------------------------------- |
| assignment_id | PK  | Unique assignment identifier              |
| title         | -   | Assignment title                          |
| due_date      | -   | Submission deadline                       |
| max_marks     | -   | Maximum marks available                   |
| offering_id   | FK  | Course offering the assignment is set for |

### SUBMISSION

| Attribute     | Key | Description                     |
| ------------- | --- | ------------------------------- |
| submission_id | PK  | Unique submission identifier    |
| submitted_on  | -   | Date the work was submitted     |
| marks         | -   | Marks awarded                   |
| assignment_id | FK  | Assignment being answered       |
| student_id    | FK  | Student who made the submission |

## 3. Relationships and Cardinality

| Relationship | Entities                    | Cardinality | Meaning                                                                                  |
| ------------ | --------------------------- | ----------- | ---------------------------------------------------------------------------------------- |
| Offers       | DEPARTMENT, PROGRAM         | 1:M         | A department offers many programmes; each programme belongs to one department            |
| Owns         | DEPARTMENT, COURSE          | 1:M         | A department owns many courses; each course belongs to one department                    |
| Employs      | DEPARTMENT, FACULTY         | 1:M         | A department employs many faculty members; each faculty member belongs to one department |
| Heads        | DEPARTMENT, FACULTY         | 1:1         | A department has one head; a faculty member heads one department                         |
| Admits       | PROGRAM, STUDENT            | 1:M         | A programme admits many students; each student belongs to one programme                  |
| Scheduled As | COURSE, COURSE_OFFERING     | 1:M         | A course can be offered in many semesters; each offering is of one course                |
| Teaches      | FACULTY, COURSE_OFFERING    | 1:M         | A faculty member teaches many offerings; each offering has one faculty member            |
| Hosts        | CLASSROOM, COURSE_OFFERING  | 1:M         | A classroom hosts many offerings; each offering uses one classroom                       |
| Registers    | STUDENT, ENROLLMENT         | 1:M         | A student has many enrollments; each enrollment belongs to one student                   |
| Contains     | COURSE_OFFERING, ENROLLMENT | 1:M         | An offering has many enrollments; each enrollment is in one offering                     |
| Sets         | COURSE_OFFERING, ASSIGNMENT | 1:M         | An offering has many assignments; each assignment belongs to one offering                |
| Records      | ENROLLMENT, ATTENDANCE      | 1:M         | An enrollment has many attendance records; each record belongs to one enrollment         |
| Receives     | ASSIGNMENT, SUBMISSION      | 1:M         | An assignment receives many submissions; each submission is for one assignment           |
| Submits      | STUDENT, SUBMISSION         | 1:M         | A student makes many submissions; each submission is by one student                      |
