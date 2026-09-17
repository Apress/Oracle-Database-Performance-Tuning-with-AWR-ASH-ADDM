SELECT 
    COUNT(session_id) AS impacted_sessions
FROM 
    dba_hist_active_sess_history
WHERE 
    sample_time BETWEEN TRUNC(SYSDATE - 1) + INTERVAL '12' HOUR AND TRUNC(SYSDATE - 1) + INTERVAL '13' HOUR
    AND event = 'log file sync';
