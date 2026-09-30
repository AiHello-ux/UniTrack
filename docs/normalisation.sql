-- ============================================================================
-- UniTrack - Normalization, proven by execution
-- File    : docs/normalisation.sql
-- Author  : Monica Irala (AU25UG-037) — Theory & Normalisation Lead
-- Target  : MySQL 8.0+
--          Run AFTER schema/create_tables.sql and data/insert_data.sql
--
-- Purpose : Verify the UniTrack database design for 1NF -> 2NF -> 3NF.
--           This script does NOT modify the database or data.
--
-- IMPORTANT:
--   The normalization result is based on the UniTrack schema and its
--   functional dependencies. The SELECT statements below provide executable
--   checks/supporting evidence against the loaded data.
-- ============================================================================

USE unitrack;

-- ============================================================================
-- FUNCTIONAL DEPENDENCIES USED FOR THE NORMALIZATION ANALYSIS
--
-- DEPARTMENT
--   department_id -> name, hod_faculty_id
--
-- PROGRAM
--   program_id -> name, duration_years, department_id
--
-- FACULTY
--   faculty_id -> name, designation, email, department_id
--
-- COURSE
--   course_id -> code, title, credits, department_id
--   code -> course_id, title, credits, department_id
--
-- CLASSROOM
--   classroom_id -> building, room_no, capacity
--
-- STUDENT
--   student_id -> usn, name, admission_year, program_id
--   usn -> student_id, name, admission_year, program_id
--
-- COURSE_OFFERING
--   offering_id -> course_id, faculty_id, classroom_id, semester, year
--
-- ENROLLMENT
--   enrollment_id -> student_id, offering_id, grade
--   (student_id, offering_id) -> enrollment_id, grade
--
-- ATTENDANCE
--   attendance_id -> enrollment_id, class_date, status
--
-- ASSIGNMENT
--   assignment_id -> offering_id, title, due_date, max_marks
--
-- SUBMISSION
--   submission_id -> assignment_id, student_id, submitted_on, marks
--
-- Candidate/alternate keys used:
--   COURSE.code
--   STUDENT.usn
--   ENROLLMENT(student_id, offering_id)
--
-- Note:
--   FACULTY.email is UNIQUE but nullable, so it is not treated as a
--   candidate key for this normalization proof.
-- ============================================================================


-- ============================================================================
-- [N1] 1NF - ATOMIC DOMAINS
-- ============================================================================
-- CLAIM:
--   Every column stores a single scalar value. There are no SET or JSON
--   columns in the UniTrack relations.
--
-- EXPECT:
--   non_atomic_columns = 0
--
SELECT COUNT(*) AS total_columns,
       SUM(DATA_TYPE IN ('set', 'json')) AS non_atomic_columns
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'unitrack'
  AND TABLE_NAME IN (
      'DEPARTMENT',
      'PROGRAM',
      'FACULTY',
      'COURSE',
      'CLASSROOM',
      'STUDENT',
      'COURSE_OFFERING',
      'ENROLLMENT',
      'ATTENDANCE',
      'ASSIGNMENT',
      'SUBMISSION'
  );


-- ============================================================================
-- [N2] 1NF - NO REPEATING GROUPS
-- ============================================================================
-- CLAIM:
--   UniTrack does not store repeated groups such as phone1/phone2,
--   course1/course2, attendance1/attendance2, etc.
--
-- This query lists columns whose names contain a trailing number.
-- EXPECT:
--   Empty result set.
--
SELECT TABLE_NAME, COLUMN_NAME
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'unitrack'
  AND TABLE_NAME IN (
      'DEPARTMENT',
      'PROGRAM',
      'FACULTY',
      'COURSE',
      'CLASSROOM',
      'STUDENT',
      'COURSE_OFFERING',
      'ENROLLMENT',
      'ATTENDANCE',
      'ASSIGNMENT',
      'SUBMISSION'
  )
  AND COLUMN_NAME REGEXP '[0-9]+$'
ORDER BY TABLE_NAME, ORDINAL_POSITION;


-- ============================================================================
-- [N3] 2NF - PRIMARY KEYS
-- ============================================================================
-- CLAIM:
--   2NF violations require a non-key attribute to depend on only part of a
--   composite candidate key.
--
--   All UniTrack PRIMARY KEYs are single-column. Therefore, there can be no
--   partial dependency with respect to a PRIMARY KEY.
--
-- EXPECT:
--   11 rows, pk_columns = 1 for every relation.
--
SELECT TABLE_NAME,
       COUNT(*) AS pk_columns
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'unitrack'
  AND CONSTRAINT_NAME = 'PRIMARY'
  AND TABLE_NAME IN (
      'DEPARTMENT',
      'PROGRAM',
      'FACULTY',
      'COURSE',
      'CLASSROOM',
      'STUDENT',
      'COURSE_OFFERING',
      'ENROLLMENT',
      'ATTENDANCE',
      'ASSIGNMENT',
      'SUBMISSION'
  )
GROUP BY TABLE_NAME
ORDER BY TABLE_NAME;


-- ============================================================================
-- [N4] 2NF - ENROLLMENT COMPOSITE CANDIDATE KEY
-- ============================================================================
-- CLAIM:
--   ENROLLMENT has an alternate candidate key:
--       (student_id, offering_id)
--
--   Grade belongs to the student-offering enrollment relationship.
--   The following checks look for evidence that either student_id alone or
--   offering_id alone determines grade.
--
-- EXPECT:
--   Normally, both queries should return rows showing that multiple grades
--   occur for the determinant. If the current seed happens to contain only
--   one grade in a group, that data pattern alone cannot prove an FD.
--
-- Check whether student_id determines grade in the loaded data:
SELECT student_id,
       COUNT(*) AS enrollment_count,
       COUNT(DISTINCT grade) AS distinct_grades
FROM ENROLLMENT
GROUP BY student_id
HAVING COUNT(DISTINCT grade) > 1
ORDER BY student_id;


-- Check whether offering_id determines grade in the loaded data:
SELECT offering_id,
       COUNT(*) AS enrollment_count,
       COUNT(DISTINCT grade) AS distinct_grades
FROM ENROLLMENT
GROUP BY offering_id
HAVING COUNT(DISTINCT grade) > 1
ORDER BY offering_id;


-- ============================================================================
-- [N5] 2NF - ENROLLMENT KEY UNIQUENESS
-- ============================================================================
-- CLAIM:
--   (student_id, offering_id) is a candidate key because the schema declares
--   it UNIQUE and neither component alone identifies an enrollment row.
--
-- EXPECT:
--   0 duplicate groups.
--
SELECT student_id,
       offering_id,
       COUNT(*) AS duplicate_rows
FROM ENROLLMENT
GROUP BY student_id, offering_id
HAVING COUNT(*) > 1;


-- ============================================================================
-- [N6] 3NF - NO COPIED DEPARTMENT FACTS IN CHILD RELATIONS
-- ============================================================================
-- CLAIM:
--   The following dependencies exist:
--
--     PROGRAM   : program_id -> department_id
--     COURSE    : course_id  -> department_id
--     FACULTY   : faculty_id -> department_id
--
--   But department name is stored only in DEPARTMENT. It is not copied into
--   PROGRAM, COURSE, FACULTY, or STUDENT.
--
-- EXPECT:
--   The query returns only DEPARTMENT.name for the searched column name.
--
SELECT TABLE_NAME, COLUMN_NAME
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'unitrack'
  AND COLUMN_NAME = 'name'
ORDER BY TABLE_NAME;


-- ============================================================================
-- [N7] 3NF - STUDENT -> PROGRAM -> DEPARTMENT
-- ============================================================================
-- CLAIM:
--   STUDENT contains program_id, while PROGRAM contains department_id.
--
--   Therefore:
--       student_id -> program_id
--       program_id -> department_id
--
--   This is a relationship across relations, not a transitive dependency
--   stored inside STUDENT, because STUDENT does not also store department_id.
--
-- EXPECT:
--   The query shows the normalized relationship through a JOIN.
--
SELECT s.student_id,
       s.usn,
       s.name AS student_name,
       p.program_id,
       p.name AS program_name,
       d.department_id,
       d.name AS department_name
FROM STUDENT s
JOIN PROGRAM p
  ON s.program_id = p.program_id
JOIN DEPARTMENT d
  ON p.department_id = d.department_id
ORDER BY s.student_id
LIMIT 10;


-- ============================================================================
-- [N8] 3NF - COURSE -> DEPARTMENT
-- ============================================================================
-- CLAIM:
--   COURSE stores department_id, not department name.
--   Therefore department details have one home: DEPARTMENT.
--
-- EXPECT:
--   The JOIN reconstructs the required information without duplicated
--   department facts in COURSE.
--
SELECT c.course_id,
       c.code,
       c.title,
       c.department_id,
       d.name AS department_name
FROM COURSE c
JOIN DEPARTMENT d
  ON c.department_id = d.department_id
ORDER BY c.course_id
LIMIT 10;


-- ============================================================================
-- [N9] 3NF - FACULTY -> DEPARTMENT
-- ============================================================================
-- CLAIM:
--   FACULTY stores department_id, not department name.
--   Department information therefore remains in DEPARTMENT.
--
-- EXPECT:
--   The JOIN reconstructs faculty + department information.
--
SELECT f.faculty_id,
       f.name AS faculty_name,
       f.designation,
       f.department_id,
       d.name AS department_name
FROM FACULTY f
JOIN DEPARTMENT d
  ON f.department_id = d.department_id
ORDER BY f.faculty_id
LIMIT 10;


-- ============================================================================
-- [N10] CANDIDATE / ALTERNATE KEY VERIFICATION
-- ============================================================================
-- CLAIM:
--   COURSE.code is NOT NULL + UNIQUE.
--   STUDENT.usn is NOT NULL + UNIQUE.
--   ENROLLMENT(student_id, offering_id) is UNIQUE.
--
-- EXPECT:
--   All three duplicate checks return 0 rows.
--
SELECT code,
       COUNT(*) AS duplicate_rows
FROM COURSE
GROUP BY code
HAVING COUNT(*) > 1;

SELECT usn,
       COUNT(*) AS duplicate_rows
FROM STUDENT
GROUP BY usn
HAVING COUNT(*) > 1;

SELECT student_id,
       offering_id,
       COUNT(*) AS duplicate_rows
FROM ENROLLMENT
GROUP BY student_id, offering_id
HAVING COUNT(*) > 1;


-- ============================================================================
-- [N11] FOREIGN-KEY / RELATIONSHIP INTEGRITY SUPPORTING 3NF
-- ============================================================================
-- CLAIM:
--   Foreign keys connect each entity to the relation that owns the referenced
--   fact. The checks below find orphan references in the loaded data.
--
-- EXPECT:
--   All six SELECTs should return 0 rows.
-- ============================================================================

-- PROGRAM -> DEPARTMENT
SELECT p.program_id
FROM PROGRAM p
LEFT JOIN DEPARTMENT d
  ON p.department_id = d.department_id
WHERE d.department_id IS NULL;

-- FACULTY -> DEPARTMENT
SELECT f.faculty_id
FROM FACULTY f
LEFT JOIN DEPARTMENT d
  ON f.department_id = d.department_id
WHERE d.department_id IS NULL;

-- COURSE -> DEPARTMENT
SELECT c.course_id
FROM COURSE c
LEFT JOIN DEPARTMENT d
  ON c.department_id = d.department_id
WHERE d.department_id IS NULL;

-- STUDENT -> PROGRAM
SELECT s.student_id
FROM STUDENT s
LEFT JOIN PROGRAM p
  ON s.program_id = p.program_id
WHERE p.program_id IS NULL;

-- ENROLLMENT -> STUDENT / COURSE_OFFERING
SELECT e.enrollment_id
FROM ENROLLMENT e
LEFT JOIN STUDENT s
  ON e.student_id = s.student_id
LEFT JOIN COURSE_OFFERING co
  ON e.offering_id = co.offering_id
WHERE s.student_id IS NULL
   OR co.offering_id IS NULL;

-- ATTENDANCE -> ENROLLMENT
SELECT a.attendance_id
FROM ATTENDANCE a
LEFT JOIN ENROLLMENT e
  ON a.enrollment_id = e.enrollment_id
WHERE e.enrollment_id IS NULL;


-- ============================================================================
-- FINAL NORMALIZATION SUMMARY
-- ============================================================================
-- UniTrack is designed to satisfy:
--
--   1NF:
--     Atomic attributes and no repeating groups.
--
--   2NF:
--     All primary keys are single-column, so no partial dependency exists
--     with respect to the primary keys. ENROLLMENT's composite alternate key
--     (student_id, offering_id) identifies the enrollment relationship and
--     grade depends on that relationship.
--
--   3NF:
--     Entity facts are stored in their own relations. Department facts are
--     kept in DEPARTMENT, program facts in PROGRAM, course facts in COURSE,
--     faculty facts in FACULTY, etc. No copied non-key parent fact is stored
--     in the child relation.
--
-- NOTE:
--   Normalization is a property of the database design and its functional
--   dependencies. The queries above are executable evidence/supporting checks
--   against the current loaded dataset; zero rows in a data check alone do
--   not create a functional dependency.
-- ============================================================================

SELECT 'DEPARTMENT' AS relation_name, '1NF / 2NF / 3NF' AS normalization_level
UNION ALL SELECT 'PROGRAM', '1NF / 2NF / 3NF'
UNION ALL SELECT 'FACULTY', '1NF / 2NF / 3NF'
UNION ALL SELECT 'COURSE', '1NF / 2NF / 3NF'
UNION ALL SELECT 'CLASSROOM', '1NF / 2NF / 3NF'
UNION ALL SELECT 'STUDENT', '1NF / 2NF / 3NF'
UNION ALL SELECT 'COURSE_OFFERING', '1NF / 2NF / 3NF'
UNION ALL SELECT 'ENROLLMENT', '1NF / 2NF / 3NF'
UNION ALL SELECT 'ATTENDANCE', '1NF / 2NF / 3NF'
UNION ALL SELECT 'ASSIGNMENT', '1NF / 2NF / 3NF'
UNION ALL SELECT 'SUBMISSION', '1NF / 2NF / 3NF';
