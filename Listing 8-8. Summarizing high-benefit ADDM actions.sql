SELECT 
    SUBSTR(a.message, 1, 40) AS action_message,
    rec.type AS rec_type,
    COUNT(*) AS cnt,
    SUM(rec.benefit) AS total_benefit,
    MAX(rec.benefit) AS max_benefit
FROM   dba_advisor_recommendations rec
JOIN   dba_advisor_tasks t ON rec.task_id = t.task_id
JOIN   dba_advisor_actions a ON rec.task_id = a.task_id AND rec.rec_id = a.rec_id
WHERE  t.advisor_name = 'ADDM'
AND    t.execution_start >= SYSDATE - 7
GROUP BY SUBSTR(a.message, 1, 40), rec.type
ORDER BY total_benefit DESC
FETCH FIRST 4 ROWS ONLY;
