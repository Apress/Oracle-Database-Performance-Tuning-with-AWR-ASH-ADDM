SELECT  
    TRIM(TO_CHAR(sample_time, 'DAY')) AS sample_day,
    SUM(CASE WHEN sql_id = 'ak9twwhh104uw' THEN 1 ELSE 0 END) AS id_ak9twwhh104uw,
    SUM(CASE WHEN sql_id = '8vmu6k690g87k' THEN 1 ELSE 0 END) AS id_8vmu6k690g87k,
    SUM(CASE WHEN sql_id = 'g7hczna7rus03' THEN 1 ELSE 0 END) AS id_g7hczna7rus03,
    SUM(CASE WHEN sql_id = '5987uswa9cjx4' THEN 1 ELSE 0 END) AS id_5987uswa9cjx4,
    SUM(CASE WHEN sql_id = '2zkxp8panuwxv' THEN 1 ELSE 0 END) AS id_2zkxp8panuwxv
FROM
    dba_hist_active_sess_history 
WHERE
    sample_time BETWEEN TRUNC(SYSDATE - 7) AND TRUNC(SYSDATE)
GROUP BY
    sample_day
ORDER BY
    CASE TRIM(TO_CHAR(sample_time, 'DAY'))
        WHEN 'MONDAY' THEN 1
        WHEN 'TUESDAY' THEN 2
        WHEN 'WEDNESDAY' THEN 3
        WHEN 'THURSDAY' THEN 4
        WHEN 'FRIDAY' THEN 5
        WHEN 'SATURDAY' THEN 6
        WHEN 'SUNDAY' THEN 7
    END;
