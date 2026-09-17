SELECT
    NVL(o.object_name, 'NOT APPLICABLE') AS object_name,
    NVL(o.object_type, 'NOT APPLICABLE') AS object_type,
    COUNT(*) AS total_accesses,
    TO_CHAR(100 * TRUNC(RATIO_TO_REPORT(COUNT(*)) OVER (), 6), 'FM990.9999') || '%' AS "%"
FROM
    v$active_session_history a
    LEFT JOIN dba_objects o ON a.current_obj# = o.object_id
WHERE
    a.sample_time > SYSDATE - 30 / 60 / 24
GROUP BY
    o.object_name,
    o.object_type
ORDER BY
    total_accesses DESC
FETCH FIRST 10 ROWS ONLY;
