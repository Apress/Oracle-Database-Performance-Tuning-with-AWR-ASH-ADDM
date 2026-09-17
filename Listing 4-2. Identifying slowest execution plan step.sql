SELECT 
       sql_plan_operation AS operation,
       sql_plan_options AS options,
       sql_plan_line_id AS line_id,
       b.object_name,
       NVL(event, 'ON CPU') AS event,
       COUNT(*) AS count
FROM 
       v$active_session_history a
LEFT JOIN
      cdb_objects b ON a.con_id=b.con_id AND a.current_obj#=b.object_id
WHERE 
      sql_id = 'gkxxkghxubh1a' 
      AND SQL_PLAN_HASH_VALUE=2692802960
      AND a.sample_time > SYSDATE - 1/24
GROUP BY sql_plan_operation,
         sql_plan_options,
         sql_plan_line_id,
         b.object_name,
         event
ORDER BY COUNT(*);
