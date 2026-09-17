SELECT  
    TO_CHAR(TRUNC(sample_time, 'HH'), 'HH24') AS sample_hour,
    COUNT(*) AS sum_activity,
    SUM(DECODE(wait_class, NULL, 1, 0)) AS CPU,
    SUM(DECODE(wait_class, 'User I/O', 1, 0)) AS user_io,
    SUM(DECODE(wait_class, 'System I/O', 1, 0)) AS system_io,
    SUM(DECODE(wait_class, 'Commit', 1, 0)) AS commit,
    SUM(DECODE(wait_class, 'Network', 1, 0)) AS network,
    SUM(DECODE(wait_class, 'Concurrency', 1, 0)) AS concurrency,
    SUM(DECODE(wait_class, 'Application', 1, 0)) AS application,
    SUM(DECODE(wait_class, 'Configuration', 1, 0)) AS configuration,
    SUM(DECODE(wait_class, 'Administrative', 1, 0)) AS administrative,
    SUM(DECODE(wait_class, 'Other', 1, 0)) AS other,
    SUM(DECODE(wait_class, 'Idle', 1, 0)) AS idle
FROM
    dba_hist_active_sess_history 
WHERE
    sample_time BETWEEN TRUNC(SYSDATE - 1) AND TRUNC(SYSDATE)
GROUP BY
    TRUNC(sample_time, 'HH')
ORDER BY 1;
