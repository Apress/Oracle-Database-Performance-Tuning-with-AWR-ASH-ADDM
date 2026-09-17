SET LINESIZE 200
SET PAGESIZE 50

DEFINE dbid     = 4250576883
DEFINE inst_num = 1

COLUMN weekday FORMAT A3    HEADING 'Day'
COLUMN h00     FORMAT 999.9  HEADING '00'
COLUMN h01     FORMAT 999.9  HEADING '01'
COLUMN h02     FORMAT 999.9  HEADING '02'
COLUMN h03     FORMAT 999.9  HEADING '03'
COLUMN h04     FORMAT 999.9  HEADING '04'
COLUMN h05     FORMAT 999.9  HEADING '05'
COLUMN h06     FORMAT 999.9  HEADING '06'
COLUMN h07     FORMAT 999.9  HEADING '07'
COLUMN h08     FORMAT 999.9  HEADING '08'
COLUMN h09     FORMAT 999.9  HEADING '09'
COLUMN h10     FORMAT 999.9  HEADING '10'
COLUMN h11     FORMAT 999.9  HEADING '11'
COLUMN h12     FORMAT 999.9  HEADING '12'
COLUMN h13     FORMAT 999.9  HEADING '13'
COLUMN h14     FORMAT 999.9  HEADING '14'
COLUMN h15     FORMAT 999.9  HEADING '15'
COLUMN h16     FORMAT 999.9  HEADING '16'
COLUMN h17     FORMAT 999.9  HEADING '17'
COLUMN h18     FORMAT 999.9  HEADING '18'
COLUMN h19     FORMAT 999.9  HEADING '19'
COLUMN h20     FORMAT 999.9  HEADING '20'
COLUMN h21     FORMAT 999.9  HEADING '21'
COLUMN h22     FORMAT 999.9  HEADING '22'
COLUMN h23     FORMAT 999.9  HEADING '23'

WITH metric_data AS (
    SELECT
        TO_CHAR(m.begin_time, 'Dy', 'NLS_DATE_LANGUAGE=English') AS weekday,
        TO_CHAR(m.end_time, 'HH24') AS hour_no,
        m.average
    FROM
        dba_hist_sysmetric_summary m
    WHERE
        m.metric_name = 'Average Active Sessions'
        AND m.begin_time >= TRUNC(SYSDATE) - 7
        AND m.dbid = &dbid
        AND m.instance_number = &inst_num
    Order by begin_time
)
SELECT
    weekday,
    NVL(ROUND(AVG(CASE WHEN hour_no = '00' THEN average END), 1), 0) AS h00,
    NVL(ROUND(AVG(CASE WHEN hour_no = '01' THEN average END), 1), 0) AS h01,
    NVL(ROUND(AVG(CASE WHEN hour_no = '02' THEN average END), 1), 0) AS h02,
    NVL(ROUND(AVG(CASE WHEN hour_no = '03' THEN average END), 1), 0) AS h03,
    NVL(ROUND(AVG(CASE WHEN hour_no = '04' THEN average END), 1), 0) AS h04,
    NVL(ROUND(AVG(CASE WHEN hour_no = '05' THEN average END), 1), 0) AS h05,
    NVL(ROUND(AVG(CASE WHEN hour_no = '06' THEN average END), 1), 0) AS h06,
    NVL(ROUND(AVG(CASE WHEN hour_no = '07' THEN average END), 1), 0) AS h07,
    NVL(ROUND(AVG(CASE WHEN hour_no = '08' THEN average END), 1), 0) AS h08,
    NVL(ROUND(AVG(CASE WHEN hour_no = '09' THEN average END), 1), 0) AS h09,
    NVL(ROUND(AVG(CASE WHEN hour_no = '10' THEN average END), 1), 0) AS h10,
    NVL(ROUND(AVG(CASE WHEN hour_no = '11' THEN average END), 1), 0) AS h11,
    NVL(ROUND(AVG(CASE WHEN hour_no = '12' THEN average END), 1), 0) AS h12,
    NVL(ROUND(AVG(CASE WHEN hour_no = '13' THEN average END), 1), 0) AS h13,
    NVL(ROUND(AVG(CASE WHEN hour_no = '14' THEN average END), 1), 0) AS h14,
    NVL(ROUND(AVG(CASE WHEN hour_no = '15' THEN average END), 1), 0) AS h15,
    NVL(ROUND(AVG(CASE WHEN hour_no = '16' THEN average END), 1), 0) AS h16,
    NVL(ROUND(AVG(CASE WHEN hour_no = '17' THEN average END), 1), 0) AS h17,
    NVL(ROUND(AVG(CASE WHEN hour_no = '18' THEN average END), 1), 0) AS h18,
    NVL(ROUND(AVG(CASE WHEN hour_no = '19' THEN average END), 1), 0) AS h19,
    NVL(ROUND(AVG(CASE WHEN hour_no = '20' THEN average END), 1), 0) AS h20,
    NVL(ROUND(AVG(CASE WHEN hour_no = '21' THEN average END), 1), 0) AS h21,
    NVL(ROUND(AVG(CASE WHEN hour_no = '22' THEN average END), 1), 0) AS h22,
    NVL(ROUND(AVG(CASE WHEN hour_no = '23' THEN average END), 1), 0) AS h23
FROM
    metric_data
GROUP BY
    weekday;
