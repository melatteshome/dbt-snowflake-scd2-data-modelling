select
    o.order_id,
    c.customer_sk,
    p.product_sk,
    o.order_date,
    o.quantity,
    p.unit_price,
    o.discount,
    o.quantity * p.unit_price as gross_sales,
    o.quantity * p.unit_price * (1 - o.discount) as net_sales

from {{ ref('stg_orders') }} o
left join {{ ref('dim_customers') }} c
    on o.customer_id = c.customer_id
    and o.order_date >= c.valid_from
    and o.order_date < coalesce(c.valid_to, '9999-12-31')

left join {{ ref('dim_products') }} p
    on o.product_id = p.product_id
    and o.order_date >= p.valid_from
    and o.order_date < coalesce(p.valid_to, '9999-12-31')