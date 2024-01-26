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

# <Value data={product_info} value=Description />

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
      color: ['#2165b0', '#7a7fbd', '#57b4ad', '#8cb87a'],
      textStyle: { fontFamily: 'Plus Jakarta Sans'}
    }}
/>

<!-- <ButtonGroup name=period>
    <ButtonGroupItem valueLabel="Weekly" value="week" />
    <ButtonGroupItem valueLabel="Daily" value="day" />
    <ButtonGroupItem valueLabel="Monthly" value="month" />
</ButtonGroup> -->
