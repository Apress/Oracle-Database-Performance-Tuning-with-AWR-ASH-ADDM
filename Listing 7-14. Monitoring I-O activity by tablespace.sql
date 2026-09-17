SELECT
    fs.con_id,
    fs.tsname,
    (MAX(fs.phyrds) - MIN(fs.phyrds))
  + (MAX(fs.phywrts) - MIN(fs.phywrts)) AS total_io_requests,
    (MAX(fs.phyblkrd) - MIN(fs.phyblkrd))
  + (MAX(fs.phyblkwrt) - MIN(fs.phyblkwrt)) AS total_blocks,
    ROUND(
        CASE
            WHEN MAX(fs.phyrds) - MIN(fs.phyrds) > 0
            THEN ((MAX(fs.readtim) - MIN(fs.readtim)) * 10) /
                 (MAX(fs.phyrds) - MIN(fs.phyrds))
            ELSE 0
        END,
        2
    ) AS read_lat_ms,
    ROUND(
        CASE
            WHEN MAX(fs.phywrts) - MIN(fs.phywrts) > 0
            THEN ((MAX(fs.writetim) - MIN(fs.writetim)) * 10) /
                 (MAX(fs.phywrts) - MIN(fs.phywrts))
            ELSE 0
        END,
        2
    ) AS write_lat_ms
FROM
    dba_hist_filestatxs fs
    JOIN dba_hist_snapshot sn
      ON sn.snap_id         = fs.snap_id
     AND sn.dbid            = fs.dbid
     AND sn.instance_number = fs.instance_number
WHERE
    sn.end_interval_time > SYSDATE - 1
GROUP BY
    fs.con_id,
    fs.tsname
ORDER BY
    total_io_requests DESC;
