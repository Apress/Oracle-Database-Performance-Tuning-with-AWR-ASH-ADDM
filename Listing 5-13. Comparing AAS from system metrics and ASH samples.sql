SELECT TO_CHAR(M.end_time, 'MI:SS') AS end_time_mmss,
       ROUND(M.value / 100, 3) AS Metric_AAS,
       ROUND(SUM(DECODE(A.session_type, 'FOREGROUND', 1, 0)) /
             ((M.end_time - M.begin_time) * 86400), 3) AS ASH_AAS,
       COUNT(1) AS ASH_count
  FROM v$active_session_history A,
       v$sysmetric_history M
 WHERE A.sample_time BETWEEN M.begin_time AND M.end_time
   AND M.metric_name = 'Database Time Per Sec'
   AND M.group_id = 2
 GROUP BY TO_CHAR(M.end_time, 'MI:SS'),
          M.end_time,
          M.begin_time,
          M.value
 ORDER BY M.end_time;
