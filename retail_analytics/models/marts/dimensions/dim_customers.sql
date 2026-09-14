with source_customers as (

    select
        customer_id,
        age,
        city,
        signup_date,
        customer_segment
    from {{ ref('stg_customers') }}

)

{% if is_incremental() %}

, current_customers as (

    select *
    from {{ this }}
    where is_current = true

)

, changed_customers as (

    select
        s.*,
        c.customer_sk,
        case
            when c.customer_id is null then 'NEW'

            when c.city is distinct from s.city
              or c.customer_segment is distinct from s.customer_segment
            then 'CHANGED'

            else 'UNCHANGED'
        end as change_type

    from source_customers s

    left join current_customers c
        on s.customer_id = c.customer_id

)

select
    {{ dbt_utils.generate_surrogate_key([
        'customer_id',
        'current_timestamp()'
    ]) }} as customer_sk,

    customer_id,
    age,
    city,
    signup_date,
    customer_segment,

    current_timestamp() as valid_from,
    null::timestamp_ntz as valid_to,
    true as is_current

from changed_customers

where change_type in ('NEW', 'CHANGED')

{% else %}

select
    {{ dbt_utils.generate_surrogate_key([
        'customer_id'
    ]) }} as customer_sk,

    customer_id,
    age,
    city,
    signup_date,
    customer_segment,

    current_timestamp() as valid_from,
    null::timestamp_ntz as valid_to,
    true as is_current

from source_customers

{% endif %}