SELECT snap_id,
       consumer_group_name,
       cpu_wait_time,
       yields,
       consumed_cpu_time
FROM   dba_hist_rsrc_consumer_group
WHERE  snap_id BETWEEN 4914 AND 4915
ORDER BY snap_id;
