SELECT ob.owner, 
       ob.object_name,
       dbms_rowid.rowid_create(
           rowid_type => 1,
           object_number => ob.data_object_id,
           relative_fno => sh.current_file#,
           block_number => sh.current_block#,
           row_number => sh.current_row#
       ) AS row_id,
       COUNT(*) AS occurrence_count
  FROM dba_hist_active_sess_history sh
  JOIN dba_objects ob ON sh.current_obj# = ob.object_id
 WHERE sh.snap_id = 2226
   AND sh.event = 'enq: TX - row lock contention'
 GROUP BY ob.owner, 
          ob.object_name, 
          dbms_rowid.rowid_create(
              rowid_type => 1,
              object_number => ob.data_object_id,
              relative_fno => sh.current_file#,
              block_number => sh.current_block#,
              row_number => sh.current_row#
          )
 ORDER BY occurrence_count DESC;
