BEGIN
  DBMS_SCHEDULER.SET_ATTRIBUTE(
    name      => 'SUNDAY_WINDOW',
    attribute => 'RESOURCE_PLAN',
    value     => '' 
  );
END;
/
