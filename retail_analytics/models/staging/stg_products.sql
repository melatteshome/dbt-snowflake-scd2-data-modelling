select

    productid as product_id,

    productname as product_name,

    category,

    unitprice as unit_price

from {{ source('traders_raw', 'products') }}