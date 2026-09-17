SET TAB OFF
SET LINESIZE 200

SELECT session_id,
       session_serial#,
       sql_id,
       TO_CHAR(sql_exec_start, 'HH24:MI:SS') AS exec_start,
       TO_CHAR(MAX(sample_time), 'HH24:MI:SS.FF3') AS end_time,
       MAX(sample_time) - CAST(sql_exec_start AS TIMESTAMP) AS run_time
FROM dba_hist_active_sess_history
WHERE sql_exec_start BETWEEN SYSDATE - INTERVAL '3' HOUR 
                         AND SYSDATE - INTERVAL '1' HOUR
  AND sql_exec_id > 0
GROUP BY session_id,
         session_serial#,
         sql_id,
         sql_plan_hash_value,
         sql_exec_id,
         sql_exec_start
ORDER BY run_time DESC
FETCH FIRST 10 ROWS ONLY;
