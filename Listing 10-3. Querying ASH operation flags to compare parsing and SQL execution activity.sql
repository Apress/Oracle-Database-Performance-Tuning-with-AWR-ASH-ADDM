SELECT in_parse,
       in_hard_parse AS in_hard,
       in_sql_execution AS in_sql,
       COUNT(*) AS cnt,
       TRUNC(100 * RATIO_TO_REPORT(COUNT(*)) OVER (), 2) AS percent
FROM   dba_hist_active_sess_history
WHERE  dbid = 3622076449
AND    snap_id = 15612
AND    session_type = 'FOREGROUND'
GROUP  BY in_parse,
          in_hard_parse,
          in_sql_execution
ORDER  BY COUNT(*) DESC;
