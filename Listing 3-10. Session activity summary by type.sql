SELECT
    ash.session_type,
    ash.session_state AS STATUS,
    DECODE(NVL(sql_id, '-1'), '-1', 'nonsql', 'sql') AS SQL_TYPE,
    COUNT(*) AS SESS_CNT,
    TO_CHAR(100 * TRUNC(RATIO_TO_REPORT(COUNT(*)) OVER (), 4), 'FM990.99') || '%' AS "%"
FROM v$active_session_history ash
WHERE sample_time > SYSDATE - 30 / 24 / 60
GROUP BY ash.session_type,
         ash.session_state,
         DECODE(NVL(sql_id, '-1'), '-1', 'nonsql', 'sql')
ORDER BY SESS_CNT DESC;
