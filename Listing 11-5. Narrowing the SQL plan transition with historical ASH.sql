DEFINE dbid       = 4250576883
DEFINE inst_num   = 1
DEFINE top_sql_id = 'g81cbrq5yamf5'

SELECT sql_id,
       sql_child_number,
       TO_CHAR(sample_time, 'HH24:MI:SS') AS track_time,
       sql_plan_hash_value AS curr_sql_plan
FROM dba_hist_active_sess_history
WHERE dbid = &dbid
  AND instance_number = &inst_num
  AND snap_id = 2941
  AND sql_id = '&top_sql_id'
ORDER BY sample_time;
