# Snowflake Events Data Metrics Script

>_Author: Ayana Andrews-Joseph  
GitHub: [ayanasgit/AyanaAtWork](https://github.com/ayanas-git/AyanaAtWork)_

This document describes an example SQL script for compiling base metrics and KPI data from a Snowflake events table. The script provides data profiling and top value analysis for user activity events.

## Overview

This script analyzes a <span style="color:blue">**sample**</span> Snowflake "EVENTS" table (modeled after `SNOWFLAKE.TELEMETRY.EVENTS`) and generates two main reports:

1. **Column Statistics** – Profiling metrics for key columns
2. **Top 5 Values** – Most frequent values per column

## Prerequisites

- Snowflake warehouse: `WH_ALIAS`
- Database: `DB_ALIAS`
- Source table: `TBL_SOURCEDATA`
- Permissions to create views and query data

## Script Components

### 1. Environment Setup

```sql
USE WAREHOUSE WH_ALIAS;
USE DATABASE DB_ALIAS;
```

### 2. View Creation

Creates a reusable view `VW_COMMON_FEATURES` that:

- Excludes the complex `EVENT` column for performance
- Extracts `parameter10` from nested JSON event data
- Serves as the base for all subsequent analysis

### 3. Column Statistics Analysis

Generates comprehensive metrics for key columns including:

- **EVENTID** - Unique event identifiers
- **EVENTDATE** - Event timestamps
- **EVENTTYPE** - Types of events

**Metrics calculated:**

- Data type and maximum length
- Total count and unique values
- Percentage of unique and null values
- Min/max values and most frequent value
- Average (for numeric columns)

### 4. Top 5 Values Analysis

Identifies the most frequent values for all 18 columns:

- `EVENTID`, `EVENTDATE`, `EVENTTYPE`
- `PARAMETER1`, `PARAMETERID`
- `PARAMETERID1`, `PARAMETER2`
- `PARAMETERID2`, `PARAMETER3`
- `PARAMETERID3`, `PARAMETER4`, `PARAMETER5`
- `PARAMETER6`, `PARAMETER7`, `PARAMETER8`
- `PARAMETER9`, `PARAMETER10`

## Usage Instructions

1. **Run warehouse and database setup commands separately first**
2. **Execute the view creation section**
3. **Run the column statistics query for data profiling**
4. **Run the top 5 values query for frequency analysis**

## Output

The script produces two result sets:

### Column Statistics Output

| col_name | data_type | col_position | max_length | total_count | unique_values | prcnt_unique_values | prcnt_null_values | min_ | max_ | avg_ | most_freq_val |
|----------|-----------|--------------|------------|-------------|---------------|-------------------|------------------|------|------|------|---------------|

### Top 5 Values Output

| col_name | top5 |
|----------|------|
| EVENTID | value1, value2, value3, value4, value5 |
| EVENTDATE | date1, date2, date3, date4, date5 |
| ... | ... |

## Reference Documentation

- [Snowflake Event Table Overview](https://docs.snowflake.com/en/developer-guide/logging-tracing/event-table-setting-up)

## Notes

- The `EVENT` column is marked as "NOT APPLICABLE" in top 5 analysis due to its complex JSON structure
- Script uses `LISTAGG` to concatenate top values with comma separation
- Performance optimized with `GROUP BY ALL` and strategic use of subqueries

---
