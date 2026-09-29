
{{
    config(
      materialized= 'view',
      schema= 'intermediate'
)
}}

with orders as (

    select *
    from {{ ref('stg_orders') }}

),

payments as (

    select *
    from {{ ref('stg_payments') }}

),

order_details as (

    select
        o.order_id,
        o.customer_id,
        o.order_date,
        o.payment_method,
        o.status,

        sum(o.quantity) as total_quantity,

        sum(
            o.quantity * p.unit_price
        ) as gross_sales,

        sum(
            (o.quantity * p.unit_price) * (1 - o.discount)
        ) as net_sales

    from orders o

    -- Get the product price that was valid when the order happened
    left join {{ ref('dim_products') }} p
        on o.product_id = p.product_id
        and o.order_date >= p.valid_from
        and o.order_date < coalesce(p.valid_to, '9999-12-31')

    group by
        o.order_id,
        o.customer_id,
        o.order_date,
        o.payment_method,
        o.status
)

select
    o.order_id,

    c.customer_sk,

    o.order_date,
    o.payment_method,
    o.status,

    o.total_quantity,
    o.gross_sales,
    o.net_sales,

    pay.payment_date,

from order_details o

left join {{ ref('dim_customers') }} c
    on o.customer_id = c.customer_id
    and o.order_date >= c.valid_from
    and o.order_date < coalesce(c.valid_to, '9999-12-31')

left join payments pay
    on o.order_id = pay.order_id