SELECT 
    obj.attr1 AS sql_id,
    ROUND(MAX(rec.benefit) / 1000000, 2) AS max_benefit_sec,
    ROUND(MIN(rec.benefit) / 1000000, 2) AS min_benefit_sec,
    COUNT(*) AS cnt,
    TO_CHAR(MIN(t.execution_start), 'Mon-DD HH24:MI') AS first_seen,
    TO_CHAR(MAX(t.execution_start), 'Mon-DD HH24:MI') AS last_seen
FROM 
    dba_advisor_tasks t
    JOIN dba_addm_findings f 
      ON t.task_id = f.task_id
    JOIN dba_advisor_recommendations rec 
      ON f.task_id = rec.task_id 
     AND f.finding_id = rec.finding_id
    JOIN dba_advisor_actions act 
      ON rec.task_id = act.task_id 
     AND rec.rec_id = act.rec_id
    JOIN dba_advisor_objects obj 
      ON act.task_id = obj.task_id 
     AND act.object_id = obj.object_id
WHERE 
    t.advisor_name = 'ADDM'
    AND t.execution_start >= SYSDATE - 30
    AND f.finding_name = 'Top SQL Statements'
    AND obj.type = 'SQL'
GROUP BY 
    obj.attr1
ORDER BY 
    max_benefit_sec DESC
FETCH FIRST 3 ROWS ONLY;
