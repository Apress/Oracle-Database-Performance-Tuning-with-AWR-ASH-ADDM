SELECT snap_id,
       dbid,
       instance_number,
       TO_CHAR(begin_interval_time, 'HH24:MI:SS') AS begin_interval_time,
       TO_CHAR(end_interval_time, 'HH24:MI:SS') AS end_interval_time
FROM dba_hist_snapshot
ORDER BY snap_id;
