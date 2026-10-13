/*
01_setup.sql
Creates the compute, the database and the three data layers.

Layers (medallion architecture):
    raw      Data loaded as it came, with no changes
    staging  Cleaned data: views like match_analytics and match_details
    marts    Analytics-ready views like team_performance and stage_analytics

Warehouse wc_wh: X-Small, suspends after 60 seconds to save trial credits.
*/

-- 1. Warehouse = the compute that runs queries
create warehouse if not exists wc_wh
    warehouse_size = 'XSMALL'
    auto_suspend = 60
    auto_resume = true
    initially_suspended = true;
use warehouse wc_wh;

-- 2. Database and the 3 layers
create database if not exists wc2026;
use database wc2026;

create schema if not exists raw;
create schema if not exists staging;
create schema if not exists marts;

-- 3. Check where we are
use schema raw;
select current_warehouse(), current_database(), current_schema();