SELECT
    NVL(event, 'ON CPU') AS event,
    NVL(wait_class, 'CPU') AS wait_class,
    COUNT(*) AS total_wait_time,
    TO_CHAR(100 * TRUNC(RATIO_TO_REPORT(COUNT(*)) OVER (), 6), 'FM999.9999') AS "%"
FROM   dba_hist_active_sess_history a
WHERE  trunc(sample_time) = trunc(sysdate) - 1
AND    program LIKE '%rman%'
GROUP BY NVL(event, 'ON CPU'), NVL(wait_class, 'CPU')
ORDER BY TO_NUMBER(TO_CHAR(100 * TRUNC(RATIO_TO_REPORT(COUNT(*)) OVER (), 6), 'FM999.9999')) DESC;
