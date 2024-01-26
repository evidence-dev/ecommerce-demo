# Orders

```orders_by_month
select * from ecommerce.orders_by_month
where order_month >= '${inputs.range.start}'
  and order_month <= '${inputs.range.end}'
order by order_month, total_sales desc
```

```sql orders_by_repeat_status
select
  repeat_status,
  date_trunc('month', invoice_date) as order_month,
  sum(total_sales) as total_sales,
  count(*) as number_of_orders,
  sum(total_sales) / number_of_orders as avg_order_value
from ecommerce.orders
where order_month >= '${inputs.range.start}'
  and order_month <= '${inputs.range.end}'
group by 1, 2
order by 1, 2
```

```sql customer_count
select
  date_trunc('month', first_order) as first_order_month,
  count(*) as number_of_customers
from ecommerce.customers
group by 1
```

```sql customer_and_order_count
select
  first_order_month,
  number_of_customers as number_of_new_customers,
  number_of_orders
from ${customer_count} c
left join ecommerce.orders_by_month o
on c.first_order_month = o.order_month
where order_month >= '${inputs.range.start}'
  and order_month <= '${inputs.range.end}'
```

```sql customer_type
select 'Consumer' as customer_type union all select 'B2B' as customer_type
```

```sql date_min
select DISTINCT strftime((invoice_date),'%Y-%m-%d') as date from ecommerce.orders group by 1 order by 1
```

```sql date_max
select DISTINCT strftime((invoice_date),'%Y-%m-%d') as date from ecommerce.orders group by 1 order by 1 desc
```

<DateRange name=range data=order_items dates=invoice_date/>

<div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
<div>

<BarChart
  data={orders_by_repeat_status}
  x=order_month
  y=avg_order_value
  yFmt="$#,##0"
  type=grouped
  series=repeat_status
  title="Average Order Value (USD)"
  echartsOptions={{
      color: ['#2165b0', '#7a7fbd', '#57b4ad', '#8cb87a'],
      textStyle: { fontFamily: 'Plus Jakarta Sans'},
      grid: {left: 6}
    }}
/>

<LineChart
  data={customer_and_order_count}
  x=first_order_month
  title="Order and Customer Count by Period"
  echartsOptions={{
      color: ['#2165b0', '#7a7fbd', '#57b4ad', '#8cb87a'],
      textStyle: { fontFamily: 'Plus Jakarta Sans'},
      grid: {left: 6}
    }}
/>

</div>

<div>

<BarChart
  data={orders_by_month}
  x=order_month
  y=total_sales
  yFmt="$###,##0,k"
  title="Monthly Sales"
  chartAreaHeight=465
  echartsOptions={{
      color: ['#2165b0', '#7a7fbd', '#57b4ad', '#8cb87a'],
      textStyle: { fontFamily: 'Plus Jakarta Sans'},
      grid: {left: 6}
    }}
/>

</div>
</div>

## Order Location Content

```sql order_location
select
    CASE
        WHEN Country = 'United Kingdom' THEN 'California'
        WHEN Country = 'Germany' THEN 'New York'
        WHEN Country = 'France' THEN 'Texas'
        WHEN Country = 'EIRE' THEN 'Florida'
        WHEN Country = 'Spain' THEN 'Illinois'
        WHEN Country = 'Netherlands' THEN 'Ohio'
        WHEN Country = 'Belgium' THEN 'Pennsylvania'
        WHEN Country = 'Switzerland' THEN 'Michigan'
        WHEN Country = 'Portugal' THEN 'Georgia'
        WHEN Country = 'Australia' THEN 'North Carolina'
        WHEN Country = 'Norway' THEN 'New Jersey'
        WHEN Country = 'Italy' THEN 'Virginia'
        WHEN Country = 'Channel Islands' THEN 'Washington'
        WHEN Country = 'Finland' THEN 'Arizona'
        WHEN Country = 'Cyprus' THEN 'Massachusetts'
        WHEN Country = 'Sweden' THEN 'Indiana'
        WHEN Country = 'Unspecified' THEN 'Tennessee'
        WHEN Country = 'Austria' THEN 'Maryland'
        WHEN Country = 'Denmark' THEN 'Wisconsin'
        WHEN Country = 'Japan' THEN 'Missouri'
        WHEN Country = 'Poland' THEN 'Minnesota'
        WHEN Country = 'Israel' THEN 'Colorado'
        WHEN Country = 'USA' THEN 'Oregon'
        WHEN Country = 'Hong Kong' THEN 'Oklahoma'
        WHEN Country = 'Singapore' THEN 'Kentucky'
        WHEN Country = 'Iceland' THEN 'Louisiana'
        WHEN Country = 'Canada' THEN 'Connecticut'
        WHEN Country = 'Greece' THEN 'Alabama'
        WHEN Country = 'Malta' THEN 'Iowa'
        WHEN Country = 'United Arab Emirates' THEN 'Alaska'
        WHEN Country = 'European Community' THEN 'Kansas'
        WHEN Country = 'RSA' THEN 'Arkansas'
        WHEN Country = 'Lebanon' THEN 'South Carolina'
        WHEN Country = 'Lithuania' THEN 'Mississippi'
        WHEN Country = 'Brazil' THEN 'Nebraska'
        WHEN Country = 'Czech Republic' THEN 'Nevada'
        WHEN Country = 'Bahrain' THEN 'Idaho'
        WHEN Country = 'Saudi Arabia' THEN 'Montana'
        ELSE Country
    END AS State,
    Country,
    count(*) as number_of_orders,
    sum(UnitPrice*Quantity) as total_sales,
from ecommerce.order_items
group by all
order by 2 desc
```

<USMap
  data={order_location}
  state=State
  value=number_of_orders
  colorScale=bluegreen
  max=20000
  title="Number of Orders by State"
  echartsOptions={{
      visualMap: {
          top: 'middle',
          show: true,
          text: ['More', 'Fewer'],
          inRange: {
              color: [ // range of cobalts
                '#c8dbf3',
                '#a9c1df',
                '#89a7cb',
                '#6a8db7',
                '#4b73a3',
                '#2165b0',
                ]
          },
        },
      textStyle: { fontFamily: 'Plus Jakarta Sans'}
  }}
/>
