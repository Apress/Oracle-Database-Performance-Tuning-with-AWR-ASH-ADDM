SELECT 
    totalAS,
    TRUNC(oncpu / totalAS * 100, 2) AS "CPU%",
    TRUNC(userIO / totalAS * 100, 2) AS "User IO%",
    TRUNC(sysIO / totalAS * 100, 2) AS "System IO%",
    TRUNC((waiting - userIO - sysIO) / totalAS * 100, 2) AS "Other%"
FROM (
    SELECT 
        COUNT(*) AS totalAS,
        SUM(DECODE(session_state, 'ON CPU', 1, 0)) AS oncpu,
        SUM(DECODE(session_state, 'WAITING', 1, 0)) AS waiting,
        SUM(DECODE(session_state, 'WAITING', DECODE(wait_class, 'User I/O', 1, 0))) AS userIO,
        SUM(DECODE(session_state, 'WAITING', DECODE(wait_class, 'System I/O', 1, 0))) AS sysIO
    FROM 
        DBA_HIST_ACTIVE_SESS_HISTORY
    WHERE 
        sample_time BETWEEN TRUNC(SYSDATE) - 1 + INTERVAL '12' HOUR
        AND TRUNC(SYSDATE) - 1 + INTERVAL '13' HOUR
) a;
