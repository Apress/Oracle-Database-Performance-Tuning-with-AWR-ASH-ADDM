SELECT
    ash.sql_id          AS SQL_ID,
    SUM(DECODE(ash.wait_class, NULL, 1, 0))          AS CPU,
    SUM(DECODE(ash.wait_class, 'User I/O', 1, 0))    AS USR_IO,
    SUM(DECODE(ash.wait_class, 'System I/O', 1, 0))  AS SYS_IO,
    SUM(DECODE(ash.wait_class, 'Commit', 1, 0))      AS CMT,
    SUM(DECODE(ash.wait_class, 'Network', 1, 0))     AS NET,
    SUM(DECODE(ash.wait_class, 'Concurrency', 1, 0)) AS CON,
    SUM(DECODE(ash.wait_class, 'Application', 1, 0)) AS APP,
    SUM(DECODE(ash.wait_class, 'Configuration', 1, 0)) AS CFG,
    SUM(DECODE(ash.wait_class, 'Administrative', 1, 0)) AS ADM,
    SUM(DECODE(ash.wait_class, 'Other', 1, 0))       AS OTH,
    SUM(DECODE(ash.wait_class, 'Idle', 1, 0))        AS IDL,
    COUNT(*)                                         AS SMP,
    SUBSTR(t.sql_text, 1, 40)                        AS SQL_TEXT
FROM
    v$active_session_history ash
    LEFT JOIN v$sqlstats t ON ash.sql_id = t.sql_id
WHERE
    ash.sample_time > SYSDATE - 10/(60*24)
    AND ash.sql_id IS NOT NULL
GROUP BY
    ash.sql_id,
    SUBSTR(t.sql_text, 1, 40)
ORDER BY
    SMP DESC
FETCH FIRST 5 ROWS ONLY;
