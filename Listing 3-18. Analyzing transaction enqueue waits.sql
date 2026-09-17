SELECT
    ash.sql_id,
    SUBSTR(t.sql_text, 1, 40) AS sql_text,
    SUBSTR(o.object_type, 1, 10) AS o_type,
    NVL(o.object_name, TO_CHAR(ash.current_obj#)) AS o_name,
    COUNT(*) AS sample_count
FROM
    v$active_session_history ash
    LEFT JOIN dba_objects o ON o.object_id = ash.current_obj#
    LEFT JOIN v$sqlstats t ON ash.sql_id = t.sql_id
WHERE
    ash.event LIKE 'enq: TX%' 
    AND ash.sample_time > SYSDATE - 10/(60*24)
GROUP BY
    ash.sql_id,
    SUBSTR(t.sql_text, 1, 40),
    SUBSTR(o.object_type, 1, 10),
    NVL(o.object_name, TO_CHAR(ash.current_obj#))
ORDER BY
    sample_count DESC;
