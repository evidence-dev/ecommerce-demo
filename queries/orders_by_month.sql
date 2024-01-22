select
    date_trunc('month',invoice_date) as order_month,
    sum(total_sales) as total_sales,
    count(*) as number_of_orders
from ${orders}
group by 1
order by 1