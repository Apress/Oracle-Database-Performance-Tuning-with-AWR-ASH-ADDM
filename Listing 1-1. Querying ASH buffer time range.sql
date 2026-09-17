SELECT TO_CHAR(oldest_sample_time, 'MM-DD HH24:MI:SS') AS start_time,
       TO_CHAR(latest_sample_time, 'MM-DD HH24:MI:SS') AS end_time
FROM   v$ash_info
UNION ALL
SELECT TO_CHAR(MIN(sample_time), 'MM-DD HH24:MI:SS'),
       TO_CHAR(MAX(sample_time), 'MM-DD HH24:MI:SS')
FROM   v$active_session_history;
