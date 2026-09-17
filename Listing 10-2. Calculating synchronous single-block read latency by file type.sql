SELECT
    io.filetype_name,
    MAX(io.small_sync_read_reqs) - MIN(io.small_sync_read_reqs) AS sync_reqs,
    ROUND(
        CASE 
            WHEN (MAX(io.small_sync_read_reqs) - MIN(io.small_sync_read_reqs)) > 0 
            THEN (MAX(io.small_sync_read_latency) - MIN(io.small_sync_read_latency)) / (MAX(io.small_sync_read_reqs) - MIN(io.small_sync_read_reqs)) 
            ELSE 0 
        END, 
    2) AS sync_read_ms
FROM
    dba_hist_iostat_filetype io
JOIN
    dba_hist_snapshot sn
    ON  io.snap_id = sn.snap_id
    AND io.dbid = sn.dbid
    AND io.instance_number = sn.instance_number
WHERE
    sn.end_interval_time >= SYSDATE - 1
    AND sn.dbid = 2788912098 
    AND sn.instance_number = 1
GROUP BY
    io.instance_number,
    io.filetype_name
ORDER BY
    io.instance_number,
    sync_reqs DESC;
