SELECT 
    f.finding_name,
    f.type,
    MIN(f.impact) AS min_impact,
    MAX(f.impact) AS max_impact,
    COUNT(*) AS finding_count
FROM   dba_advisor_findings f
JOIN   dba_advisor_tasks t ON f.task_id = t.task_id
WHERE  t.advisor_name = 'ADDM'
AND    t.execution_start >= SYSDATE - 7
AND    f.impact_type IS NOT NULL
GROUP BY f.finding_name, f.type
ORDER BY max_impact DESC
FETCH FIRST 5 ROWS ONLY;
