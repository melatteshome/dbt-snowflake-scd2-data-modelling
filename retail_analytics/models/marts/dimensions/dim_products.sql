with source_products as (

    select
        product_id,
        product_name,
        category,
        unit_price
    from {{ ref('stg_products') }}

)

{% if is_incremental() %}

, current_products as (

    select *
    from {{ this }}
    where is_current = true

)

, changed_products as (

    select
        s.*,
        p.product_sk,
        case
            when p.product_id is null then 'NEW'

            when p.unit_price is distinct from s.unit_price
              or p.category is distinct from s.category
            then 'CHANGED'

            else 'UNCHANGED'
        end as change_type

    from source_products s

    left join current_products p
        on s.product_id = p.product_id

)

select
    {{ dbt_utils.generate_surrogate_key([
        'product_id',
        'current_timestamp()'
    ]) }} as product_sk,

    product_id,
    product_name,
    category,
    unit_price,

    current_timestamp() as valid_from,
    null::timestamp_ntz as valid_to,
    true as is_current

from changed_products

where change_type in ('NEW', 'CHANGED')

{% else %}

select
    {{ dbt_utils.generate_surrogate_key([
        'product_id'
    ]) }} as product_sk,

    product_id,
    product_name,
    category,
    unit_price,

    current_timestamp() as valid_from,
    null::timestamp_ntz as valid_to,
    true as is_current

from source_products

{% endif %}