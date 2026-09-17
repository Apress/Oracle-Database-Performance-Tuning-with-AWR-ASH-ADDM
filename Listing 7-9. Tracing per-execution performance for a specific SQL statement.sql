DEFINE target_sql_id = 2m7qv75xxgb1u
SELECT
    stat.snap_id AS snap,
    TO_CHAR(snap.end_interval_time, 'MM-DD HH24:MI') AS tm,
    stat.plan_hash_value AS plan,
    SUM(stat.executions_delta) AS execs,
    ROUND(SUM(stat.elapsed_time_delta) / NULLIF(SUM(stat.executions_delta), 0) / 1000, 2) AS elap_ms,
    ROUND(SUM(stat.buffer_gets_delta) / NULLIF(SUM(stat.executions_delta), 0), 0) AS gets,
    ROUND(SUM(stat.disk_reads_delta) / NULLIF(SUM(stat.executions_delta), 0), 0) AS reads,
    ROUND(SUM(stat.rows_processed_delta) / NULLIF(SUM(stat.executions_delta), 0), 0) AS rows_p,
    ROUND(SUM(stat.cpu_time_delta) / NULLIF(SUM(stat.executions_delta), 0) / 1000, 2) AS cpu_ms,
    ROUND(SUM(stat.iowait_delta) / NULLIF(SUM(stat.executions_delta), 0) / 1000, 2) AS io_ms
FROM 
    dba_hist_sqlstat stat
JOIN 
    dba_hist_snapshot snap ON stat.snap_id = snap.snap_id 
    AND stat.dbid = snap.dbid 
    AND stat.instance_number = snap.instance_number
WHERE
    stat.sql_id = '&target_sql_id'
    AND snap.end_interval_time > SYSDATE -7 
GROUP BY
    stat.snap_id,
    TO_CHAR(snap.end_interval_time, 'MM-DD HH24:MI'),
    stat.plan_hash_value
ORDER BY
    stat.snap_id ASC,
    stat.plan_hash_value;
