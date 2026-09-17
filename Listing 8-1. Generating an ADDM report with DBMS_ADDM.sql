-- 1. Create variables for task name.
VAR tname VARCHAR2(40);

BEGIN
  :tname := 'ADDM_AFTERNOON_PEAK';
  
-- 2. Run ADDM for a specific snapshot range.
  DBMS_ADDM.ANALYZE_DB(
    task_name      => :tname,
    begin_snapshot => 3462, 
    end_snapshot   => 3463,
    db_id          => NULL -- Defaults to current DB
  );
END;
/

-- 3. Get the report as a CLOB.
SPOOL ADDM_AFTERNOON_PEAK
SET LONG 100000 PAGESIZE 0
SELECT DBMS_ADDM.GET_REPORT(:tname);
...
SPOOL OFF
