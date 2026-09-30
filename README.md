# 👥 UniTrack — Team Contributions & Engineering Role Matrix

<div align="center">

### **Database Management Systems (DBMS) — Academic Project Submission**
**Team 4 — Higher Education Academic Tracking Database System**  
*Target RDBMS: MySQL 8.0+ (InnoDB) • Normalization: Third Normal Form (3NF)*

---

</div>

## 📌 Executive Summary of Team Ownership

The **UniTrack** university database project was developed collaboratively by a dedicated 6-member engineering team. Each phase of the database development lifecycle was assigned to an individual stage lead to guarantee deep accountability, peer-reviewed engineering rigor, and seamless integration from system requirements to analytical reporting.

---

## 🏆 Master Contributions & Role Matrix

| Stage | Team Member & USN | Engineering Role | Core Responsibilities & Work Done | Primary Deliverables | Verification Status |
|:---:|:---|:---|:---|:---|:---:|
| **Stage 1 & Review** | **Konduru Nanda Kishore Raju** (Nandu)<br/>`AU25UG-028` | **Team Lead & System Architect**<br/>*(Requirements + Architecture)* | • Elicited functional specifications (FR-01 to FR-11)<br/>• Formulated domain assumptions & entity boundaries<br/>• Architected modular repository layout<br/>• Conducted peer review code audits & unified docs | [`README.md`](README.md)<br/>[`docs/requirements.md`](docs/requirements.md) | ✅ Verified |
| **Stage 2 & 3** | **Melvin Jacob**<br/>`AU25UG-034` | **Conceptual Modeler**<br/>*(ER Diagram Lead)* | • Conceptual data modeling & Chen notation diagramming<br/>• Entity identification, attributes, and primary keys<br/>• Cardinality (1:1, 1:N, M:N) & participation constraints<br/>• Authoring vector draw.io files and conceptual report | [`diagrams/ER_Diagram.png`](diagrams/ER_Diagram.png)<br/>[`diagrams/ER_Diagram_README.md`](diagrams/ER_Diagram_README.md)<br/>[`diagrams/UniTrack - ER Diagram.drawio`](diagrams/UniTrack%20-%20ER%20Diagram.drawio) | ✅ Verified |
| **Stage 4** | **K. Jyoshna**<br/>`AU25UG-026` | **Logical Designer**<br/>*(DDL Schema Engineer)* | • ER-to-relational schema mapping for all 11 tables<br/>• Engineered circular FK resolution (Department ↔ Faculty)<br/>• Authoring complete DDL (`CREATE TABLE`, PK, FK, CHECK)<br/>• Authoring logical design rationale report | [`schema/create_tables.sql`](schema/create_tables.sql)<br/>[`schema/UniTrack_Logical_Design_Design_Rationale.md`](schema/UniTrack_Logical_Design_Design_Rationale.md) | ✅ Verified |
| **Stage 5** | **Monica Irala**<br/>`AU25UG-037` | **Theory & Normalisation Lead**<br/>*(Mathematical Proofs)* | • Formal minimal cover functional dependency analysis<br/>• Mathematical proofs for 1NF, 2NF, and 3NF compliance<br/>• Lossless join decomposition and anomaly prevention<br/>• Executable SQL normalisation verification script | [`docs/normalization.md`](docs/normalization.md)<br/>[`docs/normalisation.sql`](docs/normalisation.sql) | ✅ Verified |
| **Stage 4 & 5** | **Naidile D**<br/>`AU25UG-038` | **Database QA & DML Specialist**<br/>*(Sample Data & Testing)* | • Realistic university dataset synthesis (~1,000 rows)<br/>• Multi-semester data distribution (Fall 24, Spring 25, Fall 25)<br/>• Strict topological insertion order preserving FK integrity<br/>• Constraint verification and database population testing | [`data/insert_data.sql`](data/insert_data.sql) | ✅ Verified |
| **Stage 6 & Git** | **Padmaraju Poojitha**<br/>`AU25UG-043` | **Analytics & Repository Lead**<br/>*(SQL Queries + Git)* | • Authored 10 complex analytical queries (Q1–Q10)<br/>• Implemented multi-table JOINs, subqueries, GROUP BY, HAVING<br/>• Captured verified MySQL Workbench screenshot results<br/>• Formatted Word deliverable & managed GitHub repository | [`queries/queries.sql`](queries/queries.sql)<br/>[`queries/README.md`](queries/README.md)<br/>[`queries/SQL Queries and Results.docx`](queries/SQL%20Queries%20and%20Results.docx) | ✅ Verified |

---

## 🔍 Detailed Individual Contribution Profiles

### 1. Konduru Nanda Kishore Raju (`AU25UG-028`) — Team Lead & System Architect
* **Primary Scope:** Stage 1 (Requirements Analysis) & Project Governance
* **Key Deliverables:** [`README.md`](README.md), [`docs/requirements.md`](docs/requirements.md)
* **Detailed Work Accomplished:**
  - Led the overall architectural direction, milestone planning, and repository scaffolding.
  - Defined the university operational problem statement and mapped out 11 functional requirements (FR-01 to FR-11) across Academic, Faculty, Student, Scheduling, and Evaluation modules.
  - Drafted core business assumptions including single-HOD leadership, degree program affiliation rules, and grading policies.
  - Coordinated peer reviews across each stage to ensure consistency between conceptual models, DDL scripts, sample data, and query scripts.

### 2. Melvin Jacob (`AU25UG-034`) — Conceptual Modeler (ER Design Lead)
* **Primary Scope:** Stage 2 & Stage 3 (Conceptual Modeling & ER Analysis)
* **Key Deliverables:** [`diagrams/ER_Diagram.png`](diagrams/ER_Diagram.png), [`diagrams/ER_Diagram_README.md`](diagrams/ER_Diagram_README.md), [`diagrams/UniTrack - ER Diagram.drawio`](diagrams/UniTrack%20-%20ER%20Diagram.drawio)
* **Detailed Work Accomplished:**
  - Formulated the conceptual Entity-Relationship (ER) model representing all academic operations.
  - Designed the complete Chen notation ER diagram including entities, attributes, primary key identifiers, and relationship diamonds.
  - Defined structural cardinality ratios (1:1, 1:N, M:N) and structural participation constraints (total vs. partial participation).
  - Maintained vector source files (`.drawio`) for visual updates and high-resolution documentation exports.

### 3. K. Jyoshna (`AU25UG-026`) — Logical Designer & DDL Engineer
* **Primary Scope:** Stage 4 (Logical Design, Relational Schema & DDL Implementation)
* **Key Deliverables:** [`schema/create_tables.sql`](schema/create_tables.sql), [`schema/UniTrack_Logical_Design_Design_Rationale.md`](schema/UniTrack_Logical_Design_Design_Rationale.md)
* **Detailed Work Accomplished:**
  - Mapped conceptual ER components into 11 distinct relational tables conforming to 3NF.
  - Solved the circular foreign key dependency between `DEPARTMENT(hod_faculty_id)` and `FACULTY(department_id)` using clean multi-stage DDL execution and `ALTER TABLE` constraints without disabling foreign key checks.
  - Structured all 14 foreign keys with deterministic referential actions (`ON UPDATE CASCADE`, `ON DELETE RESTRICT`, `ON DELETE SET NULL`, `ON DELETE CASCADE`).
  - Implemented surrogate integer keys, default values (`DEFAULT 'In Progress'`, `DEFAULT CURRENT_TIMESTAMP`), and check constraints (`CHECK (credits > 0)`).

### 4. Monica Irala (`AU25UG-037`) — Theory & Normalisation Lead
* **Primary Scope:** Stage 5 (Normalization Theory & Relational Constraints)
* **Key Deliverables:** [`docs/normalization.md`](docs/normalization.md), [`docs/normalisation.sql`](docs/normalisation.sql)
* **Detailed Work Accomplished:**
  - Extracted the minimal cover of functional dependencies across all 11 relations.
  - Produced rigorous mathematical proofs demonstrating compliance with First (1NF), Second (2NF), and Third Normal Form (3NF).
  - Validated lossless join decomposition and dependency preservation.
  - Authored an executable SQL test suite (`normalisation.sql`) executing negative and positive tests verifying relational constraints and dependency integrity.

### 5. Naidile D (`AU25UG-038`) — Database QA & DML Specialist
* **Primary Scope:** Stage 4 & 5 (Sample Data Population, DML Synthesis & QA)
* **Key Deliverables:** [`data/insert_data.sql`](data/insert_data.sql)
* **Detailed Work Accomplished:**
  - Synthesized a comprehensive, realistic university sample dataset containing **~1,000 verified rows**.
  - Structured sample data across three chronological semesters: Fall 2024 (historical completed), Spring 2025 (historical completed), and Fall 2025 (active term with 'In Progress' grades).
  - Organized SQL insertion statements in strict topological dependency order (Departments → Programs → Classrooms → Faculty → Courses → Students → Offerings → Enrollments → Attendance → Assignments → Submissions).
  - Verified zero foreign key constraint violations and zero duplicate key conflicts during fresh database hydration.

### 6. Padmaraju Poojitha (`AU25UG-043`) — Analytics & Repository Lead
* **Primary Scope:** Stage 6 (Business Analytics Queries, Workbench Testing & Git Management)
* **Key Deliverables:** [`queries/queries.sql`](queries/queries.sql), [`queries/README.md`](queries/README.md), [`queries/SQL Queries and Results.docx`](queries/SQL%20Queries%20and%20Results.docx)
* **Detailed Work Accomplished:**
  - Authored 10 production-tested analytical SQL queries (Q1–Q10) answering critical university administration questions.
  - Utilized advanced relational operations including `JOIN` (INNER, LEFT OUTER), `GROUP BY`, `HAVING`, aggregations (`COUNT`, `AVG`, `SUM`), and `CASE` conditional transformations.
  - Executed queries on MySQL Workbench, documented execution times, and captured high-resolution verification screenshots (`q1_output.png` through `q10_output.png`).
  - Compiled the final formal college submission report in Microsoft Word format (`.docx`) and coordinated GitHub repository releases.

---

## 📋 Peer Review & Verification Sign-Off

All components were cross-verified through peer review checkpoints prior to final project submission:

| Review Checkpoint | Verifier | Scope Verified | Outcome |
|---|---|---|:---:|
| **DDL Schema vs. ER Model** | Melvin Jacob & K. Jyoshna | All 11 tables map 1-to-1 with ER entities and relationships | ✅ Approved |
| **Normalisation vs. DDL** | Monica Irala & K. Jyoshna | Schema strictly meets 3NF with zero transitive dependencies | ✅ Approved |
| **DML Records vs. Constraints** | Naidile D & Nanda Kishore Raju | 1,000 records execute cleanly without foreign key check bypasses | ✅ Approved |
| **Queries vs. Schema Data** | Padmaraju Poojitha & Naidile D | All 10 queries return valid, non-empty, mathematically sound results | ✅ Approved |
| **Documentation & Packaging** | Nanda Kishore Raju & Team 4 | Full repository consistency, zero broken links, academic standards | ✅ Approved |

---

*This document confirms the individual and collective work done by Team 4 for the DBMS Course Evaluation.*
