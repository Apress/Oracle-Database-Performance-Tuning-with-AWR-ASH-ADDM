BEGIN
    DBMS_WORKLOAD_REPOSITORY.CREATE_BASELINE_TEMPLATE (
        start_time    => TO_DATE('23-NOV-2029 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
        end_time      => TO_DATE('23-NOV-2029 23:59:59', 'DD-MON-YYYY HH24:MI:SS'),
        baseline_name => 'Black_Friday_2029',
        template_name => 'Black_Friday_2029',
        expiration    => NULL
    );
END;
/
