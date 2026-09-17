WITH baseline AS (
   SELECT sql_id,
          plan_hash_value,
          SUM(elapsed_time_delta)/NULLIF(SUM(executions_delta),0) AS avg_time_baseline,
          SUM(buffer_gets_delta)/NULLIF(SUM(executions_delta),0) AS avg_buffer_baseline,
          SUM(executions_delta) AS execs_baseline
   FROM dba_hist_sqlstat a
   JOIN dba_hist_snapshot s
      ON a.dbid = s.dbid
     AND a.instance_number = s.instance_number
    AND a.snap_id = s.snap_id
   WHERE s.begin_interval_time >= TRUNC(SYSDATE) - 1 + 9/24
     AND s.begin_interval_time <  TRUNC(SYSDATE) - 1 + 10/24
     AND a.dbid = 4250576883
     AND a.parsing_schema_name <> 'SYS'
   GROUP BY sql_id, plan_hash_value 
), current_period AS (
   SELECT sql_id,
          plan_hash_value,
          SUM(elapsed_time_delta)/NULLIF(SUM(executions_delta),0) AS avg_time_current,
          SUM(buffer_gets_delta)/NULLIF(SUM(executions_delta),0) AS avg_buffer_current,
          SUM(executions_delta) AS execs_current
   FROM dba_hist_sqlstat a
   JOIN dba_hist_snapshot s
      ON a.dbid = s.dbid
     AND a.instance_number = s.instance_number
    AND a.snap_id = s.snap_id
   WHERE s.begin_interval_time >= TRUNC(SYSDATE) + 9/24
     AND s.begin_interval_time <  TRUNC(SYSDATE) + 10/24
     AND a.dbid = 4250576883
     AND a.parsing_schema_name <> 'SYS'
   GROUP BY sql_id, plan_hash_value 
) 
SELECT b.sql_id,
       b.plan_hash_value AS plan_bl,
       c.plan_hash_value AS plan_cur,
       ROUND(b.avg_time_baseline/1000,2) AS base_ms,
       ROUND(c.avg_time_current/1000,2)  AS curr_ms,
       ROUND(b.avg_buffer_baseline) AS base_buf,
       ROUND(c.avg_buffer_current)  AS curr_buf,
       b.execs_baseline AS exec_bl,
       c.execs_current AS exec_cur,
       ROUND((c.avg_time_current - b.avg_time_baseline)/b.avg_time_baseline*100,1) AS pct_chg 
FROM baseline b 
JOIN current_period c ON b.sql_id = c.sql_id 
WHERE b.avg_time_baseline > 0
  AND (c.avg_time_current - b.avg_time_baseline)/b.avg_time_baseline > 0.2 
ORDER BY pct_chg DESC, exec_cur DESC
FETCH FIRST 10 ROWS ONLY;
