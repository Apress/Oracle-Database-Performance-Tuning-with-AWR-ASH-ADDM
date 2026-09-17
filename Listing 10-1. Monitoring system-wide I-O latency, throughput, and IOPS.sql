SELECT 
    h.snap_id, 
    TO_CHAR(s.begin_interval_time, 'HH24:MI:SS') AS snap_date,
    ROUND(MAX(CASE WHEN h.metric_name = 'Average Synchronous Single-Block Read Latency' 
                   THEN h.average END), 4) AS read_latency_ms,
    ROUND(MAX(CASE WHEN h.metric_name = 'I/O Megabytes per Second' 
                   THEN h.average END), 2) AS io_mbps,
    ROUND(MAX(CASE WHEN h.metric_name = 'I/O Requests per Second' 
                   THEN h.average END), 2) AS io_iops
FROM 
    dba_hist_sysmetric_summary h
JOIN 
    dba_hist_snapshot s 
    ON  h.snap_id = s.snap_id 
    AND h.dbid = s.dbid 
    AND h.instance_number = s.instance_number
WHERE 
    h.dbid = 2788912098 
    AND h.instance_number = 1
    AND s.end_interval_time >= SYSDATE - 1
    AND h.metric_name IN (
        'Average Synchronous Single-Block Read Latency',
        'I/O Megabytes per Second',
        'I/O Requests per Second'
    )
GROUP BY 
    h.snap_id, 
    s.begin_interval_time
ORDER BY 
    h.snap_id;
