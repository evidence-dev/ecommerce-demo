# KPI Dashboard

This projects demonstrates using Evidence to create a KPI dashboard using ecommerce data.

It also uses custom fonts and colours.

<DateRange name=range data=order_items dates=invoice_date/>

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
where invoice_date >= '${inputs.range.start}' and invoice_date <= '${inputs.range.end}'
group by all
order by 1 desc
```

```seasons
select '2011-11-01' as start_date, '2011-11-28' as end_date, 'Black Friday' as name
```

<BigValue
    data={order_volume} value=sales comparison=sales_growth_pct comparisonTitle="last week" fmt=usd/>
<BigValue
    data={order_volume} value=orders comparison=orders_growth_pct comparisonTitle="last week"/>
<BigValue
    data={order_volume} value=aov title="AOV" comparison=aov_growth_pct comparisonTitle="last week" fmt=usd/>

<LineChart
    data={order_volume}
    yAxisTitle="in Sales"
    y=sales
    yFmt=usd
    yMax=500000
    echartsOptions={{
color: [
  // '#003f5c', // Dark Teal
  // '#2f4b7c', // Royal Blue
  // '#665191', // Deep Purple
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
      yAxis: { axisLabel: { fontSize: 11.5 } },
      xAxis: {
          axisTick: {
            show: false
          }
        },
      textStyle: { fontFamily: 'Playfair Display'},
      grid: { left: 6 }
    }}
>
  <ReferenceArea data={seasons} xMin=start_date xMax=end_date label=name color=red/>
</LineChart>
