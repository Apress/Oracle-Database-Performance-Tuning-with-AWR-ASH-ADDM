SET LINESIZE 120
SET PAGESIZE 1000
COLUMN sample_id       FORMAT 99999999
COLUMN is_awr_sample   FORMAT A2
COLUMN sample_time     FORMAT A12
COLUMN session_id      FORMAT 99999
COLUMN session_state   FORMAT A8
COLUMN sql_id          FORMAT A13
COLUMN event           FORMAT A30

SELECT sample_id,
       is_awr_sample,
       TO_CHAR(sample_time, 'HH24:MI:SS.FF3') AS sample_time,
       session_id,
       session_state,
       sql_id,
       event
  FROM V$ACTIVE_SESSION_HISTORY
 WHERE sample_time > SYSDATE - 1 / 60 / 24;
