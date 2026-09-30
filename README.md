<div align="center">

# 🎓 UniTrack — Team Contributions & System Engineering Matrix
### *Enterprise-Grade Relational Database Management System for Higher Education Operations*

[![MySQL 8.0+](https://img.shields.io/badge/MySQL-8.0%2B-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Normalisation 3NF](https://img.shields.io/badge/Normalisation-3NF%20Verified-2ea44f?style=for-the-badge&logo=databricks&logoColor=white)](docs/normalization.md)
[![Relational Tables](https://img.shields.io/badge/Schema-11%20Tables-blueviolet?style=for-the-badge&logo=diagram-next&logoColor=white)](#-project-architecture--domain-modules)
[![Sample Records](https://img.shields.io/badge/Records-~1000%20Verified-orange?style=for-the-badge&logo=database&logoColor=white)](#-system-scale--engineering-metrics)
[![Team 4](https://img.shields.io/badge/Team-4%20(6%20Engineers)-blue?style=for-the-badge)](#-master-contributions--role-matrix)
[![Verification Status](https://img.shields.io/badge/Status-100%25%20Verified-success?style=for-the-badge)](#-peer-review--verification-sign-off)

<br/>

<p align="center">
  <a href="#-project-overview-what-is-unitrack"><strong>📖 Project Overview</strong></a> •
  <a href="#-project-architecture--domain-modules"><strong>Domain Architecture</strong></a> •
  <a href="#-system-scale--engineering-metrics"><strong>System Metrics</strong></a> •
  <a href="#-master-contributions--role-matrix"><strong>Role Matrix</strong></a> •
  <a href="#-detailed-individual-contribution-profiles"><strong>Individual Profiles</strong></a> •
  <a href="#-peer-review--verification-sign-off"><strong>Sign-Off Matrix</strong></a>
</p>

---

</div>

> [!NOTE]
> **Course:** Database Management Systems (DBMS) — Academic Project Submission  
> **Group:** Team 4 &nbsp;•&nbsp; **Target RDBMS:** MySQL 8.0+ (InnoDB Engine)  
> **Normalisation Level:** Third Normal Form (3NF) &nbsp;•&nbsp; **Total Verified Records:** ~1,000 across 3 Semesters  
> **Team Lead:** Konduru Nanda Kishore Raju (`AU25UG-028`) &nbsp;•&nbsp; **Primary Repository:** [`README.md`](README.md)

---

## 📖 Project Overview: What is UniTrack?

### 🎯 The Real-World Challenge
Modern colleges and universities manage vast, interconnected streams of operational data daily. In traditional educational setups, institutions suffer from severe operational friction:
1. **Data Silos & Redundancy:** Student, faculty, and course records isolated in disconnected department spreadsheets, causing discrepancies in contact info and credits.
2. **Orphaned Enrollments:** Inconsistent registration files leaving course enrollments disconnected from enrolled students or semester offerings.
3. **Grade & Attendance Desynchronization:** Absence of unified referential constraints linking classroom attendance directly with continuous assignment evaluations and final letter grades.
4. **Scheduling & Resource Conflicts:** Unmonitored faculty teaching loads and classroom capacity overflows without enforceable relational boundaries.

### 💡 The UniTrack Relational Solution
**UniTrack** is a centralized, enterprise-grade relational database management system (RDBMS) engineered to serve as the **single source of truth** for all higher-education academic workflows. 

Engineered strictly on **MySQL 8.0+ with the InnoDB storage engine**, UniTrack models the complete academic lifecycle—from university departments, degree programs, and faculty appointments, to student course offerings, real-time lecture attendance logging, assignment submissions, and semester gradebook computations.

```
┌────────────────────────────────────────────────────────────────────────┐
│                        UNITRACK DATABASE ECOSYSTEM                     │
│               Single Source of Truth for Academic Operations           │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
    ┌───────────────────┬───────────┴───────────┬───────────────────┐
    ▼                   ▼                       ▼                   ▼
🏛️ ACADEMIC HIERARCHY  👩‍🏫 FACULTY & ROOMS      🎓 STUDENT JOURNEY  📊 EVALUATION ENGINE
 • DEPARTMENT            • FACULTY               • STUDENT           • ATTENDANCE
 • PROGRAM               • CLASSROOM             • COURSE_OFFERING   • ASSIGNMENT
 • COURSE                • (HOD Management)      • ENROLLMENT        • SUBMISSION
```

---

## 🏛️ Project Architecture & Domain Modules

UniTrack decomposes all university operations into **11 normalized relations (tables)** structured across **4 cohesive functional modules**:

| Module | Core Relational Tables | Operational Responsibilities & Scope |
|:---|:---|:---|
| **1. Academic Foundation** | `DEPARTMENT`<br/>`PROGRAM`<br/>`COURSE` | Maintains departments, degree offerings (B.Tech, M.Tech, MBA, Ph.D), degree durations, course codes, and strict academic credit allocations (`credits > 0`). |
| **2. Faculty & Facilities** | `FACULTY`<br/>`CLASSROOM` | Stores faculty directories, unique institutional emails, department affiliations, and physical classrooms with enforced positive seating capacities (`capacity > 0`). Resolves the mutual circular FK with `DEPARTMENT(hod_faculty_id)`. |
| **3. Student & Timetables** | `STUDENT`<br/>`COURSE_OFFERING`<br/>`ENROLLMENT` | Tracks student admissions (USN), semester terms (Fall/Spring/Summer), assigned instructors, room scheduling, and unique course enrollments (`UNIQUE (student_id, offering_id)`). |
| **4. Continuous Evaluation** | `ATTENDANCE`<br/>`ASSIGNMENT`<br/>`SUBMISSION` | Session-by-session attendance logging (`Present`/`Absent`), assignment deadlines, submission timestamps, and student grade calculation against `max_marks`. |

---

## ⚡ System Scale & Engineering Metrics

<div align="center">

| Metric | Measured Value | Implementation Guarantee |
|:---|:---:|:---|
| **Relational Tables** | **11 Entities** | Complete academic lifecycle coverage with zero redundant relations |
| **Normalisation Standard** | **Third Normal Form (3NF)** | Eliminates update, insert, and deletion anomalies via minimal functional covers |
| **Referential Foreign Keys** | **14 Explicit FKs** | Structured with `ON UPDATE CASCADE`, `ON DELETE RESTRICT`, `CASCADE`, `SET NULL` |
| **Circular Dependency Handling** | **Staged DDL / ALTER TABLE** | Resolves `DEPARTMENT.hod_faculty_id` ↔ `FACULTY.department_id` without bypassing FK checks |
| **Verified Sample Records** | **~1,000 Rows** | Distributed across 3 chronological terms (Fall 2024, Spring 2025, Fall 2025) |
| **Analytical Query Suite** | **10 Production Queries** | Workbench-verified SQL analytics with aggregations, JOINs, subqueries, and windowing |

</div>

---

## 🏆 Master Contributions & Role Matrix

The project was executed through an individual stage-ownership model where each engineer assumed end-to-end accountability for a dedicated stage of the database engineering lifecycle:

<table width="100%">
  <tr>
    <td width="50%" valign="top">
      <h3>🏛️ Stage 1: Requirements &amp; Architecture</h3>
      <p>
        <strong>Konduru Nanda Kishore Raju (Nandu)</strong><br/>
        <code>AU25UG-028</code> &nbsp;•&nbsp; <em>Team Lead &amp; System Architect</em>
      </p>
      <ul>
        <li>Authored 11 functional requirements (FR-01 to FR-11)</li>
        <li>Established business rules, domain entities &amp; assumptions</li>
        <li>Architected repository layout &amp; master documentation</li>
        <li>Coordinated cross-stage peer review and quality assurance</li>
      </ul>
      <p>📁 <b>Deliverables:</b> <a href="README.md"><code>README.md</code></a> • <a href="docs/requirements.md"><code>requirements.md</code></a></p>
    </td>
    <td width="50%" valign="top">
      <h3>🎨 Stage 2 &amp; 3: Conceptual ER Modeling</h3>
      <p>
        <strong>Melvin Jacob</strong><br/>
        <code>AU25UG-034</code> &nbsp;•&nbsp; <em>Conceptual Modeler (ER Design Lead)</em>
      </p>
      <ul>
        <li>Engineered conceptual Chen notation ER diagram</li>
        <li>Defined cardinalities (1:1, 1:N, M:N) &amp; participation</li>
        <li>Identified weak entities, multi-attribute keys &amp; relationships</li>
        <li>Created vector source diagrams (draw.io) &amp; conceptual report</li>
      </ul>
      <p>📁 <b>Deliverables:</b> <a href="diagrams/ER_Diagram.png"><code>ER_Diagram.png</code></a> • <a href="diagrams/ER_Diagram_README.md"><code>ER_Diagram_README.md</code></a></p>
    </td>
  </tr>
  <tr>
    <td width="50%" valign="top">
      <h3>🗄️ Stage 4: Logical Design &amp; Relational DDL</h3>
      <p>
        <strong>K. Jyoshna</strong><br/>
        <code>AU25UG-026</code> &nbsp;•&nbsp; <em>Logical Designer &amp; DDL Engineer</em>
      </p>
      <ul>
        <li>Mapped conceptual model to 11 normalized tables (3NF)</li>
        <li>Resolved Department ↔ Faculty circular FK dependency</li>
        <li>Defined primary/foreign keys, CHECK constraints &amp; defaults</li>
        <li>Authored complete database schema creation scripts</li>
      </ul>
      <p>📁 <b>Deliverables:</b> <a href="schema/create_tables.sql"><code>create_tables.sql</code></a> • <a href="schema/UniTrack_Logical_Design_Design_Rationale.md"><code>Design_Rationale.md</code></a></p>
    </td>
    <td width="50%" valign="top">
      <h3>📐 Stage 5: Normalisation &amp; Relational Theory</h3>
      <p>
        <strong>Monica Irala</strong><br/>
        <code>AU25UG-037</code> &nbsp;•&nbsp; <em>Theory &amp; Normalisation Lead</em>
      </p>
      <ul>
        <li>Derived minimal cover of functional dependencies (FDs)</li>
        <li>Formulated mathematical proofs for 1NF, 2NF, and 3NF</li>
        <li>Validated lossless join decomposition &amp; dependency preservation</li>
        <li>Authored executable SQL normalization test suite</li>
      </ul>
      <p>📁 <b>Deliverables:</b> <a href="docs/normalization.md"><code>normalization.md</code></a> • <a href="docs/normalisation.sql"><code>normalisation.sql</code></a></p>
    </td>
  </tr>
  <tr>
    <td width="50%" valign="top">
      <h3>📊 Stage 4 &amp; 5: Sample Data Synthesis &amp; QA</h3>
      <p>
        <strong>Naidile D</strong><br/>
        <code>AU25UG-038</code> &nbsp;•&nbsp; <em>Database QA &amp; DML Specialist</em>
      </p>
      <ul>
        <li>Synthesized ~1,000 verified rows across 3 sequential semesters</li>
        <li>Engineered topological insertion order preserving FK integrity</li>
        <li>Modeled realistic grade curves, attendance rates &amp; submissions</li>
        <li>Performed database hydration QA &amp; constraint testing</li>
      </ul>
      <p>📁 <b>Deliverables:</b> <a href="data/insert_data.sql"><code>data/insert_data.sql</code></a></p>
    </td>
    <td width="50%" valign="top">
      <h3>🔍 Stage 6 &amp; Git: Analytics &amp; Deployment</h3>
      <p>
        <strong>Padmaraju Poojitha</strong><br/>
        <code>AU25UG-043</code> &nbsp;•&nbsp; <em>Analytics &amp; Repository Lead</em>
      </p>
      <ul>
        <li>Authored 10 verified business analytical queries (Q1–Q10)</li>
        <li>Implemented multi-table JOINs, subqueries, grouping &amp; aggregations</li>
        <li>Captured Workbench execution screenshots &amp; performance stats</li>
        <li>Formatted formal academic submission documentation</li>
      </ul>
      <p>📁 <b>Deliverables:</b> <a href="queries/queries.sql"><code>queries.sql</code></a> • <a href="queries/SQL%20Queries%20and%20Results.docx"><code>SQL Queries &amp; Results.docx</code></a></p>
    </td>
  </tr>
</table>

### 📋 Executive Summary Table

| Stage | Team Member | USN | Engineering Role | Key Deliverables | Status |
|:---:|:---|:---:|:---|:---|:---:|
| **Stage 1 & Review** | **Konduru Nanda Kishore Raju** | `AU25UG-028` | Team Lead & System Architect | [`README.md`](README.md), [`docs/requirements.md`](docs/requirements.md) | ✅ Verified |
| **Stage 2 & 3** | **Melvin Jacob** | `AU25UG-034` | Conceptual Modeler (ER Lead) | [`diagrams/ER_Diagram.png`](diagrams/ER_Diagram.png), [`diagrams/`](diagrams/) | ✅ Verified |
| **Stage 4** | **K. Jyoshna** | `AU25UG-026` | Logical Designer (DDL Engineer) | [`schema/create_tables.sql`](schema/create_tables.sql), [`schema/`](schema/) | ✅ Verified |
| **Stage 5** | **Monica Irala** | `AU25UG-037` | Theory & Normalisation Lead | [`docs/normalization.md`](docs/normalization.md), [`docs/normalisation.sql`](docs/normalisation.sql) | ✅ Verified |
| **Stage 4 & 5** | **Naidile D** | `AU25UG-038` | Database QA & DML Specialist | [`data/insert_data.sql`](data/insert_data.sql) | ✅ Verified |
| **Stage 6 & Git** | **Padmaraju Poojitha** | `AU25UG-043` | Analytics & Repository Lead | [`queries/queries.sql`](queries/queries.sql), [`queries/SQL Queries and Results.docx`](queries/SQL%20Queries%20and%20Results.docx) | ✅ Verified |

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
  - Mapped conceptual ER components into 11 distinct relational tables conforming strictly to 3NF.
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
* **Key Deliverables:** [`queries/queries.sql`](queries/queries.sql), [`queries/SQL Queries and Results.docx`](queries/SQL%20Queries%20and%20Results.docx)
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

<div align="center">

### 🎓 UniTrack Database Management System
**Database Management Systems Course Project • Academic Year 2024–2025**  
*Submitted by Team 4 • Verified on MySQL 8.0+ Community Server*

</div>
