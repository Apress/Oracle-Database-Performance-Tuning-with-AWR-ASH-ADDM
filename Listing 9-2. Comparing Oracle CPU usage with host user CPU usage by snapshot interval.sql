WITH oracle_cpu AS (
    SELECT s.snap_id,
           s.instance_number,
           s.startup_time,
           SUM(tm.value) / 1000000 AS oracle_cpu_s
    FROM dba_hist_sys_time_model tm
    JOIN dba_hist_snapshot s
      ON s.dbid = tm.dbid
     AND s.instance_number = tm.instance_number
     AND s.snap_id = tm.snap_id
    WHERE tm.dbid = 2788912098
      AND tm.instance_number = 1
      AND tm.stat_name IN ('background cpu time', 'DB CPU')
    GROUP BY s.snap_id, s.instance_number, s.startup_time
),
os_cpu AS (
    SELECT s.snap_id,
           s.instance_number,
           s.startup_time,
           os.value / 100 AS os_user_cpu_s
    FROM dba_hist_osstat os
    JOIN dba_hist_snapshot s
      ON s.dbid = os.dbid
     AND s.instance_number = os.instance_number
     AND s.snap_id = os.snap_id
    WHERE os.dbid = 2788912098
      AND os.instance_number = 1
      AND os.stat_name = 'USER_TIME'
),
interval_cpu AS (
    SELECT o.snap_id,
           o.oracle_cpu_s
             - LAG(o.oracle_cpu_s) OVER (
                   PARTITION BY o.instance_number, o.startup_time
                   ORDER BY o.snap_id) AS oracle_cpu_delta_s,
           h.os_user_cpu_s
             - LAG(h.os_user_cpu_s) OVER (
                   PARTITION BY h.instance_number, h.startup_time
                   ORDER BY h.snap_id) AS os_user_cpu_delta_s
    FROM oracle_cpu o
    JOIN os_cpu h
      ON h.snap_id = o.snap_id
     AND h.instance_number = o.instance_number
     AND h.startup_time = o.startup_time
)
SELECT snap_id,
       ROUND(oracle_cpu_delta_s, 2) AS oracle_cpu_s,
       ROUND(os_user_cpu_delta_s, 2) AS os_user_cpu_s,
       ROUND(os_user_cpu_delta_s - oracle_cpu_delta_s, 2) AS gap_s,
       CASE
           WHEN os_user_cpu_delta_s > 0
           THEN ROUND((os_user_cpu_delta_s - oracle_cpu_delta_s)
                      / os_user_cpu_delta_s * 100, 2)
           ELSE 0
       END AS gap_percentage
FROM interval_cpu
WHERE oracle_cpu_delta_s IS NOT NULL
  AND os_user_cpu_delta_s IS NOT NULL
ORDER BY snap_id DESC;
