WITH sz_snap AS (
    SELECT
        snap_id,
        TO_DATE(h.rtime, 'MM/DD/YYYY HH24:MI:SS') AS sz_date,
        ROUND(SUM(h.tablespace_usedsize * p.value / 1024 / 1024)) AS UsedMB_DB
    FROM
        dba_hist_tbspc_space_usage h,
        v$parameter p
    WHERE
        p.name = 'db_block_size'
        AND h.dbid = 2788912098
    GROUP BY
        snap_id,
        TO_DATE(h.rtime, 'MM/DD/YYYY HH24:MI:SS')
)
SELECT
    TRUNC(sz_date) AS truncated_date,
    MAX(UsedMB_DB) AS max_used_mb
FROM
    sz_snap
GROUP BY
    TRUNC(sz_date)
ORDER BY
    TRUNC(sz_date);
