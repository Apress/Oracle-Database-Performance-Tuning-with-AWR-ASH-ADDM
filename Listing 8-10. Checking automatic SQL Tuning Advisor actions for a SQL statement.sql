SELECT 
    act.object_id,
    TO_CHAR(e.execution_start, 'Mon-DD HH24:MI') AS exec_start,
    act.command,
    act.attr1,
    act.attr2,
    act.attr3,
    act.attr4
FROM 
    dba_advisor_tasks t
    JOIN dba_advisor_executions e ON t.task_id = e.task_id
    JOIN dba_advisor_objects o ON t.task_id = o.task_id AND e.execution_name = o.execution_name
    JOIN dba_advisor_actions act ON t.task_id = act.task_id AND o.object_id=act.object_id
WHERE 
    t.task_name = 'SYS_AUTO_SQL_TUNING_TASK'
    AND o.attr1 = 'bgr44tq5qd12w'
ORDER BY 
    e.execution_start DESC;
