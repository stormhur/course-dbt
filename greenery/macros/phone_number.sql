{% test is_phone_number_length(model, column_name) %}

   {{ config(severity = 'warn') }}

   select *
   from {{ model }}
   where length({{ column_name }}) > 12


{% endtest %}