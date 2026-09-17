SELECT
    ob.owner,
    ob.object_name,
    ob.object_type,
    ob.tablespace_name,
    ROUND(SUM(ss.space_used_delta) / 1024 / 1024 / 1024, 2) AS used_delta_gb
FROM
    dba_hist_seg_stat ss
    JOIN dba_hist_snapshot sp
      ON sp.dbid            = ss.dbid
     AND sp.instance_number = ss.instance_number
     AND sp.snap_id         = ss.snap_id
    JOIN dba_hist_seg_stat_obj ob
      ON ob.dbid       = ss.dbid
     AND ob.ts#        = ss.ts#
     AND ob.obj#       = ss.obj#
     AND ob.dataobj#   = ss.dataobj#
     AND NVL(ob.con_id, 0) = NVL(ss.con_id, 0)
WHERE
    sp.begin_interval_time > TRUNC(SYSDATE) - 7 
    AND sp.dbid = 2788912098
GROUP BY
    ss.dbid,
    ss.instance_number,
    ss.con_id,
    ss.ts#,
    ss.obj#,
    ob.owner,
    ob.object_name,
    ob.object_type,
    ob.tablespace_name
ORDER BY
    used_delta_gb DESC
FETCH FIRST 10 ROWS ONLY;
