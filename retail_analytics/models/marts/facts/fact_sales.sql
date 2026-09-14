SELECT
    s.order_id,
    s.customer_sk,
    s.product_sk,
    s.order_date,
    s.quantity,
    s.unit_price,
    s.discount,
    s.gross_sales,
    s.net_sales

FROM {{ ref('int_sales_enriched') }} s
