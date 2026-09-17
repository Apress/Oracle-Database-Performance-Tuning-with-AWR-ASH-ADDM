SET PAGESIZE 100

DEFINE dbid     = 2788912098
DEFINE inst_num = 1

SELECT
    TO_CHAR(begin_time, 'MM-DD HH24:MI:SS') AS start_time,
    ROUND(intsize / 100, 0) AS interval_sec,
    value
FROM
    dba_hist_sysmetric_history
WHERE
    snap_id = 50694
    AND metric_name = 'Logons Per Sec'
    AND dbid = &dbid
    AND instance_number = &inst_num
ORDER BY
    begin_time;
