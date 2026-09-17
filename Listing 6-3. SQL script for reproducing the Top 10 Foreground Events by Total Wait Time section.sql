DEFINE beg_snap = 5579;
DEFINE end_snap = 5580;
col Waits format 999,999,999,999,999
col "Total Wait Time (sec)" format 999,999,999,999,999
set linesize 200
col  Event format a40
set pagesize 100
col "Wait Class" form a20
set verify off

WITH cputime_and_dbtime AS (
  SELECT
    (SELECT SUM(e.VALUE - b.value) AS diff_value
       FROM dba_hist_sys_time_model b,
            dba_hist_sys_time_model e
      WHERE e.dbid = b.dbid
        AND e.instance_number = b.instance_number
        AND e.STAT_ID = b.STAT_ID
        AND b.dbid = (SELECT dbid FROM v$database)
        AND b.instance_number = (SELECT instance_number FROM v$instance)
        AND b.snap_id = &beg_snap
        AND e.snap_id = &end_snap
        AND e.stat_name = 'DB CPU') AS cputime,
    (SELECT SUM(e.VALUE - b.value) AS diff_value
       FROM dba_hist_sys_time_model b,
            dba_hist_sys_time_model e
      WHERE e.dbid = b.dbid
        AND e.instance_number = b.instance_number
        AND e.STAT_ID = b.STAT_ID
        AND b.dbid = (SELECT dbid FROM v$database)
        AND b.instance_number = (SELECT instance_number FROM v$instance)
        AND b.snap_id = &beg_snap
        AND e.snap_id = &end_snap
        AND e.stat_name = 'DB time') AS dbtime
  FROM dual
)
SELECT event AS "Event",
       wait_count AS "Waits",
       ROUND(wait_time_seconds, 2) AS "Total Wait Time (sec)",
       ROUND(avg_wait_ms, 2) AS "Avg Wait (ms)",
       ROUND(pct_db_time, 2) AS "% DB Time",
       wait_class AS "Wait Class"
  FROM (
    SELECT event,
           wait_count,
           wait_time_microseconds / 1000000 AS wait_time_seconds,
           DECODE(wait_count, 0, NULL, wait_time_microseconds / wait_count) / 1000 AS avg_wait_ms,
           DECODE((SELECT dbtime FROM cputime_and_dbtime), 0, NULL, wait_time_microseconds / (SELECT dbtime FROM cputime_and_dbtime)) * 100 AS pct_db_time,
           wait_class
      FROM (
        SELECT event_name AS event,
               CASE
                 WHEN total_waits_fg IS NOT NULL THEN total_waits_fg - NVL(prev_total_waits_fg, 0)
                 ELSE (total_waits - NVL(prev_total_waits, 0)) - GREATEST(0, (NVL(bg_total_waits, 0) - NVL(prev_bg_total_waits, 0)))
               END AS wait_count,
               CASE
                 WHEN time_waited_micro_fg IS NOT NULL THEN time_waited_micro_fg - NVL(prev_time_waited_micro_fg, 0)
                 ELSE (time_waited_micro - NVL(prev_time_waited_micro, 0)) - GREATEST(0, (NVL(bg_time_waited_micro, 0) - NVL(prev_bg_time_waited_micro, 0)))
               END AS wait_time_microseconds,
               wait_class
          FROM (
            SELECT e.event_name,
                   b.total_waits prev_total_waits,
                   b.total_waits_fg AS prev_total_waits_fg,
                   b.time_waited_micro AS prev_time_waited_micro,
                   b.time_waited_micro_fg AS prev_time_waited_micro_fg,
                   e.total_waits,
                   e.total_waits_fg,
                   e.time_waited_micro,
                   e.time_waited_micro_fg,
                   bg.total_waits AS bg_total_waits,
                   bg.time_waited_micro AS bg_time_waited_micro,
                   bg_prev.total_waits AS prev_bg_total_waits,
                   bg_prev.time_waited_micro AS prev_bg_time_waited_micro,
                   e.wait_class
              FROM dba_hist_system_event b,
                   dba_hist_system_event e,
                   dba_hist_bg_event_summary bg_prev,
                   dba_hist_bg_event_summary bg
             WHERE b.snap_id(+) = &beg_snap
               AND e.dbid= (SELECT dbid FROM v$database)
               AND e.snap_id = &end_snap
               AND bg_prev.snap_id(+) = &beg_snap
               AND bg.snap_id(+) = &end_snap
               AND e.instance_number = (SELECT instance_number FROM v$instance)
               AND e.dbid = b.dbid(+)
               AND e.instance_number = b.instance_number(+)
               AND e.event_id = b.event_id(+)
               AND e.dbid = bg.dbid(+)
               AND e.instance_number = bg.instance_number(+)
               AND e.event_id = bg.event_id(+)
               AND e.dbid = bg_prev.dbid(+)
               AND e.instance_number = bg_prev.instance_number(+)
               AND e.event_id = bg_prev.event_id(+)
               AND e.total_waits > NVL(b.total_waits, 0)
               AND e.wait_class <> 'Idle'
            UNION ALL
            SELECT 'DB CPU' AS event_name,
                   NULL AS prev_total_waits,
                   NULL AS prev_total_waits_fg,
                   NULL AS prev_time_waited_micro,
                   NULL AS prev_time_waited_micro_fg,
                   NULL AS total_waits,
                   NULL AS total_waits_fg,
                   (SELECT cputime FROM cputime_and_dbtime) AS time_waited_micro,
                   (SELECT cputime FROM cputime_and_dbtime) AS time_waited_micro_fg,
                   NULL AS bg_total_waits,
                   NULL AS bg_time_waited_micro,
                   NULL AS prev_bg_total_waits,
                   NULL AS prev_bg_time_waited_micro,
                   ' ' AS wait_class
              FROM dual
             WHERE (SELECT cputime FROM cputime_and_dbtime) > 0
          )
         ORDER BY wait_time_microseconds DESC, wait_count DESC
      )
     WHERE ROWNUM <= 10
  );
