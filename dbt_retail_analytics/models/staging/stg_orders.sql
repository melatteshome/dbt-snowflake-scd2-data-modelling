select

    orderid as order_id,

    customerid as customer_id,

    orderdate as order_date,

    productid as product_id,

    quantity,

    discount,

    paymentmethod as payment_method,

    status

from {{ source('traders_raw', 'orders') }}