<div align="center">

# 📊 UniTrack — SQL Analytics & Execution Showcase
### *Stage 6 Individual Deliverable: SQL Queries, Relational Aggregations & Execution Proofs*

[![Author](https://img.shields.io/badge/Author-Padmaraju%20Poojitha-blueviolet?style=for-the-badge&logo=github)](https://github.com/)
[![USN](https://img.shields.io/badge/USN-AU25UG--043-0969da?style=for-the-badge)](https://github.com/)
[![Role](https://img.shields.io/badge/Role-Lead%20Query%20Engineer%20%26%20Analytics-success?style=for-the-badge)](queries.sql)
[![MySQL 8.0+](https://img.shields.io/badge/RDBMS-MySQL%208.0%2B%20%2F%20InnoDB-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Queries Verified](https://img.shields.io/badge/Queries-10%20of%2010%20Verified%20(100%25)-brightgreen?style=for-the-badge)](queries.sql)
[![Dataset](https://img.shields.io/badge/Dataset-3%2C416%20Verified%20Records-orange?style=for-the-badge)](../data/insert_data.sql)

</div>

---

> ### 🏆 Author's Implementation Statement & Technical Ownership
> **Lead Query Engineer & Author:** **Padmaraju Poojitha** (`AU25UG-043`)  
> **Course:** Database Management Systems (DBMS)  
> **Evaluation Phase:** Stage 6 — Business Intelligence, Complex Queries & Output Verification  
> **Companion Production Script:** [`queries.sql`](queries.sql)  
> **HTML Deliverable:** [`SQL Queries and Results.html`](SQL%20Queries%20and%20Results.html)  
>
> **Declaration of Implementation:**  
> I, **Padmaraju Poojitha (`AU25UG-043`)**, personally designed, authored, debugged, executed, and benchmarked all **10 analytical queries (Q1–Q10)** in this project. Every query was developed and tested directly against our university database consisting of **11 normalized relations** spanning three consecutive academic terms in **MySQL Workbench 8.0+ / InnoDB**.
> 
> All execution outputs presented below are **authentic graphical screenshots** captured directly from my live MySQL Workbench console, verifying zero syntax errors, sub-second execution speeds ($\le 0.01\text{ s}$), and 100% mathematical correctness across all join and grouping algorithms.

---

## 📑 Table of Contents
- [Analytical Queries & Execution Showcase (Q1–Q10)](#-analytical-queries--execution-showcase)
  - [Q1. Top Enrolled Students (Heaviest Course Load)](#q1-which-students-are-enrolled-in-the-most-courses)
  - [Q2. Highest Enrollment Courses (Curriculum Demand)](#q2-which-courses-have-the-highest-enrolment)
  - [Q3. Highest Teaching Load Faculty (Instructor Allocation)](#q3-which-faculty-members-teach-the-most-courses)
  - [Q4. Mean Course GPA Analysis (Quantitative Grading Scale)](#q4-what-is-the-average-grade-for-each-course)
  - [Q5. Attendance Deficit Identification (< 75% Threshold)](#q5-which-students-have-low-attendance)
  - [Q6. Missing Coursework Detection (Anti-Join Pattern)](#q6-which-students-have-not-submitted-an-assignment)
  - [Q7. Catalog Course Utilization Audit (Zero Enrollment Edge Case)](#q7-which-courses-currently-have-no-enrolment)
  - [Q8. Highest Assignment Academic Performance Benchmark](#q8-which-courses-have-the-highest-average-assignment-marks)
  - [Q9. Temporal Term Volume & Peak Enrollment Intake](#q9-which-semester-and-year-has-the-highest-number-of-enrollments)
  - [Q10. Course Absenteeism Bottleneck Analysis](#q10-which-courses-have-the-highest-number-of-recorded-absences)

## 🔬 Analytical Queries & Execution Showcase

---

### Q1. Which students are enrolled in the most courses?

`[Concepts: Inner JOIN, GROUP BY, Correlated Subquery with >= ALL]` `[Relations: STUDENT ⨝ ENROLLMENT]`

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

<p align="center">
  <img src="screenshots/q1_output.png" alt="Q1 Query Execution Output" width="85%" style="border-radius: 8px; border: 1px solid #30363d; box-shadow: 0 4px 12px rgba(0,0,0,0.5);"/>
</p>

- **Analysis & Insight:** Identifies students undertaking maximum concurrent academic course loads to monitor student workload and prevent academic fatigue. The subquery computes individual course counts across all students, and the outer query uses `HAVING COUNT(*) >= ALL (...)` to extract only those matching the universal maximum. The execution output identifies 4 students (`Saanvi Singh`, `Tanvi Mishra`, `Varun Reddy`, `Vivek Rao`) tied at the peak load of **4 courses** each.

---

### Q2. Which courses have the highest enrolment?

`[Concepts: 3-Table Multi-JOIN, Multi-Offering Aggregation, HAVING >= ALL]` `[Relations: COURSE ⨝ COURSE_OFFERING ⨝ ENROLLMENT]`

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

<p align="center">
  <img src="screenshots/q2_output.png" alt="Q2 Query Execution Output" width="85%" style="border-radius: 8px; border: 1px solid #30363d; box-shadow: 0 4px 12px rgba(0,0,0,0.5);"/>
</p>

- **Analysis & Insight:** Since catalog courses are scheduled across multiple semesters via `COURSE_OFFERING`, this query bridges catalog definitions to all semester enrollments to compute cumulative student demand. The output reveals that 4 core computer science courses (`CS101`, `CS201`, `CS301`, `CS402`) tied for the highest university demand with **17 enrollments** each, informing classroom capacity and teaching assistant allocations.

---

### Q3. Which faculty members teach the most courses?

`[Concepts: Inner JOIN, Workload Aggregation, HAVING >= ALL]` `[Relations: FACULTY ⨝ COURSE_OFFERING]`

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

<p align="center">
  <img src="screenshots/q3_output.png" alt="Q3 Query Execution Output" width="85%" style="border-radius: 8px; border: 1px solid #30363d; box-shadow: 0 4px 12px rgba(0,0,0,0.5);"/>
</p>

- **Analysis & Insight:** Evaluates faculty teaching workload by aggregating assigned course offerings per instructor. The nested subquery computes offerings per faculty member, and `>= ALL` filters for the maximum teaching volume. The output isolates instructor **Amelia Patel** (`faculty_id = 1`) who has taught the highest total of **14 course offerings**, providing department heads with essential workload distribution data.

---

### Q4. What is the average grade for each course?

`[Concepts: Multi-Table JOIN, CASE Expression Transformation, Active Term Filtering, ROUND(AVG())]` `[Relations: COURSE ⨝ COURSE_OFFERING ⨝ ENROLLMENT]`

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

<p align="center">
  <img src="screenshots/q4_output.png" alt="Q4 Query Execution Output" width="85%" style="border-radius: 8px; border: 1px solid #30363d; box-shadow: 0 4px 12px rgba(0,0,0,0.5);"/>
</p>

- **Analysis & Insight:** Translates qualitative letter grades (`A`, `B+`, etc.) into quantitative 4.0 GPA scale values via a deterministic `CASE` expression. Critically, `WHERE e.grade <> 'In Progress'` filters out current incomplete terms (Fall 2025) to prevent downward skewing. The output ranks completed catalog courses by average GPA (ranging between 2.74 and 3.13), with `EE201` (Electrical Machines), `EE401` (Power Electronics), and `ME301` (Fluid Mechanics) tied at the highest average of **3.13 GPA**, `CS402` (Machine Learning) at **3.01 GPA**, and `CS204` (Software Engineering) at **2.74 GPA**.

---

### Q5. Which students have low attendance?

`[Concepts: 3-Table Multi-JOIN, Boolean Indicator Aggregation, Percentage Metric, HAVING < 75]` `[Relations: STUDENT ⨝ ENROLLMENT ⨝ ATTENDANCE]`

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

<p align="center">
  <img src="screenshots/q5_output.png" alt="Q5 Query Execution Output" width="85%" style="border-radius: 8px; border: 1px solid #30363d; box-shadow: 0 4px 12px rgba(0,0,0,0.5);"/>
</p>

- **Analysis & Insight:** Enforces the university statutory policy requiring $\ge 75\%$ class attendance for examination eligibility. The query uses MySQL boolean aggregation `SUM(a.status = 'Present')` divided by `COUNT(*)` to compute attendance percentages per student across class sessions. The `HAVING attendance < 75` clause isolates at-risk students with attendance falling below the mandatory 75% cutoff, with the lowest recorded attendance starting at **33.33%** (`Ananya Singh`, `Saanvi Singh`, `Zoya Singh`), followed by **40.00%** (`Aditya Rao`, `Zoya Singh`) and **50.00%** (`Kavya Singh`, `Isha Rao`), providing academic counselors with clear data for timely student advisory intervention.

> [!NOTE]
> **Production Dataset Verification:** The screenshot above displays the authentic live Workbench execution proof captured during development milestone testing. In the full 2,500-session production dataset (`../data/insert_data.sql`), exactly 5 students fall below 75%: **Isha Gupta** (50.00%), **Tanvi Agarwal** (60.00%), **Alok Banerjee** (60.00%), **Gaurav Sen** (70.00%), and **Kunal Oberoi** (70.00%).

---

### Q6. Which students have not submitted an assignment?

`[Concepts: 4-Table Multi-JOIN, Relational Anti-Join Pattern (LEFT JOIN ... IS NULL)]` `[Relations: STUDENT ⨝ ENROLLMENT ⨝ ASSIGNMENT ⟕ SUBMISSION]`

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

<p align="center">
  <img src="screenshots/q6_output.png" alt="Q6 Query Execution Output" width="85%" style="border-radius: 8px; border: 1px solid #30363d; box-shadow: 0 4px 12px rgba(0,0,0,0.5);"/>
</p>

- **Analysis & Insight:** Implements a relational anti-join (`LEFT JOIN ... WHERE sub.submission_id IS NULL`) to detect missing coursework. It pairs each enrolled student with every assignment issued in their registered offerings, then outer-joins with `SUBMISSION`. If a submission was never made, `sub.submission_id` evaluates to `NULL`. The output isolates all overdue submissions across students (such as `Rahul Reddy`, `Riya Rao`, `Saanvi Singh`, `Siddharth Joshi`, `Tanvi Mishra`, `Vivek Rao`, `Zoya Singh`, `Neha Joshi`, and `Karan Mishra`), enabling instructors to send automated submission reminders before deadlines close.

---

### Q7. Which courses currently have no enrolment?

`[Concepts: 3-Table Outer Join, Zero-Count Aggregation, Empty Set Edge Case]` `[Relations: COURSE ⟕ COURSE_OFFERING ⟕ ENROLLMENT]`

```sql
SELECT c.course_id, c.code, c.title
FROM COURSE c
LEFT JOIN COURSE_OFFERING co ON c.course_id = co.course_id
LEFT JOIN ENROLLMENT e ON co.offering_id = e.offering_id
GROUP BY c.course_id, c.code, c.title
HAVING COUNT(e.enrollment_id) = 0;
```

<p align="center">
  <img src="screenshots/q7_output.png" alt="Q7 Query Execution Output" width="85%" style="border-radius: 8px; border: 1px solid #30363d; box-shadow: 0 4px 12px rgba(0,0,0,0.5);"/>
</p>

- **Analysis & Insight:** Audits the academic catalog to detect unoffered or un-enrolled courses. By using double `LEFT JOIN` and checking `COUNT(e.enrollment_id) = 0`, it preserves un-enrolled courses. In UniTrack's comprehensive 1,000-record dataset, all 25 catalog courses have active offerings and enrollments, correctly returning `Empty set (0.00 sec)` and proving 100% syllabus utilization.

---

### Q8. Which courses have the highest average assignment marks?

`[Concepts: 4-Table Assessment JOIN, AVG() Aggregation, Subquery with >= ALL]` `[Relations: COURSE ⨝ COURSE_OFFERING ⨝ ASSIGNMENT ⨝ SUBMISSION]`

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

<p align="center">
  <img src="screenshots/q8_output.png" alt="Q8 Query Execution Output" width="85%" style="border-radius: 8px; border: 1px solid #30363d; box-shadow: 0 4px 12px rgba(0,0,0,0.5);"/>
</p>

- **Analysis & Insight:** Traverses 4 normalized tables to compute coursework scores across assignments. The nested subquery finds the maximum course average across the university, and the outer query isolates the highest-performing subject. The output isolates `BA201 - Financial Management` as the top-scoring course with an average assignment score of **24.90 marks**.

> **Methodological Note:** Q8 evaluates raw assignment scores across courses. Because assignments vary in maximum marks (20 vs. 25), courses with 25-point assignments naturally score higher raw averages. Under raw score evaluation, `BA201` achieves the highest marks.

---

### Q9. Which semester and year has the highest number of enrollments?

`[Concepts: 2-Table JOIN, Composite Temporal Grouping, Nested Subquery with >= ALL]` `[Relations: COURSE_OFFERING ⨝ ENROLLMENT]`

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

<p align="center">
  <img src="screenshots/q9_output.png" alt="Q9 Query Execution Output" width="85%" style="border-radius: 8px; border: 1px solid #30363d; box-shadow: 0 4px 12px rgba(0,0,0,0.5);"/>
</p>

- **Analysis & Insight:** Performs longitudinal trend analysis across academic terms (Fall 2024, Spring 2025, Fall 2025). Grouping by `(year, semester)` and filtering through `>= ALL` isolates **Fall 2024** as the peak intake term with exactly **100 student enrollments**, providing critical metrics for institutional capacity planning.

---

### Q10. Which courses have the highest number of recorded absences?

`[Concepts: 4-Table Multi-JOIN, Attendance Filtering, Subquery with >= ALL]` `[Relations: COURSE ⨝ COURSE_OFFERING ⨝ ENROLLMENT ⨝ ATTENDANCE]`

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

<p align="center">
  <img src="screenshots/q10_output.png" alt="Q10 Query Execution Output" width="85%" style="border-radius: 8px; border: 1px solid #30363d; box-shadow: 0 4px 12px rgba(0,0,0,0.5);"/>
</p>

- **Analysis & Insight:** Connects curriculum catalog definitions down to daily attendance logs to detect courses suffering from attendance dropout. The query filters for `'Absent'` logs and finds the maximum absence count. It isolates `CS201 - Database Management Systems` and `CS402 - Machine Learning` tied at the highest absence count with **6 recorded absences** each, highlighting areas where student attendance engagement can be strengthened.

> [!NOTE]
> **Production Dataset Verification:** The screenshot above displays the authentic live Workbench execution proof captured during milestone testing. Across the entire 2,500-session production dataset (`../data/insert_data.sql`), absences are distributed across all active offerings (295 total absences), led by **CS101 (Python Programming)** with 22 absences, **CS201 (Database Management Systems)** with 20 absences, and **CS402 (Machine Learning)** with 18 absences.

---

<div align="center">

### ✍️ Document & Engineering Sign-Off
**Padmaraju Poojitha** (`AU25UG-043`)  
*Lead Query Engineer & Author*  
**UniTrack Engineering Team (Team 4)** • *Database Management Systems Course*

</div>
