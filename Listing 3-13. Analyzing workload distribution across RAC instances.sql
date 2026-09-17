SELECT
    s.service_name,
    h.instance_number,
    COUNT(*) AS total_samples,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS total_cluster_percentage,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY s.service_name), 2) AS service_distribution_percentage
FROM
    dba_hist_active_sess_history h
    LEFT JOIN dba_hist_service_name s ON h.service_hash = s.service_name_hash AND h.dbid = s.dbid
WHERE
    h.sample_time >= TRUNC(SYSDATE)
GROUP BY
    s.service_name,
    h.instance_number
ORDER BY
    s.service_name,
    h.instance_number;
