SELECT
    NVL(event, 'ON CPU') AS event,
    NVL(wait_class, 'CPU') AS wait_class,
    COUNT(*) AS total_sec,
    TO_CHAR(100 * TRUNC(RATIO_TO_REPORT(COUNT(*)) OVER (), 6), 'FM990.9999') || '%' AS "%"
FROM
    v$active_session_history
WHERE
    sample_time > SYSDATE - 30 / 60 / 24
GROUP BY
    event,
    wait_class
ORDER BY
    total_sec DESC
    fetch first 10 rows only;
