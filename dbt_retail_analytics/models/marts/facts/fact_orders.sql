{{
config(
     materialized= 'incremental',
     schema= 'marts'
)
}}
select
    order_id,
    customer_sk,
    order_date,

    payment_date,
    status as order_status,

    total_quantity,
    gross_sales,
    gross_sales - net_sales as discount_amount,
    net_sales

from {{ ref('int_order_enriched') }}