# UniTrack: Student, Course and Academic Management Database

DBMS Course Project — Team 4

## About

UniTrack is a relational database that manages the full academic cycle of a
university: departments, programmes, students, courses, course offerings,
faculty and classroom assignment, enrollments, attendance, assignments and
submissions.

## Team Members

| S.No | Name                        | USN         |
|------|-----------------------------|-------------|
| 1    | K. Jyoshna                  | AU25UG-026  |
| 2    | Konduru Nanda Kishore Raju  | AU25UG-028  |
| 3    | Melvin Jacob                | AU25UG-034  |
| 4    | Monica Irala                | AU25UG-037  |
| 5    | Naidile D                   | AU25UG-038  |
| 6    | Padmaraju Poojitha          | AU25UG-043  |

## Recommended RDBMS

MySQL, PostgreSQL, or SQL Server (pick one and note it below once decided).

**RDBMS used for this project:** _TODO_

## Folder Structure

```
unitrack/
├── README.md              this file
├── schema/
│   └── create_tables.sql  DDL: creates the database, tables and constraints
├── data/
│   └── insert_data.sql    DML: inserts sample data into every table
├── queries/
│   └── queries.sql        SQL queries answering the business questions
├── diagrams/
│   └── (ER diagram and relational schema diagram, PNG or PDF)
└── docs/
    └── (project report / documentation)
```

## How to Run

1. Install/open your chosen RDBMS (MySQL, PostgreSQL or SQL Server).
2. Run `schema/create_tables.sql` first — this creates the database and all tables.
3. Run `data/insert_data.sql` next — this loads the sample data.
4. Run any query from `queries/queries.sql` to see the results for a business question.

## Status

- [ ] Requirement analysis
- [ ] ER diagram
- [ ] Logical design (schema + keys)
- [ ] Integrity constraints
- [ ] Normalisation (up to 3NF)
- [ ] Implementation (schema/create_tables.sql)
- [ ] Sample data (data/insert_data.sql)
- [ ] SQL queries (queries/queries.sql)
- [ ] Design rationale (docs/)
