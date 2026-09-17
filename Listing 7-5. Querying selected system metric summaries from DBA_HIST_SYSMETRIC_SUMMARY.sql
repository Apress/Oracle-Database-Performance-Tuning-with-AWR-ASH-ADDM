DEFINE dbid     = 2788912098
DEFINE inst_num = 1

SELECT
    s.snap_id,
    TO_CHAR(s.end_time, 'MM-DD HH24:MI:SS') AS end_time,
    ROUND(MAX(CASE
                  WHEN s.metric_name = 'Average Active Sessions'
                  THEN s.average
              END)) AS ActiveSession,
    ROUND(MAX(CASE
                  WHEN s.metric_name = 'Session Count'
                  THEN s.average
              END)) AS SessionCount,
    ROUND(MAX(CASE
                  WHEN s.metric_name = 'Host CPU Utilization (%)'
                  THEN s.average
              END)) AS CPUPct,
    ROUND(MAX(CASE
                  WHEN s.metric_name = 'I/O Megabytes per Second'
                  THEN s.average
              END)) AS IOMBSec,
    ROUND(MAX(CASE
                  WHEN s.metric_name = 'I/O Requests per Second'
                  THEN s.average
              END)) AS IOQRSec,
    ROUND(MAX(CASE
                  WHEN s.metric_name = 'Logical Reads Per Sec'
                  THEN s.average
              END)) AS LogReadSec,
    ROUND(MAX(CASE
                  WHEN s.metric_name = 'Network Traffic Volume Per Sec'
                  THEN s.average
              END)) AS NetSec,
    ROUND(MAX(CASE
                  WHEN s.metric_name = 'SQL Service Response Time'
                  THEN s.average * 10
              END), 2) AS ResponseMS
FROM
    dba_hist_sysmetric_summary s
WHERE
    s.end_time > SYSDATE - 1
    AND s.dbid = &dbid
    AND s.instance_number = &inst_num
    AND s.metric_name IN (
        'Average Active Sessions',
        'Session Count',
        'Host CPU Utilization (%)',
        'I/O Megabytes per Second',
        'I/O Requests per Second',
        'Logical Reads Per Sec',
        'Network Traffic Volume Per Sec',
        'SQL Service Response Time'
    )
GROUP BY
    s.snap_id,
    s.end_time
ORDER BY
    s.snap_id;
