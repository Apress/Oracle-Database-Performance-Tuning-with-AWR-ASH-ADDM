DEFINE dbid       = 4250576883
DEFINE inst_num   = 1
DEFINE top_sql_id = 'g81cbrq5yamf5'

WITH sql_stat AS (
    SELECT snap_id,
           dbid,
           instance_number,
           plan_hash_value,
           SUM(elapsed_time_delta)
             / 1000000
             / NULLIF(SUM(executions_delta), 0) AS avg_elapsed_second
    FROM dba_hist_sqlstat
    WHERE dbid = &dbid
      AND instance_number = &inst_num
      AND sql_id = '&top_sql_id'
    GROUP BY snap_id,
             dbid,
             instance_number,
             plan_hash_value
)
SELECT s.snap_id,
       TO_CHAR(s.end_interval_time, 'HH24:MI') AS snap_time,
       st.plan_hash_value,
       ROUND(st.avg_elapsed_second, 5) AS avg_elapsed_second
FROM dba_hist_snapshot s
LEFT JOIN sql_stat st
  ON st.dbid = s.dbid
 AND st.instance_number = s.instance_number
 AND st.snap_id = s.snap_id
WHERE s.dbid = &dbid
  AND s.instance_number = &inst_num
  AND s.begin_interval_time >= TRUNC(SYSDATE)
ORDER BY s.snap_id, st.plan_hash_value;
