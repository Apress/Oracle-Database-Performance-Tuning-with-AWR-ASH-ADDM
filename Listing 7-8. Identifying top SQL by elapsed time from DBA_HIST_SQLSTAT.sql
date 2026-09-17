SELECT
    sq.sql_id,
    sq.plan_hash_value AS plan_hash,
    ROUND(SUM(sq.elapsed_time_delta) / 1000000, 2) AS elapsed_s,
    SUM(sq.buffer_gets_delta) AS buffer_gets,
    ROUND(SUM(sq.cpu_time_delta) / 1000000, 2) AS cpu_s,
    SUM(sq.executions_delta) AS executions
FROM
    dba_hist_sqlstat sq
    JOIN dba_hist_snapshot sn
      ON sn.dbid            = sq.dbid
     AND sn.snap_id         = sq.snap_id
     AND sn.instance_number = sq.instance_number
WHERE
    TRUNC(sn.end_interval_time) = TRUNC(SYSDATE)
    AND sq.dbid = 1451443679
    AND sq.parsing_schema_name <> 'SYS'  -- Exclude SQL parsed under SYS
GROUP BY
    sq.sql_id,
    sq.plan_hash_value
ORDER BY
    elapsed_s DESC,
    buffer_gets DESC,
    cpu_s DESC,
    executions DESC
FETCH FIRST 10 ROWS ONLY;
