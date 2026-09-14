select

    paymentid as payment_id,

    orderid as order_id,

    paymentdate as payment_date,

    paymentstatus as payment_status

from {{ source('traders_raw', 'payments') }}