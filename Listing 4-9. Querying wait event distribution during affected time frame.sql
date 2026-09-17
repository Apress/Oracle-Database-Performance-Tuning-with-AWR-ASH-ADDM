SELECT
    NVL(event, 'ON CPU') AS event,
    NVL(wait_class, 'CPU') AS wait_class,
    COUNT(*) AS total_wait_time,
    TO_CHAR(100 * TRUNC(RATIO_TO_REPORT(COUNT(*)) OVER (), 6), 'FM990.9999') || '%' AS "%"
FROM
    dba_hist_active_sess_history
WHERE
    sample_time BETWEEN TRUNC(SYSDATE) + INTERVAL '0 00:00:00' DAY TO SECOND
                    AND TRUNC(SYSDATE) + INTERVAL '0 02:00:00' DAY TO SECOND
GROUP BY
    event,
    wait_class
ORDER BY
    total_wait_time DESC
FETCH FIRST 10 ROWS ONLY;
