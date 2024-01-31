```order_volume

select
date_trunc('week', invoice_date) as week,
sum(UnitPrice * Quantity) as sales,
count(distinct InvoiceNo) as orders,
sales/orders as aov,
sales/lag(sales, 1) over() -1 as sales_growth_pct,
orders/lag(orders, 1) over() -1 as orders_growth_pct,
aov/lag(aov, 1) over() -1 as aov_growth_pct
from order_items
where StockCode = '${$page.params.stockcode}'
group by all
order by 1 desc

```

```product_info
select
Description,
    case
        when Description ilike '%bag%' then 'Bags'
        when Description ilike '%mug%' then 'Mugs'
        when Description ilike '%jar%' then 'Jars'
        when Description ilike '%holder%' then 'Holders'
        when Description ilike '%craft%' then 'Crafts'
        when Description ilike '%decoration%' then 'Decorations'
        else 'Other'
    end as category
from order_items
where StockCode = '${$page.params.stockcode}'
group by all


```

# <Value data={product_info} column=Description />

Stock Code {$page.params.stockcode}

<BigValue data={order_volume} value=sales comparison=sales_growth_pct comparisonTitle="last week" fmt=usd/>
<BigValue data={order_volume} value=orders comparison=orders_growth_pct comparisonTitle="last week"/>
<BigValue data={order_volume} value=aov title="AOV" comparison=aov_growth_pct comparisonTitle="last week" fmt=usd/>

<LineChart 
    data={order_volume} 
    yAxisTitle="in Sales" 
    y=sales
    yFmt=usd
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
      grid: {left: 6}
    }}
/>
