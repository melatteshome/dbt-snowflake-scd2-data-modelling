{% macro expire_customer_record() %}

    update {{ this }} as d

    set
        valid_to = current_timestamp(),
        is_current = false

    from {{ ref('stg_customers') }} as s

    where d.customer_id = s.customer_id
      and d.is_current = true
      and (
          s.city is distinct from d.city
          or s.customer_segment is distinct from d.customer_segment
      )

{% endmacro %}