<Tabs id=tab color='#2165b0'>
<Tab label='Order Dashboard'>

```orders_by_month
select * from ecommerce.orders_by_month
where order_month >= '${inputs.date_min}'
  and order_month <= '${inputs.date_max}'
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
where order_month >= '${inputs.date_min}'
  and order_month <= '${inputs.date_max}'
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
where order_month >= '${inputs.date_min}'
  and order_month <= '${inputs.date_max}'
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

<Dropdown data={date_min} name=date_min value=date title="Date Min"/>

<Dropdown data={date_max} name=date_max value=date title="Date Max"/>

<div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
<div>

<BarChart
data={orders_by_repeat_status}
x=order_month
y=avg_order_value
yFmt="$#,###"
type=grouped
series=repeat_status
title="Average Order Value (USD)"
echartsOptions={{
    color: ['#2165b0', '#7a7fbd', '#57b4ad', '#8cb87a'],
    textStyle: { fontFamily: 'Plus Jakarta Sans'}
  }}
/>

<LineChart
data={customer_and_order_count}
x=first_order_month
title="Order and Customer Count by Period"
echartsOptions={{
    color: ['#2165b0', '#7a7fbd', '#57b4ad', '#8cb87a'],
    textStyle: { fontFamily: 'Plus Jakarta Sans'}
  }}
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
echartsOptions={{
    color: ['#2165b0', '#7a7fbd', '#57b4ad', '#8cb87a'],
    textStyle: { fontFamily: 'Plus Jakarta Sans'}
  }}
/>

</div>
</div>

</Tab>

<Tab label='Customer Retention'>

## Customer Retention

```sql cohort_size
select
  cohort_month,
  count(*) as cohort_size
from ecommerce.customers
group by 1
```

```sql cohort_retention
select
  c.cohort_month,
  first(cs.cohort_size) as cohort_size,
  'Month' || lpad(date_diff('month', c.cohort_month, date_trunc('month', o.invoice_date))::varchar,2,0) || '_pct' as month_offset,
  count(distinct o.customerId) / first(cs.cohort_size) as retention_rate_pct
from ecommerce.customers c
left join ecommerce.orders o on c.customerID = o.customerID
left join ${cohort_size} cs on c.cohort_month = cs.cohort_month
group by all
order by 1, 2
```

```sql cohort_retention_pivot
PIVOT ${cohort_retention} ON month_offset USING first(retention_rate_pct)
```

<div class="ml-40 font-semibold text-sm">Months Since Cohort Start</div>

<DataTable data={cohort_retention_pivot} rows=all>
  <Column id='cohort_month' title='Cohort' fmt='mmm yyyy'/>
  <Column id='cohort_size' title='Cohort Size'/>
  <Column id='Month00_pct' fmt='0%' title='0' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month01_pct' fmt='0%' title='1' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month02_pct' fmt='0%' title='2' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month03_pct' fmt='0%' title='3' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month04_pct' fmt='0%' title='4' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month05_pct' fmt='0%' title='5' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month06_pct' fmt='0%' title='6' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month07_pct' fmt='0%' title='7' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month08_pct' fmt='0%' title='8' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month09_pct' fmt='0%' title='9' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month10_pct' fmt='0%' title='10' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month11_pct' fmt='0%' title='11' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month12_pct' fmt='0%' title='12' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
</DataTable>

</Tab>
<Tab label='Dollar Retention'>

## Dollar Retention

<div class="ml-40 font-semibold text-sm">Months Since Cohort Start</div>

<DataTable data={cohort_retention_pivot} rows=all>
  <Column id='cohort_month' title='Cohort' fmt='mmm yyyy'/>
  <Column id='cohort_size' title='Cohort Size'/>
  <Column id='Month00_pct' fmt='0%' title='0' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month01_pct' fmt='0%' title='1' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month02_pct' fmt='0%' title='2' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month03_pct' fmt='0%' title='3' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month04_pct' fmt='0%' title='4' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month05_pct' fmt='0%' title='5' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month06_pct' fmt='0%' title='6' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month07_pct' fmt='0%' title='7' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month08_pct' fmt='0%' title='8' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month09_pct' fmt='0%' title='9' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month10_pct' fmt='0%' title='10' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month11_pct' fmt='0%' title='11' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
  <Column id='Month12_pct' fmt='0%' title='12' contentType=colorscale scaleColor=blue colorMax=1 colorMin=0/>
</DataTable>

</Tab>
<Tab label='Cohort LTV'>

## Cohort LTV Content

Content goes here

</Tab>

<Tab label='Top Products'>

## Top Products (Total Quantity)

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
from ecommerce.order_items
where invoice_date >= '${inputs.date_min_products}'
  and invoice_date <= '${inputs.date_max_products}'
group by 1,2
order by rank
```

```sql top_products
select
    upper(substring(description_group,1,1)) || lower(substring(description_group,2)) as description_group,
    stockcode_group,
    sum(products_sold) as products_sold,
    sum(total_sales) as total_sales,
    sum(rank) as rank_sum
from ${ranked_products}
where products_sold > 0
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
from ecommerce.order_items oi
left join ${ranked_products} rp on oi.Description = rp.Description
where invoice_date >= '${inputs.date_min_products}'
  and invoice_date <= '${inputs.date_max_products}'
group by 1,2,3,4,5
order by month
```

```top_products_monthly
select
    upper(substring(description_group,1,1)) || lower(substring(description_group,2)) as description_group,
    stockcode_group,
    month,
    sum(products_sold) as products_sold,
    sum(total_sales) as total_sales,
from ${ranked_products_monthly}
where description_group is not null
and products_sold > 0
group by 1,2,3
```

<Dropdown data={date_min} name=date_min_products value=date title="Date Min"/>

<Dropdown data={date_max} name=date_max_products value=date title="Date Max"/>

<Dropdown name=range title="Axis Bounds">
    <DropdownOption value="Zoomed"/>
    <DropdownOption value="Full Range"/>
</Dropdown>

{#if inputs.range == "Zoomed"}

<AreaChart
data={top_products_monthly}
x=month
y=products_sold
series=description_group
type=stacked100
yFmt="#0%"
yMin=0.9
yMax=1.0
echartsOptions={{
    color: [
      '#d2d2d1', // medium ash
      //'#ece8e5',  // linen
      //'#373b5e', // navy
      '#7a7fbd', // peripurple
      '#00aced', // blue
      '#2165b0', // cobalt
      '#57b4ad', // turquoise
      '#8cb87a', // light green
      '#0a2e7d', // royal blue
      '#106a98', // sub-title
      '#5aaad3', // sky blue
      '#96ced6', // light blue
      '#364351', // sub-nav
      '#4c4e4f', // ash grey
    ],
    textStyle: { fontFamily: 'Plus Jakarta Sans'}
  }}
/>

{:else}

<AreaChart
data={top_products_monthly}
x=month
y=products_sold
series=description_group
type=stacked100
yFmt="#0%"
yMin=0
yMax=1.0
echartsOptions={{
    color: [
      '#d2d2d1', // medium ash
      //'#ece8e5',  // linen
      //'#373b5e', // navy
      '#7a7fbd', // peripurple
      '#00aced', // blue
      '#2165b0', // cobalt
      '#57b4ad', // turquoise
      '#8cb87a', // light green
      '#0a2e7d', // royal blue
      '#106a98', // sub-title
      '#5aaad3', // sky blue
      '#96ced6', // light blue
      '#364351', // sub-nav
      '#4c4e4f', // ash grey
    ],
    textStyle: { fontFamily: 'Plus Jakarta Sans'}
  }}
/>

{/if}

<div class="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">

<div>

## Top Products by Description

<DataTable data={top_products} rows=all>
    <Column id=description_group/>
    <Column id=products_sold fmt="#,###" contentType=colorscale scaleColor=blue colorMax=200000/>
</DataTable>
</div>

<div>

## Top Products by StockCode

<DataTable data={top_products} rows=all>
    <Column id=stockcode_group/>
    <Column id=products_sold fmt="#,###" contentType=colorscale scaleColor=blue colorMax=200000/>
</DataTable>
</div>

<div>

## Categories

<DataTable data={top_categories} rows=all>
    <Column id=category/>
    <Column id=products_sold fmt="#,###" contentType=colorscale scaleColor=blue colorMax=200000/>
</DataTable>

</div>

</div>

</Tab>

<Tab label='Products by Repeat Status'>

## Products by Repeat Status

```sql top_products_by_repeat_status
select
    oi.Description,
    oi.StockCode,
    o.repeat_status,
    rp.description_group,
    rp.stockcode_group,
    sum(oi.Quantity) as products_sold,
from ecommerce.order_items oi
left join ecommerce.orders o on oi.InvoiceNo = o.InvoiceNo
left join ${ranked_products} rp on oi.Description = rp.Description
where Quantity > 0
group by all
```

```sql top_products_by_repeat_status_grouped
select
    upper(substring(description_group,1,1)) || lower(substring(description_group,2)) as description_group,
    repeat_status,
    sum(products_sold) as products_sold
from ${top_products_by_repeat_status}
where description_group != 'Other'
group by 1,2
order by products_sold desc
```

```sql top_products_pivot
PIVOT ${top_products_by_repeat_status_grouped} ON repeat_status USING first(products_sold)
order by 3 desc
```

<DataTable data={top_products_pivot} rows=all>
    <Column id=description_group/>
    <Column id=Repeat fmt="#,###" contentType=colorscale scaleColor=blue colorMax=80000/>
    <Column id=New fmt="#,###" contentType=colorscale scaleColor=blue colorMax=80000/>
    <Column id=Unknown fmt="#,###" contentType=colorscale scaleColor=blue colorMax=80000/>
</DataTable>

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

</Tab>

</Tabs>
