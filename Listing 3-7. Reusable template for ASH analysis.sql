-- Function: Summarize session activity by <dimension>

SELECT
    <dimension_columns>,
    COUNT(*) AS cnt,
    TO_CHAR(100 * TRUNC(RATIO_TO_REPORT(COUNT(*)) OVER (), 4), 'FM990.99') || '%' AS "%"
FROM
    <data_source>
    <optional_joins>
WHERE
    <time_range_condition>
    <optional_filters>
GROUP BY
    <dimension_columns>
ORDER BY
    COUNT(*) DESC
FETCH FIRST 10 ROWS ONLY;
