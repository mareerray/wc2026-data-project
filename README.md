# World Cup 2026 Data Project

A small data engineering and analytics practice project, built by reusing the match data from my [World Cup 2026 Tracker](https://github.com/mareerray/worldcup2026-tracker) app.

**Status:** In progress

## Why I built this

I'm learning data engineering and analytics engineering. I wanted to practice data modeling, SQL and analytics on real data, so I reused the data from my own app instead of a sample dataset.

## Data flow
```
football-data.org API → Supabase (Postgres) → CSV export → Snowflake → SQL views
```

1. **API:** My World Cup tracker app gets match data from the football-data.org API.
2. **Supabase:** After the tournament, I saved the data in a Supabase database.
3. **Snowflake:** I loaded the data from Supabase into Snowflake (free trial).
4. **Analytics:** I write SQL queries in Snowflake to answer questions about the tournament.

## Data model

| Table | Type | Description |
|-------|------|-------------|
| matches | Fact | One row per match, with score and date |
| teams | Dimension | One row per team |
| standings | [Fact or dimension] | Group tables |

## Questions I want to answer

- Which teams scored the most goals?
- How many matches ended in a draw?
- Do home teams win more often than away teams?
- [Add your own question]

## Project structure
```
wc2026-data-project/
├── README.md
├── docs/
│   ├── data-flow.png
│   ├── data-model.png
│   └── results-screenshot.png
└── sql/
    ├── 01_setup.sql
    ├── 02_raw_tables.sql
    ├── 03_load_data.sql
    ├── 04_staging_views.sql
    ├── 05_marts_views.sql
    └── 06_checks.sql
```

## Tools

- Snowflake (SQL)
- Supabase (PostgreSQL)
- football-data.org API

## What's next

- [ ] Clean and model the data into fact and dimension tables
- [ ] Add more analytics queries
- [ ] Add dbt models on top of the Snowflake tables
- [ ] Add a diagram of the data model

## Notes

The original app was built with help from AI. I'm writing the data modeling and SQL in this project myself, to learn the concepts.

No passwords or API keys are stored in this repo.
