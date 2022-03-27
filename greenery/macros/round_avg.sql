{% macro round_avg(column_name) %}

    ROUND(AVG({{column_name}})::numeric,2)

{% endmacro %}