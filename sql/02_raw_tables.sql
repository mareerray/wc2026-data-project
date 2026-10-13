-- 02_raw_tables.sql
-- Creates the RAW tables. RAW holds data exactly as exported from Supabase,
-- before any cleaning (see sql/schema.sql in the repo for the Postgres version).

-- Session setup: which compute, database and schema to use
use warehouse wc_wh;
use database wc2026;
use schema raw;

-- teams: one row per national team (48 rows expected)
-- WARNING: "create or replace" deletes the old table and its data.
--          Reload the CSV after running it again.
create or replace table teams (
    id          integer not null primary key,  -- team id from football-data.org
    name        varchar not null,              -- full name, e.g. Uruguay
    short_name  varchar,                       -- short display name
    tla         varchar,                       -- 3-letter code, e.g. URU
    crest_url   varchar                        -- link to the team's crest image
);

-- matches: one row per match
create or replace table matches (
    id                 integer not null primary key,  -- match id from football-data.org
    utc_date           varchar not null,         -- kick-off time
    status             varchar not null,              -- e.g. SCHEDULED, FINISHED
    stage              varchar,                       -- e.g. GROUP_STAGE, LAST_16
    group_name         varchar,
    matchday           integer,
    venue              varchar,
    home_team_id       integer,                       -- refers to teams.id
    away_team_id       integer,                       -- refers to teams.id
    duration           varchar,                       -- REGULAR, EXTRA_TIME, PENALTY_SHOOTOUT
    home_goals_full    integer,                       -- includes shootout kicks
    away_goals_full    integer,
    home_goals_regular integer,
    away_goals_regular integer,
    home_pens          integer,                       -- shootout kicks only
    away_pens          integer,
    last_updated       varchar
);

-- scorers: one row per player
create or replace table scorers (
    player_id   integer not null primary key,
    player_name varchar not null,
    team_id     integer,                              -- refers to teams.id
    goals       integer not null,
    updated_at  timestamp_tz not null
);

-- standings: one row per team per group_name
create or replace table standings (
    group_name      varchar not null,                 -- 'OVERALL' is used for group tables
    team_id         integer not null,
    position        integer,
    played          integer,
    won             integer,
    draw            integer,
    lost            integer,
    points          integer,
    goals_for       integer,
    goals_against   integer,
    goal_difference integer,
    primary key (group_name, team_id)
);