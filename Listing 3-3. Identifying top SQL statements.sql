SELECT
    a.sql_id,
    COUNT(*) AS cnt,
    TO_CHAR(100 * TRUNC(RATIO_TO_REPORT(COUNT(*)) OVER (), 4), 'FM990.99') || '%' AS "%",
    SUBSTR(t.sql_text, 1, 40) AS sql_text
FROM
    v$active_session_history a
    LEFT JOIN v$sqlstats t ON a.sql_id = t.sql_id
WHERE
    sample_time > SYSDATE - 30 / 60 / 24
    AND a.sql_id IS NOT NULL
GROUP BY
    a.sql_id,
    SUBSTR(t.sql_text, 1, 40)
HAVING
    COUNT(*) > 5
ORDER BY
    cnt DESC
FETCH FIRST 10 ROWS ONLY;
