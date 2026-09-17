WITH filetype_stat AS (
    SELECT
        snap_id,
        dbid,
        instance_number,
        filetype_name,
        SUM(small_read_megabytes
          + large_read_megabytes
          + small_write_megabytes
          + large_write_megabytes) AS total_mb,
        SUM(small_read_reqs
          + large_read_reqs
          + small_write_reqs
          + large_write_reqs) AS total_reqs,
        SUM(small_read_servicetime
          + large_read_servicetime
          + small_write_servicetime
          + large_write_servicetime) AS total_svc
    FROM
        dba_hist_iostat_filetype
    GROUP BY
        snap_id,
        dbid,
        instance_number,
        filetype_name
),
filetype_delta AS (
    SELECT
        io.filetype_name,
        MAX(io.total_mb) - MIN(io.total_mb) AS total_mb,
        MAX(io.total_reqs) - MIN(io.total_reqs) AS total_reqs,
        MAX(io.total_svc) - MIN(io.total_svc) AS total_svc_ms
    FROM
        filetype_stat io
        JOIN dba_hist_snapshot sn
          ON sn.snap_id         = io.snap_id
         AND sn.dbid            = io.dbid
         AND sn.instance_number = io.instance_number
    WHERE
        sn.end_interval_time >= SYSDATE - 1
    GROUP BY
        io.dbid,
        io.instance_number,
        io.filetype_name
)
SELECT
    filetype_name,
    ROUND(SUM(total_mb) / 1024, 2) AS total_gb,
    SUM(total_reqs) AS total_reqs,
    ROUND(
        CASE
            WHEN SUM(total_reqs) > 0
            THEN SUM(total_svc_ms) / SUM(total_reqs)
            ELSE 0
        END,
        2
    ) AS avg_lat_ms
FROM
    filetype_delta
GROUP BY
    filetype_name
ORDER BY
    total_gb DESC;
