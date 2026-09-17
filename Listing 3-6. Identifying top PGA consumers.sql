SELECT username,
       module,
       sql_id,
       TRUNC(MAX(pga_allocated) / 1024 / 1024) AS pga_allocated_mb
FROM   v$active_session_history a,
       dba_users u
WHERE  a.sample_time > SYSDATE - 30 / 60 / 24
  AND  u.user_id = a.user_id
  AND  u.username NOT IN ('SYS', 'DBSNMP')
GROUP BY username, module, sql_id
ORDER BY pga_allocated_mb DESC
FETCH FIRST 10 ROWS ONLY;
