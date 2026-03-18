# ✈️ Aviation Data Engineering Journey — Complete Repository Structure

This document describes the full folder and file structure for the entire 6-month journey.
Use this as your blueprint when creating repositories and organizing your work.

---

## 📦 Top-Level Repository: `aviation-data-engineering-journey`

This is your **main public repository** — the one you link on your LinkedIn and CV.
It is a monorepo that houses all projects and your daily progress log.

```
aviation-data-engineering-journey/
│
├── README.md                              ← Main portfolio README (your public face)
├── ROADMAP.md                             ← Complete 6-month plan, all 100 days
├── LICENSE                                ← MIT License
│
├── projects/                              ← All 7 major aviation systems
│   │
│   ├── 01-flight-data-warehouse/          ← Month 2 capstone
│   │   ├── README.md
│   │   ├── architecture/
│   │   │   ├── system-diagram.png
│   │   │   └── star-schema.png
│   │   ├── data/
│   │   │   ├── sample/
│   │   │   │   ├── flights_sample.csv
│   │   │   │   ├── airports.csv
│   │   │   │   └── airlines.csv
│   │   │   └── schema/
│   │   │       ├── ddl.sql
│   │   │       └── data_dictionary.md
│   │   ├── src/
│   │   │   ├── ingestion/
│   │   │   │   └── extract_flights.py
│   │   │   ├── transformation/
│   │   │   │   ├── clean_delays.py
│   │   │   │   └── build_dimensions.py
│   │   │   ├── loading/
│   │   │   │   └── load_warehouse.py
│   │   │   └── utils/
│   │   │       ├── db.py
│   │   │       └── logger.py
│   │   ├── sql/
│   │   │   ├── ddl/
│   │   │   │   ├── create_staging.sql
│   │   │   │   ├── create_dimensions.sql
│   │   │   │   └── create_fact.sql
│   │   │   └── queries/
│   │   │       ├── delay_analysis.sql
│   │   │       ├── route_performance.sql
│   │   │       └── airline_ranking.sql
│   │   ├── dbt/
│   │   │   ├── models/
│   │   │   │   ├── staging/
│   │   │   │   │   └── stg_flights.sql
│   │   │   │   ├── intermediate/
│   │   │   │   │   └── int_flight_delays.sql
│   │   │   │   └── marts/
│   │   │   │       ├── mart_delay_summary.sql
│   │   │   │       └── mart_route_performance.sql
│   │   │   ├── tests/
│   │   │   │   └── schema.yml
│   │   │   └── dbt_project.yml
│   │   ├── tests/
│   │   │   ├── unit/
│   │   │   │   └── test_transformations.py
│   │   │   └── data_quality/
│   │   │       └── test_warehouse_quality.py
│   │   ├── docker-compose.yml
│   │   ├── requirements.txt
│   │   ├── Makefile
│   │   └── .env.example
│   │
│   ├── 02-aviation-etl-pipeline/           ← Month 3 capstone
│   │   ├── README.md
│   │   ├── architecture/
│   │   │   └── pipeline-dag.png
│   │   ├── dags/
│   │   │   ├── flight_etl_dag.py
│   │   │   └── multi_airline_dag.py
│   │   ├── src/
│   │   │   ├── extract/
│   │   │   │   ├── fetch_api.py
│   │   │   │   └── read_csv.py
│   │   │   ├── transform/
│   │   │   │   ├── clean_delays.py
│   │   │   │   └── standardize_timestamps.py
│   │   │   ├── load/
│   │   │   │   └── to_postgres.py
│   │   │   └── quality/
│   │   │       └── validate.py
│   │   ├── config/
│   │   │   └── pipeline_config.yaml
│   │   ├── tests/
│   │   │   └── test_dag_integrity.py
│   │   ├── docker-compose.yml             ← Includes Airflow + PostgreSQL
│   │   ├── requirements.txt
│   │   ├── Makefile
│   │   └── .env.example
│   │
│   ├── 03-real-time-flight-tracking/       ← Month 4 capstone
│   │   ├── README.md
│   │   ├── architecture/
│   │   │   └── streaming-architecture.png
│   │   ├── producer/
│   │   │   ├── adsb_simulator.py          ← Simulates ADS-B flight position data
│   │   │   └── flight_status_producer.py
│   │   ├── consumer/
│   │   │   ├── position_consumer.py
│   │   │   └── alert_consumer.py
│   │   ├── spark/
│   │   │   ├── streaming_job.py           ← Spark Structured Streaming
│   │   │   └── delay_detector.py
│   │   ├── storage/
│   │   │   └── write_to_db.py
│   │   ├── config/
│   │   │   └── kafka_config.yaml
│   │   ├── tests/
│   │   │   └── test_streaming.py
│   │   ├── docker-compose.yml             ← Kafka + Zookeeper + Spark + Redis
│   │   ├── requirements.txt
│   │   ├── Makefile
│   │   └── .env.example
│   │
│   ├── 04-cloud-aviation-platform/         ← Month 5 capstone
│   │   ├── README.md
│   │   ├── architecture/
│   │   │   └── cloud-architecture.png
│   │   ├── infra/
│   │   │   ├── s3_setup.py               ← Bucket creation and policies
│   │   │   └── bigquery_setup.py         ← Dataset and table creation
│   │   ├── lambda/
│   │   │   ├── handler.py                ← Lambda trigger on S3 upload
│   │   │   └── requirements.txt
│   │   ├── dags/
│   │   │   └── cloud_aviation_dag.py     ← Cloud Composer / MWAA DAG
│   │   ├── dbt/
│   │   │   ├── models/
│   │   │   │   └── marts/
│   │   │   │       └── mart_aviation_summary.sql
│   │   │   └── dbt_project.yml
│   │   ├── src/
│   │   │   ├── upload_to_s3.py
│   │   │   ├── transform_flights.py
│   │   │   └── load_bigquery.py
│   │   ├── tests/
│   │   │   └── test_cloud_pipeline.py
│   │   ├── requirements.txt
│   │   ├── Makefile
│   │   └── .env.example                  ← AWS_ACCESS_KEY, GCP_PROJECT, etc.
│   │
│   ├── 05-airport-operations-system/       ← Month 6 Project A
│   │   ├── README.md
│   │   ├── architecture/
│   │   │   └── airport-ops-diagram.png
│   │   ├── dags/
│   │   │   └── airport_ops_dag.py
│   │   ├── src/
│   │   │   ├── ingestion/
│   │   │   │   ├── ingest_schedules.py
│   │   │   │   └── ingest_passengers.py
│   │   │   ├── processing/
│   │   │   │   ├── congestion_score.py
│   │   │   │   └── peak_hour_detector.py
│   │   │   └── api/
│   │   │       └── main.py               ← FastAPI endpoint
│   │   ├── sql/
│   │   │   └── marts/
│   │   │       ├── hourly_congestion.sql
│   │   │       └── gate_utilization.sql
│   │   ├── tests/
│   │   │   └── test_congestion.py
│   │   ├── docker-compose.yml
│   │   ├── requirements.txt
│   │   ├── Makefile
│   │   └── .env.example
│   │
│   ├── 06-predictive-maintenance-pipeline/ ← Bonus Project
│   │   ├── README.md
│   │   ├── architecture/
│   │   │   └── maintenance-pipeline.png
│   │   ├── sensor_simulator/
│   │   │   └── aircraft_sensor_producer.py
│   │   ├── streaming/
│   │   │   └── anomaly_detector.py
│   │   ├── feature_store/
│   │   │   └── write_features.py
│   │   ├── tests/
│   │   │   └── test_anomaly_detection.py
│   │   ├── docker-compose.yml
│   │   ├── requirements.txt
│   │   └── .env.example
│   │
│   └── 07-route-optimization-system/      ← Bonus Project
│       ├── README.md
│       ├── architecture/
│       │   └── route-system-diagram.png
│       ├── src/
│       │   ├── weather_ingest.py
│       │   ├── fuel_price_ingest.py
│       │   ├── route_scorer.py
│       │   └── output_recommendations.py
│       ├── dags/
│       │   └── route_optimization_dag.py
│       ├── tests/
│       │   └── test_route_scorer.py
│       ├── docker-compose.yml
│       ├── requirements.txt
│       └── .env.example
│
├── monthly-notes/
│   ├── month-01-sql-python.md             ← What you learned, what surprised you
│   ├── month-02-warehouse.md
│   ├── month-03-airflow.md
│   ├── month-04-kafka-spark.md
│   ├── month-05-cloud.md
│   └── month-06-advanced.md
│
├── resources/
│   ├── datasets/
│   │   ├── README.md                      ← How to download each dataset
│   │   └── sources.md                     ← Links to BTS, OpenSky, Kaggle
│   ├── architecture-diagrams/
│   │   └── journey-overview.png           ← Single diagram showing all 7 systems
│   └── references.md                      ← All books, courses, docs used
│
└── .github/
    ├── ISSUE_TEMPLATE/
    │   └── daily-log.md                   ← Daily progress issue template
    └── workflows/
        └── ci.yml                         ← Run tests on every push
```

---

## 🔑 File Templates

### `Makefile` (copy into every project)

```makefile
.PHONY: setup run test clean db-setup load-sample

setup:
	pip install -r requirements.txt

db-setup:
	psql -U postgres -f sql/ddl/create_staging.sql
	psql -U postgres -f sql/ddl/create_warehouse.sql

load-sample:
	python src/loading/load_warehouse.py --source data/sample/

run:
	python src/ingestion/extract_flights.py

test:
	pytest tests/ -v

quality:
	python tests/data_quality/test_warehouse_quality.py

clean:
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down -v
```

---

### `.env.example` (copy into every project, never commit `.env`)

```bash
# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=aviation_db
DB_USER=postgres
DB_PASSWORD=your_password

# Cloud (Month 5+)
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_REGION=us-east-1
S3_BUCKET=your-aviation-bucket

GCP_PROJECT=your-project-id
GCP_KEYFILE=path/to/keyfile.json

# APIs
AVIATIONSTACK_API_KEY=your_key
OPENSKY_USERNAME=your_username
OPENSKY_PASSWORD=your_password

# Airflow (Month 3+)
AIRFLOW_ADMIN_USER=admin
AIRFLOW_ADMIN_PASSWORD=admin
```

---

### `.github/ISSUE_TEMPLATE/daily-log.md`

```markdown
---
name: Daily Log
about: Track daily progress through the aviation data engineering journey
title: "Day [X/180] — [Topic]"
labels: daily-log
---

## ✈️ Day [X] of 180

**Date:** YYYY-MM-DD
**Month:** [1–6]
**Topic:** [What you worked on]

---

### What I Learned
- 
- 
- 

### What I Built
- 

### Key Win
✅ 

### Challenge
⚠️ 

### Tomorrow
➡️ 

### Commits
- [link to commit]

---

*Part of the [Aviation Data Engineering Journey](../../README.md)*
```

---

### `.github/workflows/ci.yml`

```yaml
name: Run Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: aviation_test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

    steps:
    - uses: actions/checkout@v3

    - name: Set up Python 3.11
      uses: actions/setup-python@v4
      with:
        python-version: '3.11'

    - name: Install dependencies
      run: pip install -r requirements.txt

    - name: Run unit tests
      run: pytest tests/unit/ -v

    - name: Run data quality checks
      run: pytest tests/data_quality/ -v
      env:
        DB_HOST: localhost
        DB_PORT: 5432
        DB_NAME: aviation_test
        DB_USER: postgres
        DB_PASSWORD: postgres
```

---

## 📝 Monthly Notes Template

Use this for each `monthly-notes/month-0X-topic.md` file:

```markdown
# Month [X] — [Topic] Reflections

**Dates:** [Start] → [End]
**Days Covered:** [Day X] to [Day Y]

---

## What I Set Out to Learn

[What you planned to cover at the start of the month]

---

## What I Actually Learned

[What you actually covered — including surprises and detours]

---

## Projects Built This Month

| Project | Status | GitHub |
|---------|--------|--------|
| [Name] | Complete | [link] |

---

## Hardest Concept

[The one thing that took the longest to click]

---

## Biggest Win

[The moment or output you are most proud of this month]

---

## How It Connects to Aviation

[How the skills from this month apply to real airline/airport/cargo systems]

---

## What I Am Taking Into Next Month

[Skills or open questions carrying forward]

---

## Useful Resources Found This Month

- [Link] — [Why it was useful]
- [Link] — [Why it was useful]
```

---

## ✅ Repository Launch Checklist

Before going public, verify each repository has:

- [ ] `README.md` with problem statement, architecture diagram, and setup instructions
- [ ] `architecture/system-diagram.png` — a clear visual of the data flow
- [ ] `data/sample/` — small sample dataset so anyone can run it locally
- [ ] `data/schema/data_dictionary.md` — what every column means
- [ ] `docker-compose.yml` — one-command local setup
- [ ] `requirements.txt` — all dependencies pinned (`pip freeze > requirements.txt`)
- [ ] `.env.example` — template for credentials (never commit `.env`)
- [ ] `Makefile` — `make run`, `make test`, `make clean` all work
- [ ] `tests/` — at least basic unit tests for transformation logic
- [ ] `README.md` includes sample output or query results
- [ ] GitHub repo description and topics set (e.g., `aviation`, `data-engineering`, `airflow`)

---

*This structure is designed so that any recruiter, engineer, or peer can clone any project, run `docker-compose up && make run`, and see it working within 5 minutes.*