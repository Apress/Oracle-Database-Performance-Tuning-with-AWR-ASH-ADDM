SELECT
    NVL(s.machine, 'Unknown') AS machine,
    NVL(s.program, 'Unknown') AS program,
    NVL(s.module, 'Unknown') AS module,
    NVL(s.action, 'Unknown') AS action,
    COUNT(*) AS cnt,
    TO_CHAR(100 * TRUNC(RATIO_TO_REPORT(COUNT(*)) OVER (), 4), 'FM990.99') || '%' AS "%"
FROM
    v$active_session_history a
    LEFT JOIN v$session s ON a.session_id = s.sid
WHERE
    sample_time > SYSDATE - 30 / 60 / 24
GROUP BY
    s.machine,
    s.program,
    s.module,
    s.action
ORDER BY
    COUNT(*) DESC
FETCH FIRST 10 ROWS ONLY;
