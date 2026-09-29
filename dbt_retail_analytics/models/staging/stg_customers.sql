select

    customerid as customer_id,

    Cast(age as integer) as age,

    city,

    signupdate as signup_date,

    customersegment as customer_segment

from {{ source('traders_raw', 'customers') }}