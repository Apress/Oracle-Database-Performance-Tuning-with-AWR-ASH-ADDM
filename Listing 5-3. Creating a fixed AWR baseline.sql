BEGIN
    DBMS_WORKLOAD_REPOSITORY.CREATE_BASELINE (
        start_snap_id => 1630,
        end_snap_id   => 1632,
        baseline_name => 'Normal Workload Baseline'
    );
END;
/
