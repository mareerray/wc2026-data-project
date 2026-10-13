-- 03_checks.sql
-- Quick checks that the RAW tables loaded correctly.

use warehouse wc_wh;
use database wc2026;
use schema raw;

-- Show schemas
show schemas in database wc2026;

-- Which tables exist?
show tables in schema wc2026.raw;

-- TEAMS: ----------------------------------------
-- Row counts after loading: should be 48 records
select count(*) as team_count from wc2026.raw.teams;     -- expect 48

-- Sample rows
select * from wc2026.raw.teams limit 5;    -- first row should be Uruguay (758)

-- Check for duplicates: any team ID that appears more than once? (expect no rows)
select id, count(*) 
from wc2026.raw.teams
group by id
having count(*) > 1;


-- MATCHES: ----------------------------------------
-- Row counts: Expect 104 records in total
select count(*) as match_count from wc2026.raw.matches;

-- Sample rows: Do the dates and scores look right?
select id, utc_date, stage, home_team_id, away_team_id,
        home_goals_full, away_goals_full, home_pens, away_pens
from wc2026.raw.matches
limit 10;

-- Check for duplicates: Any match id that appears more than once? (expect no rows)
select id, count(*)
from wc2026.raw.matches
group by id
having count(*) > 1;

-- Orphan check: match team IDs missing from teams (expect no rows)
-- Snowflake doesn't enforce foreign keys, so we have to check it ourselves.
select m.id, m.home_team_id, m.away_team_id
from wc2026.raw.matches m
left join wc2026.raw.teams h on h.id = m.home_team_id
left join wc2026.raw.teams a on a.id = m.away_team_id
where (m.home_team_id is not null and h.id is null)
   or (m.away_team_id is not null and a.id is null); -- Give me matches that name a home team, where that team is missing from the teams table.

-- OR splitting into two queries
-- Orphan check, home side: home_team_id not found in teams (expect no rows)
select m.id, m.home_team_id
from wc2026.raw.matches m
left join wc2026.raw.teams h
    on h.id = m.home_team_id
where m.home_team_id is not null
    and h.id is null; -- Give me matches that name a home team, where that team is missing from the teams table.

-- Orphan check, away side: away_team_id not found in teams (expect no rows)
select m.id, m.away_team_id
from wc2026.raw.matches m
left join wc2026.raw.teams a
    on a.id = m.away_team_id
where m.away_team_id is not null
    and a.id is null; -- Give me matches that name a home team, where that team is missing from the teams table.


-- SCORERS: ----------------------------------------
-- Row counts: Expect 100 records
select count(*) as scorer_count from wc2026.raw.scorers;

-- Sample rows: 
select player_id, player_name, goals, updated_at
from wc2026.raw.scorers
limit 5;

-- Check for duplicates
select player_id, count(*)
from wc2026.raw.scorers
group by player_id
having count(*) > 1;

-- Orphan check: scorer team_id not found in teams (expect no rows)
select s.player_id, s.team_id
from wc2026.raw.scorers s
left join wc2026.raw.teams t
    on s.team_id = t.id
where s.team_id is not null 
    and t.id is null; -- Give me scorers that name a team, where that team is missing from the teams table.


-- STANDINGS: ----------------------------------------
-- Row counts: Expect 48 records
select count(*) as standing_rows from wc2026.raw.standings;

-- Sample rows
select * from wc2026.raw.standings limit 5;

select count(distinct team_id) as teams_in_overall
from wc2026.raw.standings
where group_name = 'OVERALL';   -- expect 48

-- Check for duplicates:
select group_name, team_id, count(*)
from wc2026.raw.standings
group by group_name, team_id
having count(*) > 1;

-- Orphan check: standing team_id not found in teams (expect no rows)
select st.team_id
from wc2026.raw.standings st
left join wc2026.raw.teams t
    on st.team_id = t.id
where st.team_id is not null
    and t.id is null; -- Give me standings that name a team, where that team is missing from the teams.