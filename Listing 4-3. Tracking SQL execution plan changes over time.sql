define my_sql_id='f90zn75aphu4w'

WITH plan_ash AS (
    SELECT 
        sql_id,
        sql_child_number,
        sql_exec_id,
        TO_CHAR(sample_time, 'MON-DD HH24:MI:SS') AS track_time,
        sql_exec_start,
        sql_plan_hash_value AS curr_sql_plan,
        LAG(sql_plan_hash_value, 1) OVER (
            PARTITION BY sql_id, sql_exec_id, sql_exec_start
            ORDER BY sample_time ASC
        ) AS prev_sql_plan
    FROM 
        dba_hist_active_sess_history
    WHERE 
        sample_time > TRUNC(SYSDATE)
        AND sql_id = '&my_sql_id'
        AND sql_exec_id IS NOT NULL
)
SELECT 
    track_time,
    sql_child_number,
    sql_exec_id,
    curr_sql_plan,
    prev_sql_plan,
    CASE 
        WHEN curr_sql_plan <> prev_sql_plan THEN 'Y' 
        ELSE 'N'
    END AS changed
FROM 
    plan_ash
WHERE 
    1 = 1
    -- and curr_sql_plan <> prev_sql_plan
ORDER BY 
    sql_exec_start ASC,
    sql_exec_id ASC,
    track_time ASC;
