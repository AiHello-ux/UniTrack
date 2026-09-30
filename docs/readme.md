# UniTrack — Technical Documentation Index

Welcome to the technical reports directory for **UniTrack (Team 4)**. Each phase of the system lifecycle is documented according to the evaluation guidelines:

## 📑 Documentation Roster

| Document | Lead Author & USN | Evaluation Stage | Core Scope & Contents |
|:---|:---|:---:|:---|
| [`requirements.md`](requirements.md) | **Konduru Nanda Kishore Raju** (`AU25UG-028`) | **Stage 1** | System scope, functional requirements (FR1–FR12), assumptions, entities, and final review audit. |
| [`../diagrams/ER_Diagram_README.md`](../diagrams/ER_Diagram_README.md) | **Melvin Jacob** (`AU25UG-034`) | **Stage 3 & 4** | Conceptual Chen ER diagram, entities, attributes, cardinality, participation constraints, and relational schema architecture. |
| [`design_rationale.md`](design_rationale.md) | **K. Jyoshna** (`AU25UG-026`) | **Stage 4** | ER-to-relational schema mapping, circular dependency resolution, surrogate keys, default constraints, and DDL rationale. |
| [`normalization.md`](normalization.md) | **Monica Irala** (`AU25UG-037`) | **Stage 5** | Formal functional dependencies, 1NF/2NF/3NF proofs, lossless decomposition, and anomaly elimination. |
| [`normalisation.sql`](normalisation.sql) | **Monica Irala** (`AU25UG-037`) | **Stage 5** | SQL scripts verifying functional dependencies and Boyce-Codd / 3NF properties. |
| [`../data/insert_data.sql`](../data/insert_data.sql) | **Naidile D** (`AU25UG-038`) | **Stage 4 & 5** | ~1,000 verified sample records across 3 academic semesters, topological ordering. |
| [`../queries/README.md`](../queries/README.md) & [`../queries/queries.sql`](../queries/queries.sql) | **Padmaraju Poojitha** (`AU25UG-043`) | **Stage 6** | Analytical queries Q1–Q10 covering GROUP BY, HAVING, multi-table JOINs, nested subqueries, with execution screenshots. |

---

## Normalization and Constraints Summary — Monica Irala (`AU25UG-037`)

### My Role
My role in the UniTrack DBMS project is **Normalization and Constraints** (Stage 5 Lead).

### Work Done & Responsibilities
- Identifying formal functional dependencies across all 11 relations.
- Rigorous analysis and mathematical proofs for **1NF, 2NF, and 3NF**.
- Checking and reducing data redundancy through lossless decomposition.
- Specifying integrity constraints: `PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`, `CHECK`, and `DEFAULT`.
- Authoring the SQL normalization verification test suite (`normalisation.sql`).

*For the complete detailed report, please consult [`normalization.md`](normalization.md).*
