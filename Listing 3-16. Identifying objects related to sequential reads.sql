SELECT 
    o.owner, 
    o.object_name, 
    o.object_type, 
    COUNT(*) AS event_count
FROM 
    v$active_session_history ash
JOIN 
    dba_objects o ON ash.current_obj# = o.object_id
WHERE 
    ash.event = 'db file sequential read'
GROUP BY 
    o.owner, 
    o.object_name, 
    o.object_type
ORDER BY 
    event_count DESC;
