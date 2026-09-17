SET VERIFY OFF

DEFINE beg_snap = 5579;
DEFINE end_snap = 5580;

COLUMN short_name FORMAT a30 HEADING 'Load Profile';
COLUMN per_sec    FORMAT 999,999,999.99 HEADING 'Per Second';
COLUMN per_tx     FORMAT 999,999,999.99 HEADING 'Per Transaction';

SET PAGESIZE 200;

WITH db_info AS (
    SELECT
        (SELECT dbid FROM v$database) AS db_id,
        (SELECT instance_number FROM v$instance) AS instance_number
    FROM dual
),
st_list_mod AS (
    SELECT 'DB time' stat_name, 'DB Time(s):' short_name, 1 st_order FROM dual
    UNION ALL
    SELECT 'DB CPU' stat_name, 'DB CPU(s):' short_name, 2 st_order FROM dual
    UNION ALL
    SELECT 'background cpu time' stat_name, 'Background CPU(s):' short_name, 3 st_order FROM dual
),
st_list_sys AS (
    SELECT 'redo size' stat_name, 'Redo size (bytes):' short_name, 4 st_order FROM dual
    UNION ALL
    SELECT 'session logical reads' stat_name, 'Logical reads (blocks):' short_name, 5 st_order FROM dual
    UNION ALL
    SELECT 'db block changes' stat_name, 'Block changes:' short_name, 6 st_order FROM dual
    UNION ALL
    SELECT 'physical reads' stat_name, 'Physical reads: (blocks)' short_name, 7 st_order FROM dual
    UNION ALL
    SELECT 'physical writes' stat_name, 'Physical writes: (blocks)' short_name, 8 st_order FROM dual
    UNION ALL
    SELECT 'physical read IO requests' stat_name, 'Read IO requests:' short_name, 9 st_order FROM dual
    UNION ALL
    SELECT 'physical write IO requests' stat_name, 'Write IO requests:' short_name, 10 st_order FROM dual
    UNION ALL
    SELECT 'physical read bytes' stat_name, 'Read IO (MB):' short_name, 11 st_order FROM dual
    UNION ALL
    SELECT 'physical write bytes' stat_name, 'Write IO (MB):' short_name, 12 st_order FROM dual
    UNION ALL
    SELECT 'IM scan rows' stat_name, 'IM scan rows:' short_name, 13 st_order FROM dual
    UNION ALL
    SELECT 'session logical reads - IM' stat_name, 'Session Logical Reads IM:' short_name, 14 st_order FROM dual
    UNION ALL
    SELECT 'user calls' stat_name, 'User calls:' short_name, 15 st_order FROM dual
    UNION ALL
    SELECT 'parse count (total)' stat_name, 'Parses:' short_name, 16 st_order FROM dual
    UNION ALL
    SELECT 'parse count (hard)' stat_name, 'Hard Parses:' short_name, 17 st_order FROM dual
    UNION ALL
    SELECT 'logons cumulative' stat_name, 'Logons:' short_name, 19 st_order FROM dual
    UNION ALL
    SELECT 'user logons cumulative' stat_name, 'User Logons:' short_name, 20 st_order FROM dual
    UNION ALL
    SELECT 'execute count' stat_name, 'Executes:' short_name, 21 st_order FROM dual
    UNION ALL
    SELECT 'user rollbacks' stat_name, 'Rollbacks:' short_name, 22 st_order FROM dual
),
elp_time AS (
    SELECT
        EXTRACT(DAY FROM e.end_interval_time - b.end_interval_time) * 86400
        + EXTRACT(HOUR FROM e.end_interval_time - b.end_interval_time) * 3600
        + EXTRACT(MINUTE FROM e.end_interval_time - b.end_interval_time) * 60
        + EXTRACT(SECOND FROM e.end_interval_time - b.end_interval_time) AS d_elp_time
    FROM dba_hist_snapshot b, dba_hist_snapshot e, db_info sn
    WHERE e.snap_id = &end_snap
      AND b.snap_id = &beg_snap
      AND b.dbid = sn.db_id
      AND b.instance_number = sn.instance_number
      AND e.dbid = sn.db_id
      AND e.instance_number = sn.instance_number
),
e_trx_val AS (
    SELECT SUM(VALUE) AS end_val
    FROM dba_hist_sysstat e, db_info sn
    WHERE e.snap_id = &end_snap
      AND e.dbid = sn.db_id
      AND e.instance_number = sn.instance_number
      AND e.stat_name IN ('user rollbacks', 'user commits')
),
b_trx_val AS (
    SELECT SUM(VALUE) AS bgn_val
    FROM dba_hist_sysstat b, db_info sn
    WHERE b.snap_id = &beg_snap
      AND b.dbid = sn.db_id
      AND b.instance_number = sn.instance_number
      AND b.stat_name IN ('user rollbacks', 'user commits')
),
trx_val AS (
    SELECT end_val - bgn_val AS usr_val
    FROM e_trx_val, b_trx_val
),
beg_value_mod AS (
    SELECT /*+ use_hash(s) */
        b.short_name, a.stat_name, a.VALUE, b.st_order
    FROM dba_hist_sys_time_model a, st_list_mod b, db_info sn
    WHERE a.stat_name = b.stat_name
      AND a.snap_id = &beg_snap
      AND a.dbid = sn.db_id
      AND a.instance_number = sn.instance_number
),
beg_value_sys AS (
    SELECT /*+ use_hash(s) */
        b.short_name, a.stat_name, a.VALUE, b.st_order
    FROM dba_hist_sysstat a, st_list_sys b, db_info sn
    WHERE a.stat_name = b.stat_name
      AND a.snap_id = &beg_snap
      AND a.dbid = sn.db_id
      AND a.instance_number = sn.instance_number
),
beg_workarea AS (
    SELECT 'SQL Work Area (MB):' short_name, 'SQL Work Area (MB):' stat_name, BYTES_PROCESSED VALUE, 18 st_order
    FROM wrh$_pga_target_advice a, db_info sn
    WHERE a.PGA_TARGET_FACTOR = 1
      AND a.snap_id = &beg_snap
      AND a.dbid = sn.db_id
      AND a.instance_number = sn.instance_number
),
end_workarea AS (
    SELECT 'SQL Work Area (MB):' short_name, 'SQL Work Area (MB):' stat_name, BYTES_PROCESSED VALUE, 18 st_order
    FROM wrh$_pga_target_advice a, db_info sn
    WHERE a.PGA_TARGET_FACTOR = 1
      AND a.snap_id = &end_snap
      AND a.dbid = sn.db_id
      AND a.instance_number = sn.instance_number
),
end_value_mod AS (
    SELECT /*+ use_hash(s) */
        b.short_name, a.stat_name, a.VALUE, b.st_order
    FROM dba_hist_sys_time_model a, st_list_mod b, db_info sn
    WHERE a.stat_name = b.stat_name
      AND a.snap_id = &end_snap
      AND a.dbid = sn.db_id
      AND a.instance_number = sn.instance_number
),
end_value_sys AS (
    SELECT /*+ use_hash(s) */
        b.short_name, a.stat_name, a.VALUE, b.st_order
    FROM dba_hist_sysstat a, st_list_sys b, db_info sn
    WHERE a.stat_name = b.stat_name
      AND a.snap_id = &end_snap
      AND a.dbid = sn.db_id
      AND a.instance_number = sn.instance_number
)
SELECT short_name, per_sec, per_tx
FROM (
    SELECT e.short_name,
           ROUND((e.VALUE - b.VALUE) / 1000000 / (SELECT d_elp_time FROM elp_time), 2) AS per_sec,
           ROUND((e.VALUE - b.VALUE) / 1000000 / (SELECT usr_val FROM trx_val), 2) AS per_tx,
           e.st_order
    FROM beg_value_mod b, end_value_mod e
    WHERE e.stat_name = b.stat_name
      AND e.st_order = b.st_order
    UNION ALL
    SELECT e.short_name,
           CASE
               WHEN e.st_order IN (11, 12) THEN
                   ROUND((e.VALUE - b.VALUE) / (SELECT d_elp_time FROM elp_time) / 1024 / 1024, 2)
               ELSE
                   ROUND((e.VALUE - b.VALUE) / (SELECT d_elp_time FROM elp_time), 2)
           END AS per_sec,
           CASE
               WHEN e.st_order IN (11, 12) THEN
                   ROUND((e.VALUE - b.VALUE) / (SELECT usr_val FROM trx_val) / 1024 / 1024, 2)
               ELSE
                   ROUND((e.VALUE - b.VALUE) / (SELECT usr_val FROM trx_val), 2)
           END AS per_tx,
           e.st_order
    FROM beg_value_sys b, end_value_sys e
    WHERE e.stat_name = b.stat_name
      AND e.st_order = b.st_order
    UNION ALL
    SELECT e.short_name,
           ROUND((e.VALUE - b.VALUE) / 1024 / 1024 / (SELECT d_elp_time FROM elp_time), 2) AS per_sec,
           ROUND((e.VALUE - b.VALUE) / 1024 / 1024 / (SELECT usr_val FROM trx_val), 2) AS per_tx,
           e.st_order
    FROM beg_workarea b, end_workarea e
    UNION ALL
    SELECT 'Transactions:',
           ROUND(usr_val / (SELECT d_elp_time FROM elp_time), 2),
           NULL,
           23
    FROM trx_val
)
ORDER BY st_order;
