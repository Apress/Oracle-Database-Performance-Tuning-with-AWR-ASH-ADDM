DEFINE sql_id = 'a8ntu3081hfgw'
SET tab OFF
SET linesize 200

SELECT session_id,
       session_serial#,
       sql_plan_hash_value,
       TO_CHAR(sql_exec_start, 'HH24:MI:SS') EXEC_START,
       TO_CHAR(MAX(sample_time), 'HH24:MI:SS.FF3') END_TIME,
       MAX(sample_time) - CAST(sql_exec_start AS TIMESTAMP) AS RUN_TIME
FROM dba_hist_active_sess_history
WHERE sql_id = '&sql_id'
  AND sample_time > TRUNC(sysdate)
  AND sql_exec_id > 0
GROUP BY session_id,
         session_serial#,
         sql_id,
         sql_plan_hash_value,
         sql_exec_id,
         sql_exec_start
ORDER BY 6 DESC
FETCH FIRST 10 ROWS ONLY;
