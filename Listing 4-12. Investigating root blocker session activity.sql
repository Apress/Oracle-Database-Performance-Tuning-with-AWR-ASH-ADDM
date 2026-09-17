SELECT
    session_id || ':' || session_serial# || '@' || instance_number sess,
    program,
    event,
    blocking_session || ':' || blocking_session_serial# || '@' || blocking_inst_id AS blocking_sess,
    blocking_session_status,
    COUNT(*)
FROM
    dba_hist_active_sess_history
WHERE
    (
        (INSTANCE_NUMBER = 2 AND SESSION_ID = 6181 AND SESSION_SERIAL# = 29725)
        OR (INSTANCE_NUMBER = 1 AND SESSION_ID = 17754 AND SESSION_SERIAL# = 31107)
    )
    AND sample_time BETWEEN TRUNC(SYSDATE) + INTERVAL '0 00:00:00' DAY TO SECOND
                        AND TRUNC(SYSDATE) + INTERVAL '0 02:00:00' DAY TO SECOND
GROUP BY
    session_id || ':' || session_serial# || '@' || instance_number,
    program,
    event,
    blocking_session || ':' || blocking_session_serial# || '@' || blocking_inst_id,
    blocking_session_status
ORDER BY
    COUNT(*);
