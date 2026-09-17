DEFINE dbid     = 2788912098
DEFINE inst_num = 1

SET pagesize 100

WITH stat_diff AS (
    SELECT
        dbid,
        snap_id,
        instance_number,
        begin_interval_time,
        stat_name,
        value - prev_value AS diff_value
    FROM (
        SELECT
            s.dbid,
            s.snap_id,
            s.instance_number,
            hsn.startup_time,
            hsn.begin_interval_time,
            s.stat_name,
            s.value,
            LAG(s.value) OVER (
                PARTITION BY s.dbid,
                             s.instance_number,
                             hsn.startup_time,
                             s.stat_name
                ORDER BY s.snap_id
            ) AS prev_value
        FROM dba_hist_sysstat s
        JOIN dba_hist_snapshot hsn
          ON hsn.dbid            = s.dbid
         AND hsn.instance_number = s.instance_number
         AND hsn.snap_id         = s.snap_id
        WHERE s.dbid            = &dbid
          AND s.instance_number = &inst_num
          AND hsn.begin_interval_time > SYSDATE - 1
          AND s.stat_name IN (
              'DB time',
              'CPU used by this session',
              'execute count',
              'parse time elapsed',
              'parse count (hard)',
              'physical reads',
              'physical writes',
              'redo size',
              'consistent gets',
              'user commits',
              'user rollbacks'
          )
    )
    WHERE prev_value IS NOT NULL
)
SELECT
    TO_CHAR(begin_interval_time, 'DD/MON HH24 MI') AS begin_time,
    SUM(CASE WHEN stat_name = 'DB time' THEN diff_value END) AS db_time,
    SUM(CASE WHEN stat_name = 'CPU used by this session'
             THEN diff_value END) AS cpu_time,
    SUM(CASE WHEN stat_name = 'execute count'
             THEN diff_value END) AS execute_count,
    SUM(CASE WHEN stat_name = 'parse time elapsed'
             THEN diff_value END) AS parse_time,
    SUM(CASE WHEN stat_name = 'parse count (hard)'
             THEN diff_value END) AS hard_parse_count,
    SUM(CASE WHEN stat_name = 'physical reads'
             THEN diff_value END) AS physical_reads,
    SUM(CASE WHEN stat_name = 'physical writes'
             THEN diff_value END) AS physical_writes,
    SUM(CASE WHEN stat_name = 'redo size'
             THEN diff_value END) AS redo_bytes,
    SUM(CASE WHEN stat_name = 'consistent gets'
             THEN diff_value END) AS logical_reads,
    SUM(CASE WHEN stat_name = 'user commits'
             THEN diff_value END) AS commits,
    SUM(CASE WHEN stat_name = 'user rollbacks'
             THEN diff_value END) AS rollbacks
FROM stat_diff
GROUP BY snap_id, begin_interval_time
ORDER BY snap_id;
