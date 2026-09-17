SELECT ksppinm AS parameter_name,
       ksppstvl AS parameter_value,
       ksppdesc AS description
FROM   x$ksppi xpi
       JOIN x$ksppsv xps ON xpi.indx = xps.indx
WHERE  ksppinm IN ('_ash_sample_all', '_ash_size', '_ash_enable',
                   '_ash_sampling_interval', '_ash_disk_write_enable',
                   '_ash_disk_filter_ratio')
ORDER BY ksppinm;
