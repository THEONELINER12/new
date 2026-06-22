# Hummingflow AI Sales Agent

FastAPI MVP for compliant lead intake, deterministic scoring, qualified-only Clay enrichment, contact
persistence, and automated reporting at 10:00 AM and 5:00 PM IST.

## Included API routes

- `POST /leads/intake`
- `GET /leads`
- `GET /leads/{id}`
- `POST /leads/{id}/score`
- `POST /leads/{id}/enrich`
- `GET /leads/{id}/contacts`

Only Hot and Warm leads can be enriched. When Clay is not configured, the application creates
clearly labeled mock contacts using reserved `.example` addresses.

## Run

Create and activate a virtual environment, then install every dependency:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
Copy-Item .env.example .env
```

Create a PostgreSQL database and apply the schema:

```powershell
psql $env:DATABASE_URL -f app/database/schema.sql
```

Start FastAPI and the scheduler together:

```powershell
python -m uvicorn app.main:app --reload
```

Open `http://127.0.0.1:8000/docs` for interactive API testing. APScheduler starts through the
FastAPI lifespan and runs at hours `10,17`, minute `0`, in `Asia/Kolkata`.

## Automated lead feed

`LEAD_SOURCE_JSON_PATH` accepts either a JSON array of lead objects or an object containing a
`leads` array. The included `sample_lead.json` is suitable for manual API intake; wrap it in a JSON
array for scheduled ingestion.

The scheduler stores and scores new leads, enriches only Hot/Warm leads, persists contacts, and sends
an SMTP summary. With SMTP unset, it writes the report to application logs. No LinkedIn scraping is
implemented.

