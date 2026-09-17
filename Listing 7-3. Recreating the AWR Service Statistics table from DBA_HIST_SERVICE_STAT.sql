SET LINESIZE 200
SET PAGESIZE 100

DEFINE dbid       = 4250576883
DEFINE inst_num   = 1
DEFINE begin_snap = 5579
DEFINE end_snap   = 5580

COLUMN service_name     FORMAT A25          HEADING 'Service Name'
COLUMN db_time_s        FORMAT 999,999,990  HEADING 'DB Time (s)'
COLUMN db_cpu_s         FORMAT 999,999,990  HEADING 'DB CPU (s)'
COLUMN physical_reads_k FORMAT 999,999,990  HEADING 'Physical Reads (K)'
COLUMN logical_reads_k  FORMAT 999,999,990  HEADING 'Logical Reads (K)'

WITH stat_delta AS (
    SELECT
        s.service_name,
        NVL(MAX(CASE
                    WHEN s.snap_id = &end_snap
                     AND s.stat_name = 'DB time'
                    THEN s.value
                END), 0)
      - NVL(MAX(CASE
                    WHEN s.snap_id = &begin_snap
                     AND s.stat_name = 'DB time'
                    THEN s.value
                END), 0) AS db_time_us,
        NVL(MAX(CASE
                    WHEN s.snap_id = &end_snap
                     AND s.stat_name = 'DB CPU'
                    THEN s.value
                END), 0)
      - NVL(MAX(CASE
                    WHEN s.snap_id = &begin_snap
                     AND s.stat_name = 'DB CPU'
                    THEN s.value
                END), 0) AS db_cpu_us,
        NVL(MAX(CASE
                    WHEN s.snap_id = &end_snap
                     AND s.stat_name = 'physical reads'
                    THEN s.value
                END), 0)
      - NVL(MAX(CASE
                    WHEN s.snap_id = &begin_snap
                     AND s.stat_name = 'physical reads'
                    THEN s.value
                END), 0) AS physical_reads,
        NVL(MAX(CASE
                    WHEN s.snap_id = &end_snap
                     AND s.stat_name = 'session logical reads'
                    THEN s.value
                END), 0)
      - NVL(MAX(CASE
                    WHEN s.snap_id = &begin_snap
                     AND s.stat_name = 'session logical reads'
                    THEN s.value
                END), 0) AS logical_reads
    FROM dba_hist_service_stat s
         JOIN dba_hist_snapshot sn
           ON sn.dbid            = s.dbid
          AND sn.instance_number = s.instance_number
          AND sn.snap_id         = s.snap_id
    WHERE s.snap_id IN (&begin_snap, &end_snap)
      AND s.dbid            = &dbid
      AND s.instance_number = &inst_num
      AND s.stat_name IN (
          'DB time',
          'DB CPU',
          'physical reads',
          'session logical reads'
      )
    GROUP BY
        s.service_name
)
SELECT
    service_name,
    ROUND(db_time_us     / 1000000) AS db_time_s,
    ROUND(db_cpu_us      / 1000000) AS db_cpu_s,
    ROUND(physical_reads / 1000)    AS physical_reads_k,
    ROUND(logical_reads  / 1000)    AS logical_reads_k
FROM stat_delta
ORDER BY db_time_us DESC;
