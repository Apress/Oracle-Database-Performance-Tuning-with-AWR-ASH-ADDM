SELECT
    instance_number,
    program,
    event,
    blocking_session || ':' || blocking_session_serial# || '@' || blocking_inst_id AS blocking_sess,
    blocking_session_status,
    COUNT(*)
FROM
    dba_hist_active_sess_history
WHERE
    SESSION_ID = 3367 AND
    SESSION_SERIAL# = 1 AND
    sample_time BETWEEN TRUNC(SYSDATE) + INTERVAL '0 00:00:00' DAY TO SECOND
                    AND TRUNC(SYSDATE) + INTERVAL '0 02:00:00' DAY TO SECOND
GROUP BY
    instance_number,
    program,
    event,
    blocking_session || ':' || blocking_session_serial# || '@' || blocking_inst_id,
    blocking_session_status
ORDER BY
    COUNT(*);
