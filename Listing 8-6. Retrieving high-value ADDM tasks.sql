DEFINE back_days=30

SELECT a.task_name,
       TO_CHAR(c.execution_end, 'DD-MON HH24:MI:SS') AS exec_time,
       SUM(b.benefit) AS task_benefit,
       SUM(d.impact) AS task_impact
FROM   dba_advisor_tasks a
JOIN   dba_advisor_recommendations b ON a.task_id = b.task_id
JOIN   dba_advisor_executions c      ON a.task_id = c.task_id
JOIN   dba_advisor_findings d        ON a.task_id = d.task_id
WHERE  c.execution_end > SYSDATE - &back_days
AND    a.advisor_name = 'ADDM' 
AND    a.status = 'COMPLETED'
GROUP BY a.task_name, TO_CHAR(c.execution_end, 'DD-MON HH24:MI:SS')
ORDER BY task_benefit DESC, task_impact DESC
FETCH FIRST 5 ROWS ONLY;
