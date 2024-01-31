## Top Products by Quantity


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
    if(stockcode_group = 'Other', '',stockcode_group) as link,
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
    if(category = 'Other', '','/categories/' || category) as link,
    -0.03 + random() * (0.2) as change
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

```sql date_min
select DISTINCT strftime((invoice_date),'%Y-%m-%d') as date from ecommerce.orders group by 1 order by 1
```

```sql date_max
select DISTINCT strftime((invoice_date),'%Y-%m-%d') as date from ecommerce.orders group by 1 order by 1 desc
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
  '#003f5c', // Dark Teal
  '#2f4b7c', // Royal Blue
  '#665191', // Deep Purple
  '#a05195', // Orchid
  '#d45087', // Magenta
  '#f95d6a', // Coral
  '#ff7c43', // Orange
  '#ffa600', // Amber
  '#92a8d1', // Periwinkle
  '#c5cae9', // Lavender
  '#7f7caf', // Slate Blue
  '#ffb74d'  // Dark Peach
],
    textStyle: { fontFamily: 'Playfair Display'},
    xAxis: {
        triggerEvent: true
  }
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
  '#003f5c', // Dark Teal
  '#2f4b7c', // Royal Blue
  '#665191', // Deep Purple
  '#a05195', // Orchid
  '#d45087', // Magenta
  '#f95d6a', // Coral
  '#ff7c43', // Orange
  '#ffa600', // Amber
  '#92a8d1', // Periwinkle
  '#c5cae9', // Lavender
  '#7f7caf', // Slate Blue
  '#ffb74d'  // Dark Peach
],
    textStyle: { fontFamily: 'Playfair Display'}
  }}
/>

{/if}

<div class="grid grid-cols-1 gap-4 md:grid-cols-2">

<div>

### Top Products by Description

<DataTable data={top_products} rows=all link=link>
    <Column id=description_group/>
    <Column id=products_sold fmt="#,##0" contentType=colorscale scaleColor=blue colorMax=200000/>
</DataTable>
</div>

<div>

### Top Products by StockCode

<DataTable data={top_products} rows=all link=link>
    <Column id=stockcode_group/>
    <Column id=products_sold fmt="#,##0" contentType=colorscale scaleColor=blue colorMax=200000/>
</DataTable>
</div>

<div>

### Categories

<DataTable data={top_categories} rows=all link=link>
    <Column id=category/>
    <Column id=products_sold fmt="#,##0" contentType=colorscale scaleColor=blue colorMax=200000/>
    <Column id=change contentType=delta fmt=pct1/>
</DataTable>

</div>

</div>

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
    <Column id=Repeat fmt="#,##0" contentType=colorscale scaleColor=blue colorMax=80000/>
    <Column id=New fmt="#,##0" contentType=colorscale scaleColor=blue colorMax=80000/>
    <Column id=Unknown fmt="#,##0" contentType=colorscale scaleColor=blue colorMax=80000/>
</DataTable>
