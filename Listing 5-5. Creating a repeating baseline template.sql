BEGIN
    DBMS_WORKLOAD_REPOSITORY.CREATE_BASELINE_TEMPLATE (
        day_of_week          => 'SUNDAY',
        hour_in_day          => 23,
        duration             => 2,
        start_time           => SYSDATE,
        end_time             => ADD_MONTHS(SYSDATE, 12),
        baseline_name_prefix => 'Sunday_night_bl',
        template_name        => 'Sunday_night_bl',
        expiration           => 365
    );
END;
/
