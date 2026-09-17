SELECT snap_id,
       plan_name,
       cpu_managed
FROM   dba_hist_rsrc_plan
WHERE  snap_id = 4915
ORDER BY snap_id;
