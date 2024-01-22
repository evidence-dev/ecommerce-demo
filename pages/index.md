---
queries:
- orders.sql
- order_items.sql 
- orders_by_month.sql
- customers.sql
---

<BarChart
  data={orders_by_month}
  x=order_month
  y=total_sales
  yFmt="$###,###,k"
  title="Monthly Sales"
/>

```sql orders_by_repeat_status
select 
  repeat_status,
  date_trunc('month', invoice_date) as order_month,
  sum(total_sales) as total_sales,
  count(*) as number_of_orders,
  sum(total_sales) / number_of_orders as avg_order_value
from ${orders}
group by 1, 2
order by 1, 2
```


<BarChart
  data={orders_by_repeat_status}
  x=order_month
  y=total_sales
  series=repeat_status
  title="Monthly Sales by Repeat Status"
  yFmt="$###,###,k"
/>

## AOV

<BarChart
  data={orders_by_repeat_status}
  x=order_month
  y=avg_order_value
  yFmt="$#,###"
  type=grouped
  series=repeat_status
  title="Average Order Value (USD)"
/>

## Order and Customer Counts

```sql customer_count
select 
  date_trunc('month', first_order) as first_order_month,
  count(*) as number_of_customers
from ${customers}
group by 1
```

```sql customer_and_order_count
select 
  first_order_month,
  number_of_customers as number_of_new_customers,
  number_of_orders
from ${customer_count} c
left join ${orders_by_month} o
on c.first_order_month = o.order_month
```

<LineChart
  data={customer_and_order_count}
  x=first_order_month
  title="Order and Customer Count by Period"
/>