SELECT group_or_subplan,
       mgmt_p1,
       mgmt_p2
FROM   dba_rsrc_plan_directives
WHERE  plan = 'DEFAULT_MAINTENANCE_PLAN';
