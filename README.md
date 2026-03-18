<div align="center">

# ✈️ Aviation Data Engineering Journey

### From Zero to Hireable Aviation Data Engineer — 6 Months, 180 Days

[![Progress](https://img.shields.io/badge/Progress-Day%200%20of%20180-lightgrey?style=for-the-badge)](#daily-log)
[![Status](https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge)](#)
[![Focus](https://img.shields.io/badge/Focus-Aviation%20Data%20Engineering-blue?style=for-the-badge)](#)

---

> *"In aviation, the person who controls the data pipeline controls the entire system."*

**I am building a public, documented, 6-month journey into Aviation Data Engineering —
combining production-level data skills with deep aviation domain knowledge.**

Every day: I learn, I build, I push, I document.

[ Projects](#-projects) • [ Daily Log](#-daily-log) • [🛠 Stack](#-tech-stack) • [ Progress](#-progress-tracker) • [ Goal](#-end-goal)

</div>

---

##  End Goal

After 6 months I will be positioned as an **Aviation Data Engineer** — a specialist who can:

- Build scalable data pipelines for flight operations, airport systems, and cargo logistics
- Design and implement real-time streaming systems for live flight tracking
- Architect cloud-native data platforms used by modern airlines
- Bridge the gap between raw aviation data and AI-ready systems

**Target roles:** Data Engineer at airlines, airports, cargo companies, and aviation tech firms.

---

## 🗓 Roadmap Overview

| Phase | Months | Focus | Milestone Project |
|-------|--------|-------|-------------------|
| **Phase 1** | Month 1–2 | SQL + Python + Data Modeling | Flight Data Warehouse |
| **Phase 2** | Month 3 | ETL Pipelines + Apache Airflow | Automated Flight Delay ETL |
| **Phase 3** | Month 4 | Big Data — Kafka + Spark | Real-Time Flight Tracker |
| **Phase 4** | Month 5 | Cloud Engineering (AWS/GCP) | Cloud Aviation Data Platform |
| **Phase 5** | Month 6 | Advanced Systems + Portfolio | Smart Airport Operations |

---

##  Projects

> Five production-grade aviation systems built over 6 months.
> Each project lives in its own repository — click to explore.

###  Core Projects

| # | Repository | Description | Stack | Status |
|---|-----------|-------------|-------|--------|
| 1 | [`flight-data-warehouse`](./projects/flight-data-warehouse/) | Star schema warehouse for airline analytics — delay analysis, route profitability, on-time performance | SQL · PostgreSQL · dbt · Python | 🔲 Not Started |
| 2 | [`aviation-etl-pipeline`](./projects/aviation-etl-pipeline/) | Automated daily ETL pipeline for flight delay data with Airflow orchestration | Python · Airflow · PostgreSQL · Docker | 🔲 Not Started |
| 3 | [`real-time-flight-tracking`](./projects/real-time-flight-tracking/) | Live ADS-B flight position stream with delay detection and route deviation alerts | Kafka · PySpark · Redis · Python | 🔲 Not Started |
| 4 | [`cloud-aviation-platform`](./projects/cloud-aviation-platform/) | Cloud-native data lakehouse — ingestion to BigQuery via Lambda, S3, and dbt | AWS S3 · Lambda · BigQuery · dbt · Airflow | 🔲 Not Started |
| 5 | [`airport-operations-system`](./projects/airport-operations-system/) | Smart airport congestion analytics — peak hour prediction, gate utilization, passenger flow | Spark · Airflow · FastAPI · PostgreSQL | 🔲 Not Started |

###  Bonus Projects (Months 5–6)

| # | Repository | Description | Stack | Status |
|---|-----------|-------------|-------|--------|
| 6 | [`predictive-maintenance-pipeline`](./projects/predictive-maintenance-pipeline/) | Aircraft sensor data pipeline with anomaly detection and feature store | Kafka · Spark · Feast · Python | 🔲 Not Started |
| 7 | [`route-optimization-data-system`](./projects/route-optimization-data-system/) | Multi-source pipeline combining weather, fuel prices, and delay history for route scoring | Python · Airflow · OpenMeteo API · dbt | 🔲 Not Started |

---

## 🛠 Tech Stack

```
┌─────────────────────────────────────────────────────────────────┐
│                     AVIATION DATA STACK                         │
├────────────────────┬────────────────────────────────────────────┤
│  LANGUAGES         │  Python · SQL                              │
│  ORCHESTRATION     │  Apache Airflow · cron                     │
│  BATCH PROCESSING  │  Apache Spark (PySpark)                    │
│  STREAMING         │  Apache Kafka · Spark Structured Streaming │
│  DATABASES         │  PostgreSQL · Redis · DynamoDB             │
│  WAREHOUSING       │  BigQuery · Redshift · Snowflake           │
│  TRANSFORMATION    │  dbt                                       │
│  CLOUD             │  AWS (S3, Lambda, IAM) · GCP               │
│  DATA QUALITY      │  Great Expectations · custom SQL checks    │
│  CONTAINERS        │  Docker · Docker Compose                   │
│  VERSION CONTROL   │  Git · GitHub                              │
│  APIs              │  FastAPI · AviationStack · OpenSky         │
└────────────────────┴────────────────────────────────────────────┘
```

---

##  Progress Tracker

> Updated daily. Each  = one day completed.

### Month 1 — SQL & Python Foundations (Days 1–14)

| Week | Day | Topic | Project | Done |
|------|-----|-------|---------|------|
| **Week 1** | Day 1 | SELECT, WHERE, ORDER BY | First aviation query set | ☐ |
| | Day 2 | GROUP BY, COUNT, AVG | Airline performance summary | ☐ |
| | Day 3 | SQL Joins | Full route explorer | ☐ |
| | Day 4 | Subqueries & CTEs | Top 5 delayed routes | ☐ |
| | Day 5 | Window functions | Airline delay ranking | ☐ |
| | Day 6 | Complex queries + EXPLAIN | Airline performance report | ☐ |
| | Day 7 | Review + GitHub push | `flight-sql-foundations` repo | ☐ |
| **Week 2** | Day 8 | Pandas basics | Flight dataset explorer | ☐ |
| | Day 9 | Data transformation | Delay column engineering script | ☐ |
| | Day 10 | Aviation APIs | Live flight data fetcher | ☐ |
| | Day 11 | File handling — CSV, JSON, Parquet | Multi-format data converter | ☐ |
| | Day 12 | Basic ETL pipeline design | Flight data ETL script v1 | ☐ |
| | Day 13 | Python + SQL combined | Flight data processing pipeline | ☐ |
| | Day 14 | Review + portfolio docs | `aviation-python-pipelines` repo | ☐ |

### Month 2 — Data Modeling & Warehouse Design (Days 15–28)

| Week | Day | Topic | Project | Done |
|------|-----|-------|---------|------|
| **Week 3** | Days 15–16 | Star schema design | Aviation dimensional model | ☐ |
| | Days 17–18 | Loading data into warehouse | Warehouse data load script | ☐ |
| | Days 19–20 | Analytics queries | Flight data warehouse — full query suite | ☐ |
| | Day 21 | Validation & documentation | Warehouse quality report | ☐ |
| **Week 4** | Days 22–24 | Query optimization & indexing | Warehouse performance tuner | ☐ |
| | Days 25–26 | Data quality checks | Automated data quality suite | ☐ |
| | Days 27–28 | dbt + GitHub polish | `flight-data-warehouse` repo (**Project 1**) | ☐ |

### Month 3 — ETL & Apache Airflow (Days 29–42)

| Week | Day | Topic | Project | Done |
|------|-----|-------|---------|------|
| **Week 5** | Days 29–31 | ETL design patterns | Flight delay ETL pipeline v2 | ☐ |
| | Days 32–35 | Scheduling & automation | Automated daily delay report | ☐ |
| **Week 6** | Days 36–37 | Airflow setup & concepts | Hello aviation DAG | ☐ |
| | Days 38–40 | Full aviation ETL DAG | Daily flight ETL DAG (**Project 2**) | ☐ |
| | Days 41–42 | Advanced Airflow patterns | Multi-airline pipeline DAG | ☐ |

### Month 4 — Big Data: Kafka & Spark (Days 43–56)

| Week | Day | Topic | Project | Done |
|------|-----|-------|---------|------|
| **Week 7** | Days 43–45 | Kafka core + setup | Flight position stream simulator | ☐ |
| | Days 46–49 | Multi-topic flight stream | Real-time flight operations system | ☐ |
| **Week 8** | Days 50–52 | Spark fundamentals | Historical flight data batch processor | ☐ |
| | Days 53–56 | Spark Streaming | Real-time delay detection pipeline (**Project 3**) | ☐ |

### Month 5 — Cloud Engineering (Days 57–70)

| Week | Day | Topic | Project | Done |
|------|-----|-------|---------|------|
| **Week 9** | Days 57–59 | Cloud storage — S3/GCS | Aviation data lake on S3 | ☐ |
| | Days 60–63 | BigQuery / Redshift | Aviation analytics on BigQuery | ☐ |
| **Week 10** | Days 64–66 | Lambda / Cloud Functions | Serverless flight data processor | ☐ |
| | Days 67–70 | Full cloud pipeline | Cloud aviation data platform (**Project 4**) | ☐ |

### Month 6 — Advanced Aviation Systems (Days 71–100)

| Week | Day | Topic | Project | Done |
|------|-----|-------|---------|------|
| **Project A** | Days 71–75 | Airport data ingestion | Airport data ingestion system | ☐ |
| | Days 76–80 | Congestion analytics | Airport congestion analytics engine | ☐ |
| | Days 81–84 | Output layer + API | Smart airport operations platform (**Project 5**) | ☐ |
| **Project B** | Days 85–88 | Cargo Kafka stream | Cargo tracking event stream | ☐ |
| | Days 89–92 | Cargo pipeline | Cargo logistics pipeline (**Bonus 1**) | ☐ |
| **Project C** | Days 93–96 | ADS-B Spark stream | Live flight tracking pipeline | ☐ |
| | Days 97–100 | Portfolio launch | Complete portfolio push (**Bonus 2**) | ☐ |

---

##  Daily Log

> One entry per day. Linked to commits where available.

<details>
<summary><strong>Month 1 — SQL & Python (Days 1–14)</strong></summary>

| Day | Date | What I Learned | What I Built | Link |
|-----|------|----------------|--------------|------|
| 1 | — | — | — | — |
| 2 | — | — | — | — |
| 3 | — | — | — | — |
| 4 | — | — | — | — |
| 5 | — | — | — | — |
| 6 | — | — | — | — |
| 7 | — | — | — | — |
| 8 | — | — | — | — |
| 9 | — | — | — | — |
| 10 | — | — | — | — |
| 11 | — | — | — | — |
| 12 | — | — | — | — |
| 13 | — | — | — | — |
| 14 | — | — | — | — |

</details>

<details>
<summary><strong>Month 2 — Data Modeling & Warehouse (Days 15–28)</strong></summary>

| Day | Date | What I Learned | What I Built | Link |
|-----|------|----------------|--------------|------|
| 15 | — | — | — | — |
| 16 | — | — | — | — |
| 17 | — | — | — | — |
| 18 | — | — | — | — |
| 19 | — | — | — | — |
| 20 | — | — | — | — |
| 21 | — | — | — | — |
| 22 | — | — | — | — |
| 23 | — | — | — | — |
| 24 | — | — | — | — |
| 25 | — | — | — | — |
| 26 | — | — | — | — |
| 27 | — | — | — | — |
| 28 | — | — | — | — |

</details>

<details>
<summary><strong>Month 3 — ETL & Airflow (Days 29–42)</strong></summary>

| Day | Date | What I Learned | What I Built | Link |
|-----|------|----------------|--------------|------|
| 29–31 | — | — | — | — |
| 32–35 | — | — | — | — |
| 36–37 | — | — | — | — |
| 38–40 | — | — | — | — |
| 41–42 | — | — | — | — |

</details>

<details>
<summary><strong>Month 4 — Kafka & Spark (Days 43–56)</strong></summary>

| Day | Date | What I Learned | What I Built | Link |
|-----|------|----------------|--------------|------|
| 43–45 | — | — | — | — |
| 46–49 | — | — | — | — |
| 50–52 | — | — | — | — |
| 53–56 | — | — | — | — |

</details>

<details>
<summary><strong>Month 5 — Cloud (Days 57–70)</strong></summary>

| Day | Date | What I Learned | What I Built | Link |
|-----|------|----------------|--------------|------|
| 57–59 | — | — | — | — |
| 60–63 | — | — | — | — |
| 64–66 | — | — | — | — |
| 67–70 | — | — | — | — |

</details>

<details>
<summary><strong>Month 6 — Advanced Systems (Days 71–100)</strong></summary>

| Day | Date | What I Learned | What I Built | Link |
|-----|------|----------------|--------------|------|
| 71–75 | — | — | — | — |
| 76–80 | — | — | — | — |
| 81–84 | — | — | — | — |
| 85–88 | — | — | — | — |
| 89–92 | — | — | — | — |
| 93–96 | — | — | — | — |
| 97–100 | — | — | — | — |

</details>

---

## 🗂 Repository Structure

```
aviation-data-engineering-journey/
│
├── README.md                          ← You are here
├── ROADMAP.md                         ← Full 6-month plan with all 100 days
│
├── projects/                          ← One folder per major project
│   ├── flight-data-warehouse/
│   ├── aviation-etl-pipeline/
│   ├── real-time-flight-tracking/
│   ├── cloud-aviation-platform/
│   ├── airport-operations-system/
│   ├── predictive-maintenance-pipeline/
│   └── route-optimization-data-system/
│
├── monthly-notes/                     ← Reflections and lessons per month
│   ├── month-01-sql-python.md
│   ├── month-02-warehouse.md
│   ├── month-03-airflow.md
│   ├── month-04-kafka-spark.md
│   ├── month-05-cloud.md
│   └── month-06-advanced.md
│
├── resources/                         ← Learning materials and references
│   ├── datasets/                      ← Sample aviation datasets used
│   ├── architecture-diagrams/         ← System diagrams for all projects
│   └── references.md                  ← Books, docs, courses used
│
└── .github/
    └── ISSUE_TEMPLATE/
        └── daily-log.md               ← Template for daily GitHub Issues log
```

---

##  Each Project Repository Structure

Every project under `projects/` follows this consistent structure:

```
project-name/
│
├── README.md                  ← Problem, architecture, setup, results
├── architecture/
│   ├── system-diagram.png     ← High-level architecture diagram
│   └── data-flow.png          ← Data lineage / flow diagram
│
├── data/
│   ├── sample/                ← Small sample input data
│   └── schema/                ← Table schemas and data dictionary
│
├── src/
│   ├── ingestion/             ← Data extraction scripts
│   ├── transformation/        ← Cleaning and processing logic
│   ├── loading/               ← Database write scripts
│   └── utils/                 ← Shared helpers
│
├── dags/                      ← Airflow DAG files (if applicable)
│
├── sql/
│   ├── ddl/                   ← CREATE TABLE statements
│   └── queries/               ← Analytical queries
│
├── tests/
│   ├── unit/                  ← Unit tests for transformation logic
│   └── data_quality/          ← Data validation checks
│
├── docker-compose.yml         ← One-command local environment
├── requirements.txt           ← Python dependencies (pinned versions)
├── Makefile                   ← Common commands: setup, run, test, clean
└── .env.example               ← Environment variable template
```

---

##  Daily Build-in-Public Template

I post daily updates on [LinkedIn](#) and [X / Twitter](#). Template:

```
Day [X/180] — Aviation Data Engineer Journey ✈️

Today I worked on:
→ [Main concept learned]
→ [Tool / technology used]

Built:
[What I built in 1 clear line]

Key Win:
[What I now understand / solved]

Challenge:
[Something that was hard]

Next:
[Tomorrow's focus]

#DataEngineering #Aviation #BuildInPublic #Python #SQL
```

---

## Learning Resources

### Core References

| Resource | Type | Used In |
|----------|------|---------|
| [Fundamentals of Data Engineering — Reis & Housley](https://www.oreilly.com/library/view/fundamentals-of-data/9781098108298/) | Book | All phases |
| [PostgreSQL Documentation](https://www.postgresql.org/docs/) | Docs | Month 1–2 |
| [Apache Airflow Documentation](https://airflow.apache.org/docs/) | Docs | Month 3 |
| [Apache Kafka Documentation](https://kafka.apache.org/documentation/) | Docs | Month 4 |
| [PySpark Documentation](https://spark.apache.org/docs/latest/api/python/) | Docs | Month 4 |
| [dbt Documentation](https://docs.getdbt.com/) | Docs | Month 2, 5 |
| [AWS Documentation](https://docs.aws.amazon.com/) | Docs | Month 5 |
| [OpenSky Network API](https://opensky-network.org/apidoc/) | API | Month 1, 4 |
| [AviationStack API](https://aviationstack.com/documentation) | API | Month 1, 3 |
| [US DOT BTS Flight Data](https://www.transtats.bts.gov/) | Dataset | All phases |

---

## Why I'm Doing This in Public

Aviation has a critical data problem:

- **41% of airlines** still run on legacy systems that cannot scale
- **62%+ of airlines** need AI for predictive maintenance — but AI needs clean pipelines first
- There is a **global shortage** of engineers who combine data skills with aviation knowledge

Most data engineers have no aviation context. Most aviation professionals have no data engineering skills. I am building both — and documenting every step so others can follow the same path.

---

##  Connect

If you are hiring, collaborating, or following a similar journey:

- [**LinkedIn:**](https://www.linkedin.com/in/john-otienoh/)
- [**X**](https://x.com/justotienoh)
- [**Email:**](otienohjohncharles@gmail.com)

---

<div align="center">

**Started:** [Start Date] &nbsp;|&nbsp; **Target Completion:** [+6 Months] &nbsp;|&nbsp; **Current Day:** 0 / 180

*Updated daily. Every commit is a day of work.*

</div>