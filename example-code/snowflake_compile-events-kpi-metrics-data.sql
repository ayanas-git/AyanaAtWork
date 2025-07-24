-- Programme: Compile KPI Metrics Data from Snowflake Events Table
-- Programmer: Ayana Andrews-Joseph (https://github.com/ayanas-git/AyanaAtWork)
-- This is an example of a program that compiles base metrics for data contained in a ficticious Snowflake "EVENTS" table.
-- NOTE: Snowflake includes a default event table called `SNOWFLAKE.TELEMETRY.EVENTS`, An event table is a special kind of database table with a predefined set of columns. 
-- Snowflake Reference/Source Documantation: (Event table overview) https://docs.snowflake.com/en/developer-guide/logging-tracing/event-table-setting-up



-- Environment setup
-- Make sure to replace DB_ALIAS and WH_ALIAS with your actual database and warehouse names.
--DECLARE WAREHOUSE
USE WAREHOUSE WH_ALIAS;
--DECLARE DATABASE
USE DATABASE DB_ALIAS;


-- Create View to use for session
CREATE VIEW DB_ALIAS.PUBLIC.VW_COMMON_FEATURES AS
    --SHARED TOP LEVEL COLUMNS
SELECT
    * EXCLUDE EVENT --Can use EVENTID as Proxy for EVENT aggs
    , CASE 
        WHEN EVENT:user:parameter10::string IS NULL THEN (EVENT:role::string)
        ELSE (EVENT:user:parameter10::string)
    END AS parameter10
FROM DB_ALIAS.PUBLIC.TBL_SOURCEDATA
;
--END Create View

WITH get_eventId AS (
    SELECT
        'EVENTID' AS col_name
        , TYPEOF(EVENTID) AS data_type
        , '1' AS col_position
        , MAX(LEN(EVENTID::STRING)) AS max_length
        , COUNT(EVENTID) AS total_count
        , COUNT(DISTINCT EVENTID) as unique_Values
        , TO_VARCHAR((COUNT(DISTINCT EVENTID) / NULLIF(COUNT(*), 0)) * 100, 'FM999.9') || '%' AS prcnt_unique_Values
        , TO_VARCHAR((COUNT_IF(EVENTID IS NULL) / NULLIF(COUNT(*), 0)) * 100, 'FM999.9') || '%' AS prcnt_null_Values
        , MIN(EVENTID::STRING) AS min_
        , MAX(EVENTID::STRING) AS max_
        , CASE WHEN UPPER(TYPEOF(EVENTID)) IN ('%INT%', '%FLOAT%', '%NUMERIC%') THEN TO_VARCHAR(AVG(CAST(EVENTID AS DOUBLE))) ELSE 'nAN' END AS avg_
        , MODE(EVENTID::STRING) AS most_freq_val
    FROM VW_COMMON_FEATURES
    GROUP BY ALL
    )

, get_eventDate AS (
    SELECT
        'EVENTDATE' AS col_name
        , 'TIMESTAMP' AS data_type
        , '2' AS col_position
        , MAX(LEN(EVENTDATE::STRING)) AS max_length
        , COUNT(EVENTDATE) AS total_count
        , COUNT(DISTINCT EVENTDATE) as unique_Values
        , TO_VARCHAR((COUNT(DISTINCT EVENTDATE) / NULLIF(COUNT(*), 0)) * 100, 'FM999.9') || '%' AS prcnt_unique_Values
        , TO_VARCHAR((COUNT_IF(EVENTDATE IS NULL) / NULLIF(COUNT(*), 0)) * 100, 'FM999.9') || '%' AS prcnt_null_Values
        , MIN(EVENTDATE::STRING) AS min_
        , MAX(EVENTDATE::STRING) AS max_
        , 'naN' avg_
    --   , CASE WHEN UPPER(TYPEOF(EVENTDATE)) IN ('%INT%', '%FLOAT%', '%NUMERIC%') THEN TO_VARCHAR(AVG(CAST(EVENTDATE AS DOUBLE))) ELSE 'nAN' END AS avg_ --NEED TO REVISIT
        , MODE(EVENTDATE::STRING) AS most_freq_val
    FROM VW_COMMON_FEATURES
    GROUP BY ALL
    )

, get_eventType AS (
    SELECT
        'EVENTTYPE' AS col_name
        , TYPEOF(EVENTID) AS data_type
        , '3' AS col_position
        , MAX(LEN(EVENTTYPE::STRING)) AS max_length
        , COUNT(EVENTTYPE) AS total_count
        , COUNT(DISTINCT EVENTTYPE) as unique_Values
        , TO_VARCHAR((COUNT(DISTINCT EVENTTYPE) / NULLIF(COUNT(*), 0)) * 100, 'FM999.9') || '%' AS prcnt_unique_Values
        , TO_VARCHAR((COUNT_IF(EVENTTYPE IS NULL) / NULLIF(COUNT(*), 0)) * 100, 'FM999.9') || '%' AS prcnt_null_Values
        , MIN(EVENTTYPE::STRING) AS min_
        , MAX(EVENTTYPE::STRING) AS max_
        , 'naN' avg_
    --   , CASE WHEN UPPER(TYPEOF(EVENTTYPE)) IN ('%INT%', '%FLOAT%', '%NUMERIC%') THEN TO_VARCHAR(AVG(CAST(EVENTTYPE AS DOUBLE))) ELSE 'nAN' END AS avg_ --NEED TO REVISIT
        , MODE(EVENTTYPE::STRING) AS most_freq_val
    FROM VW_COMMON_FEATURES
    GROUP BY ALL
    )

SELECT *
FROM get_eventId

UNION ALL
SELECT*
FROM get_eventDate

UNION ALL
SELECT *
FROM get_eventType
;

UNION ALL


-- ORDER BY col_position last - taxing!

WITH top5_EVENTID AS (
    SELECT 
        'EVENTID' as col_name
        , LISTAGG(EVENTID, ', ') AS top5
    FROM (
            SELECT 
                EVENTID
                , COUNT(*) cnt
            FROM 
                VW_COMMON_FEATURES
            GROUP BY ALL
            ORDER BY 
                cnt DESC
                , EVENTID LIMIT 5
        ) sub
)

, top5_EVENTDATE AS
    
(
SELECT 'EVENTDATE' as col_name, LISTAGG(EVENTDATE, ', ') AS top5
FROM (SELECT TO_DATE(EVENTDATE) EVENTDATE, COUNT(*) cnt
    FROM VW_COMMON_FEATURES
    GROUP BY ALL
    ORDER BY cnt DESC, EVENTDATE LIMIT 5) sub
)

, top5_EVENTTYPE AS
(
SELECT 'EVENTTYPE' as col_name, LISTAGG(EVENTTYPE, ', ') AS top5
FROM (SELECT EVENTTYPE, COUNT(*) cnt
    FROM VW_COMMON_FEATURES
    GROUP BY ALL
    ORDER BY cnt DESC, EVENTTYPE LIMIT 5) sub
) 

, top5_EVENT AS
(
SELECT 'EVENT' as col_name, 'NOT APPLICABLE' AS top5 
)

, top5_PARAMETER1 AS
(
SELECT 'PARAMETER1' as col_name, LISTAGG(PARAMETER1, ', ') AS top5
FROM (SELECT PARAMETER1, COUNT(*) cnt
    FROM VW_COMMON_FEATURES
    GROUP BY ALL
    ORDER BY cnt DESC, PARAMETER1 LIMIT 5) sub
)

, top5_PARAMETERID AS
(
SELECT 'PARAMETERID' as col_name, LISTAGG(PARAMETERID, ', ') AS top5
FROM (SELECT PARAMETERID, COUNT(*) cnt
    FROM VW_COMMON_FEATURES
    GROUP BY ALL
    ORDER BY cnt DESC, PARAMETERID LIMIT 5) sub
) 

, top5_PARAMETERID1 AS
(
SELECT 'PARAMETERID1' as col_name, LISTAGG(PARAMETERID1, ', ') AS top5
FROM (SELECT PARAMETERID1, COUNT(*) cnt
    FROM VW_COMMON_FEATURES
    GROUP BY ALL
    ORDER BY cnt DESC, PARAMETERID1 LIMIT 5) sub
) 

, top5_PARAMETER2 AS
(
SELECT 'PARAMETER2' as col_name, LISTAGG(PARAMETER2, ', ') AS top5
FROM (SELECT PARAMETER2, COUNT(*) cnt
    FROM VW_COMMON_FEATURES
    GROUP BY ALL
    ORDER BY cnt DESC, PARAMETER2 LIMIT 5) sub
) 

, top5_PARAMETERID2 AS
(
SELECT 'PARAMETERID2' as col_name, LISTAGG(PARAMETERID2, ', ') AS top5
FROM (SELECT PARAMETERID2, COUNT(*) cnt
    FROM VW_COMMON_FEATURES
    GROUP BY ALL
    ORDER BY cnt DESC, PARAMETERID2 LIMIT 5) sub
) 

, top5_PARAMETER3 AS
(
SELECT 'PARAMETER3' as col_name, LISTAGG(PARAMETER3, ', ') AS top5
FROM (SELECT PARAMETER3, COUNT(*) cnt
    FROM VW_COMMON_FEATURES
    GROUP BY ALL
    ORDER BY cnt DESC, PARAMETER3 LIMIT 5) sub
) 

, top5_PARAMETERID3 AS
(
SELECT 'PARAMETERID3' as col_name, LISTAGG(PARAMETERID3, ', ') AS top5
FROM (SELECT PARAMETERID3, COUNT(*) cnt
    FROM VW_COMMON_FEATURES
    GROUP BY ALL
    ORDER BY cnt DESC, PARAMETERID3 LIMIT 5) sub
) 

, top5_PARAMETER4 AS
(
SELECT 'PARAMETER4' as col_name, LISTAGG(PARAMETER4, ', ') AS top5
FROM (SELECT PARAMETER4, COUNT(*) cnt
    FROM VW_COMMON_FEATURES
    GROUP BY ALL
    ORDER BY cnt DESC, PARAMETER4 LIMIT 5) sub
) 

, top5_PARAMETER5 AS
(
SELECT 'PARAMETER5' as col_name, LISTAGG(PARAMETER5, ', ') AS top5
FROM (SELECT PARAMETER5, COUNT(*) cnt
    FROM VW_COMMON_FEATURES
    GROUP BY ALL
    ORDER BY cnt DESC, PARAMETER5 LIMIT 5) sub
) 

, top5_PARAMETER6 AS
(
SELECT 'PARAMETER6' as col_name, LISTAGG(PARAMETER6, ', ') AS top5
FROM (SELECT PARAMETER6, COUNT(*) cnt
    FROM VW_COMMON_FEATURES
    GROUP BY ALL
    ORDER BY cnt DESC, PARAMETER6 LIMIT 5) sub
) 

, top5_PARAMETER7 AS
(
SELECT 'PARAMETER7' as col_name, LISTAGG(PARAMETER7, ', ') AS top5
FROM (SELECT PARAMETER7, COUNT(*) cnt
    FROM VW_COMMON_FEATURES
    GROUP BY ALL
    ORDER BY cnt DESC, PARAMETER7 LIMIT 5) sub
) 

, top5_PARAMETER8 AS
(
SELECT 'PARAMETER8' as col_name, LISTAGG(PARAMETER8, ', ') AS top5
FROM (SELECT PARAMETER8, COUNT(*) cnt
    FROM VW_COMMON_FEATURES
    GROUP BY ALL
    ORDER BY cnt DESC, PARAMETER8 LIMIT 5) sub
) 

, top5_PARAMETER9 AS
(
SELECT 'PARAMETER9' as col_name, LISTAGG(PARAMETER9, ', ') AS top5
FROM (SELECT PARAMETER9, COUNT(*) cnt
    FROM VW_COMMON_FEATURES
    GROUP BY ALL
    ORDER BY cnt DESC, PARAMETER9 LIMIT 5) sub
) 

, top5_PARAMETER10 AS
(
SELECT 'PARAMETER10' as col_name, LISTAGG(PARAMETER10, ', ') AS top5
FROM (SELECT PARAMETER10, COUNT(*) cnt
    FROM VW_COMMON_FEATURES
    GROUP BY ALL
    ORDER BY cnt DESC, PARAMETER10 LIMIT 5) sub
)

SELECT *
FROM top5_EVENTID
UNION ALL

SELECT*
FROM top5_EVENTDATE
UNION ALL

SELECT *
FROM top5_EVENTTYPE
UNION ALL

SELECT*
FROM top5_EVENT
UNION ALL

SELECT *
FROM top5_PARAMETER1
UNION ALL

SELECT*
FROM top5_PARAMETERID
UNION ALL

SELECT *
FROM top5_PARAMETERID1
UNION ALL

SELECT*
FROM top5_PARAMETER2
UNION ALL

SELECT *
FROM top5_PARAMETERID2
UNION ALL

SELECT*
FROM top5_PARAMETER3
UNION ALL

SELECT *
FROM top5_PARAMETERID3
UNION ALL

SELECT*
FROM top5_PARAMETER4
UNION ALL

SELECT *
FROM top5_PARAMETER5
UNION ALL

SELECT*
FROM top5_PARAMETER6
UNION ALL

SELECT *
FROM top5_PARAMETER7
UNION ALL

SELECT*
FROM top5_PARAMETER8
UNION ALL

SELECT *
FROM top5_PARAMETER9
UNION ALL

SELECT*
FROM top5_PARAMETER10
;
-- END of KPI Metrics Data Compilation from Snowflake Events Table
-- END of Example Program