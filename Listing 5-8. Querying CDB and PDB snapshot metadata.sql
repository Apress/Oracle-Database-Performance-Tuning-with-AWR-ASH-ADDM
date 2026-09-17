SELECT
    con_id,
    dbid,
    snap_id,
    begin_interval_time,
    end_interval_time
FROM
    cdb_hist_snapshot
WHERE
    begin_interval_time > SYSDATE - 4/24
ORDER BY
    4;
