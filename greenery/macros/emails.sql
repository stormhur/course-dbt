{% test is_email(model, column_name) %}

   {{ config(severity = 'warn') }}
   
   select *
   from {{ model }}
   where {{ column_name }} not like '%@%'


{% endtest %}