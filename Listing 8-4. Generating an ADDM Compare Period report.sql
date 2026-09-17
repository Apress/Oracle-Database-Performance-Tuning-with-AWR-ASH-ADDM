SET LONG 1000000 LONGCHUNKSIZE 1000000 LINESIZE 200 PAGESIZE 0 TRIM ON TRIMSPOOL ON

SPOOL addm_compare_db_report1.html

SELECT DBMS_ADDM.COMPARE_DATABASES(
   base_dbid          => '2788912098',
   base_begin_snap_id => 50640,
   base_end_snap_id   => 50641,
   comp_dbid          => '2788912098',
   comp_begin_snap_id => 50696,
   comp_end_snap_id   => 50697,
   report_type        => 'HTML') AS report
FROM dual;

SPOOL OFF;
