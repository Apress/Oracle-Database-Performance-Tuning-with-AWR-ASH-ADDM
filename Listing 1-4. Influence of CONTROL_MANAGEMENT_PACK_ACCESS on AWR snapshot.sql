SELECT b.snap_id,
       COUNT(a.sample_id) AS sample_count
FROM   dba_hist_snapshot b
       LEFT JOIN dba_hist_active_sess_history a
              ON b.snap_id = a.snap_id
WHERE  b.snap_id = (SELECT MAX(snap_id) FROM dba_hist_snapshot)
GROUP BY b.snap_id;
