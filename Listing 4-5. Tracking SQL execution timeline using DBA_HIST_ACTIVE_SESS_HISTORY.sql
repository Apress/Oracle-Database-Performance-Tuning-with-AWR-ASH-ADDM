set pagesize 100
SELECT sample_id,
       sql_id,
       sql_exec_id,
       TO_CHAR(sql_exec_start, 'HH24:MI:SS') AS sql_start_time,
       TO_CHAR(sample_time, 'HH24:MI:SS.FF3') AS sample_time
FROM dba_hist_active_sess_history
WHERE session_id = 20 
  AND session_serial# = 5847
ORDER BY sample_id;
