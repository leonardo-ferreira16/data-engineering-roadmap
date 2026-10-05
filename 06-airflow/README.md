# 06 — Apache Airflow

Planned topics:

- DAGs
- tasks and dependencies
- scheduling
- retries
- backfills
- variables and connections
- logs
- failure handling
- Docker Compose

Target DAG:

```text
extract_api
   ↓
validate_data
   ↓
load_raw
   ↓
transform
   ↓
load_dw
```
