SELECT
    blocking_session || ':' || blocking_session_serial# || '@' || blocking_inst_id AS blocking_sess,
    blocking_session_status,
    COUNT(*)
FROM dba_hist_active_sess_history
WHERE
    blocking_session_status = 'VALID' AND
    blocking_session IS NOT NULL AND
    sample_time BETWEEN TRUNC(SYSDATE) + INTERVAL '0 00:00:00' DAY TO SECOND
                    AND TRUNC(SYSDATE) + INTERVAL '0 02:00:00' DAY TO SECOND AND
    event IN ('log file switch completion', 'log file sync')
GROUP BY
    blocking_session || ':' || blocking_session_serial# || '@' || blocking_inst_id,
    blocking_session_status
ORDER BY
    COUNT(*);
