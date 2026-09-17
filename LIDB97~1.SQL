DEFINE dbid       = 4250576883
DEFINE inst_num   = 1
DEFINE snap_begin = 5579
DEFINE snap_end   = 5580

WITH sys_io AS (
    SELECT
        SUM(value - prev_value) AS total_reads
    FROM (
        SELECT
            s.dbid,
            s.instance_number,
            s.snap_id,
            s.value,
            LAG(s.value) OVER (
                PARTITION BY s.dbid,
                             s.instance_number,
                             sn.startup_time,
                             s.stat_name
                ORDER BY s.snap_id
            ) AS prev_value
        FROM dba_hist_sysstat s
             JOIN dba_hist_snapshot sn
               ON sn.dbid            = s.dbid
              AND sn.instance_number = s.instance_number
              AND sn.snap_id         = s.snap_id
        WHERE s.stat_name       = 'session logical reads'
          AND s.dbid            = &dbid
          AND s.instance_number = &inst_num
          AND s.snap_id BETWEEN &snap_begin AND &snap_end
    )
    WHERE snap_id > &snap_begin
),
seg_io AS (
    SELECT
        o.owner,
        o.object_name,
        SUM(s.logical_reads_delta) AS obj_logical_reads
    FROM dba_hist_seg_stat s
         JOIN dba_hist_seg_stat_obj o
           ON o.dbid     = s.dbid
          AND o.ts#      = s.ts#
          AND o.obj#     = s.obj#
          AND o.dataobj# = s.dataobj#
    WHERE s.snap_id >  &snap_begin
      AND s.snap_id <= &snap_end
      AND s.dbid = &dbid
      AND s.instance_number = &inst_num
    GROUP BY
        o.owner,
        o.object_name
)
SELECT
    s.owner,
    s.object_name,
    s.obj_logical_reads AS logic_rd,
    t.total_reads,
    ROUND((s.obj_logical_reads / NULLIF(t.total_reads, 0)) * 100, 2) AS pct_impact
FROM seg_io s
CROSS JOIN sys_io t
ORDER BY s.obj_logical_reads DESC
FETCH FIRST 5 ROWS ONLY;
