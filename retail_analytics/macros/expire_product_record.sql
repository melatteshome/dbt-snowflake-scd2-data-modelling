{% macro expire_product_record() %}

    update {{ this }} as d

    set
        valid_to = current_timestamp(),
        is_current = false

    from {{ ref('stg_products') }} as s

    where d.product_id = s.product_id
      and d.is_current = true
      and (
          s.unit_price is distinct from d.unit_price
          or s.category is distinct from d.category
      )

{% endmacro %}