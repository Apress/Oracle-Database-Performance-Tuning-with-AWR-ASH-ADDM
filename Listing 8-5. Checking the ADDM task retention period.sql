SELECT parameter_name, 
       parameter_value, 
       is_default, 
       count(*) 
FROM   dba_advisor_parameters 
WHERE  task_name LIKE 'ADDM:%' 
AND    parameter_name LIKE 'DAYS_TO_EXPIRE' 
GROUP BY parameter_name, parameter_value, is_default, description, is_modifiable_anytime, execution_type;
