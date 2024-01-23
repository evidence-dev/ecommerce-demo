---
queries:
- orders.sql
- order_items.sql 
- orders_by_month.sql
- customers.sql
---


<Tabs>
<Tab label='Order Dashboard'>

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



```sql customer_type
select 'Consumer' as customer_type union all select 'B2B' as customer_type
```

```sql date_range
select strftime(min(invoice_date),'%Y-%m-%d') as test_date from ${orders} 
union all 
select strftime(max(invoice_date),'%Y-%m-%d') as test_date from ${orders}
```



<Dropdown data={customer_type} name=customer_type value=customer_type title="Customer Type"/>

<Dropdown data={date_range} name=date_range value=test_date title="Date Range"/>





<div class="grid grid-cols-2 gap-4">
<div>

<BarChart
  data={orders_by_repeat_status}
  x=order_month
  y=avg_order_value
  yFmt="$#,###"
  type=grouped
  series=repeat_status
  title="Average Order Value (USD)"
/>



<LineChart
  data={customer_and_order_count}
  x=first_order_month
  title="Order and Customer Count by Period"
/>

</div>

  
<div>

<BarChart
  data={orders_by_month}
  x=order_month
  y=total_sales
  yFmt="$###,###,k"
  title="Monthly Sales"
  chartAreaHeight=465
/>

</div>
</div>



</Tab>
<Tab label='Customer Retention'>


```sql cohort_size
select
  cohort_month,
  count(*) as cohort_size
from ${customers}
group by 1
```

```sql cohort_retention
select
  c.cohort_month,
  first(cs.cohort_size) as cohort_size,
  'Month' || lpad(date_diff('month', c.cohort_month, date_trunc('month', o.invoice_date))::varchar,2,0) || '_pct' as month_offset,
  count(distinct o.customerId) / first(cs.cohort_size) as retention_rate_pct
from ${customers} c
left join ${orders} o on c.customerID = o.customerID
left join ${cohort_size} cs on c.cohort_month = cs.cohort_month
group by all
order by 1, 2
```

```sql cohort_retention_pivot
PIVOT ${cohort_retention} ON month_offset USING first(retention_rate_pct)
```

## Customer Retention

<br/>

<div class="ml-40 font-semibold text-sm">Months Since Cohort Start</div>

<DataTable data={cohort_retention_pivot} rows=all>
  <Column id='cohort_month' title='Cohort' fmt='mmm yyyy'/>
  <Column id='cohort_size' title='Cohort Size'/>
  <Column id='Month00_pct' fmt='0%' title='0' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month01_pct' fmt='0%' title='1' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month02_pct' fmt='0%' title='2' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month03_pct' fmt='0%' title='3' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month04_pct' fmt='0%' title='4' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month05_pct' fmt='0%' title='5' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month06_pct' fmt='0%' title='6' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month07_pct' fmt='0%' title='7' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month08_pct' fmt='0%' title='8' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month09_pct' fmt='0%' title='9' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month10_pct' fmt='0%' title='10' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month11_pct' fmt='0%' title='11' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month12_pct' fmt='0%' title='12' contentType=colorscale colorMax=1 colorMin=0/>
</DataTable>

</Tab>
<Tab label='Dollar Retention'>

## Dollar Retention

<div class="ml-40 font-semibold text-sm">Months Since Cohort Start</div>

<DataTable data={cohort_retention_pivot} rows=all>
  <Column id='cohort_month' title='Cohort' fmt='mmm yyyy'/>
  <Column id='cohort_size' title='Cohort Size'/>
  <Column id='Month00_pct' fmt='0%' title='0' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month01_pct' fmt='0%' title='1' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month02_pct' fmt='0%' title='2' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month03_pct' fmt='0%' title='3' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month04_pct' fmt='0%' title='4' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month05_pct' fmt='0%' title='5' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month06_pct' fmt='0%' title='6' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month07_pct' fmt='0%' title='7' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month08_pct' fmt='0%' title='8' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month09_pct' fmt='0%' title='9' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month10_pct' fmt='0%' title='10' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month11_pct' fmt='0%' title='11' contentType=colorscale colorMax=1 colorMin=0/>
  <Column id='Month12_pct' fmt='0%' title='12' contentType=colorscale colorMax=1 colorMin=0/>
</DataTable>


</Tab>
<Tab label='Cohort LTV'>

## Cohort LTV Content

Content goes here

</Tab>



<Tab label='Top Product Analysis'>



```sql ranked_products
select 
    Description,
    StockCode,
    sum(Quantity) as products_sold,
    sum(UnitPrice*Quantity) as total_sales,
    row_number() over (order by products_sold desc) as rank,
    case 
        when rank <= 10 then Description
        else 'Other'
    end as description_group,
    case 
        when rank <= 10 then StockCode
        else 'Other'
    end as stockcode_group,
    case 
        when Description ilike '%bag%' then 'Bags'
        when Description ilike '%mug%' then 'Mugs'
        when Description ilike '%jar%' then 'Jars'
        when Description ilike '%holder%' then 'Holders'
        when Description ilike '%craft%' then 'Crafts'
        when Description ilike '%decoration%' then 'Decorations'
        else 'Other'
    end as category
from ${order_items}
where Quantity > 0
group by 1,2
order by rank
``` 



```sql top_products
select 
    lower(description_group) as description_group,
    stockcode_group,
    sum(products_sold) as products_sold,
    sum(total_sales) as total_sales,
    sum(rank) as rank_sum
from ${ranked_products}
group by 1,2
order by rank_sum
```

```sql top_categories
select 
    category,
    sum(products_sold) as products_sold,
    sum(total_sales) as total_sales,
from ${ranked_products}
group by 1
order by products_sold desc
```



```ranked_products_monthly
select 
    oi.Description,
    oi.StockCode,
    rp.description_group,
    rp.stockcode_group,
    date_trunc('month', invoice_date) as month,
    sum(Quantity) as products_sold,
    sum(UnitPrice*Quantity) as total_sales,
from ${order_items} oi
left join ${ranked_products} rp on oi.Description = rp.Description
group by 1,2,3,4,5
order by month
```

```top_products_monthly
select 
    lower(description_group) as description_group,
    stockcode_group,
    month,
    sum(products_sold) as products_sold,
    sum(total_sales) as total_sales,
from ${ranked_products_monthly}
where description_group is not null
group by 1,2,3
```


## Top Products (Total Quantity)

<AreaChart
    data={top_products_monthly}
    x=month
    y=products_sold
    series=description_group
    type=stacked100
    yFmt="00%"
/>




<div class="grid grid-cols-3 gap-4">


<div>

## Top Products by Description

<DataTable data={top_products} rows=all>
    <Column id=description_group/>
    <Column id=products_sold fmt="#,###" contentType=colorscale colorMax=100000/>
</DataTable>
</div>


<div>

## Top Products by StockCode

<DataTable data={top_products} rows=all>
    <Column id=stockcode_group/>
    <Column id=products_sold fmt="#,###" contentType=colorscale colorMax=100000/>
</DataTable>
</div>

<div>

## Categories

<DataTable data={top_categories} rows=all>
    <Column id=category/>
    <Column id=products_sold fmt="#,###" contentType=colorscale colorMax=100000/>
</DataTable>

</div>


</div>



</Tab>

<Tab label='Top Products by Customer Type'>

## Top Products by Customer Type Content

Content goes here

</Tab>
<Tab label='Refunds'>

## Refunds Content

Content goes here

</Tab>
<Tab label='Order Location'>

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
    count(*) as number_of_orders,
    sum(UnitPrice*Quantity) as total_sales,
from ${order_items}
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
			},
}}
/>


</Tab>
</Tabs>
