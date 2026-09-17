WITH function_delta AS (
    SELECT
        io.function_name,
        MAX(io.small_read_megabytes
          + io.large_read_megabytes
          + io.small_write_megabytes
          + io.large_write_megabytes)
      - MIN(io.small_read_megabytes
          + io.large_read_megabytes
          + io.small_write_megabytes
          + io.large_write_megabytes) AS total_mb,
        MAX(io.small_read_reqs
          + io.large_read_reqs
          + io.small_write_reqs
          + io.large_write_reqs)
      - MIN(io.small_read_reqs
          + io.large_read_reqs
          + io.small_write_reqs
          + io.large_write_reqs) AS total_reqs,
        MAX(io.wait_time) - MIN(io.wait_time) AS wait_time_ms,
        MAX(io.number_of_waits) - MIN(io.number_of_waits) AS waits
    FROM
        dba_hist_iostat_function io
        JOIN dba_hist_snapshot sn
          ON sn.snap_id         = io.snap_id
         AND sn.dbid            = io.dbid
         AND sn.instance_number = io.instance_number
    WHERE
        sn.end_interval_time >= SYSDATE - 1
    GROUP BY
        io.dbid,
        io.instance_number,
        io.function_name
)
SELECT
    function_name,
    ROUND(SUM(total_mb) / 1024, 2) AS total_gb,
    SUM(total_reqs) AS total_reqs,
    ROUND(
        CASE
            WHEN SUM(waits) > 0
            THEN SUM(wait_time_ms) / SUM(waits)
            ELSE 0
        END,
        2
    ) AS avg_lat_ms
FROM
    function_delta
GROUP BY
    function_name
ORDER BY
    total_gb DESC;
