SELECT name,
       detected_usages,
       currently_used,
       TO_CHAR(last_sample_date, 'DD-MON:HH24:MI') AS last_sample
FROM   dba_feature_usage_statistics
WHERE  name LIKE 'AWR%'
   OR  name LIKE '%ADDM%';
