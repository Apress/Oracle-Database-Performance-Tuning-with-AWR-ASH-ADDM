SELECT sample_id,
       TO_CHAR(sample_time, 'HH24:MI:SS.FF3') AS sample_time,
       session_id,
       session_state,
       sql_id,
       event
  FROM DBA_HIST_ACTIVE_SESS_HISTORY
 WHERE sample_id BETWEEN 15036882 AND 15036941
 ORDER BY sample_id;
