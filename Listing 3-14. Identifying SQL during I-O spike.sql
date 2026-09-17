SELECT
    ash.sql_id,
    SUBSTR(t.sql_text, 1, 40) AS sql_text,
    COUNT(*) AS sample_count
FROM
    dba_hist_active_sess_history ash
    LEFT JOIN v$sqlstats t ON ash.sql_id = t.sql_id
WHERE
    TRUNC(ash.sample_time, 'MI') = TRUNC(SYSDATE) + INTERVAL '10:21' HOUR TO MINUTE
    AND ash.wait_class = 'User I/O'
GROUP BY
    ash.sql_id,
    SUBSTR(t.sql_text, 1, 40)
ORDER BY
    sample_count DESC;
