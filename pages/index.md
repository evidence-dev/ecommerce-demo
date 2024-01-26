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
group by all
order by 1 desc

```

```seasons
select '2011-11-01' as start_date, '2011-11-28' as end_date, 'Black Friday' as name
```

<!-- <Alert class="border rounded px-4 py-2" status="success">

Et officia sit ea ex tempor dolor esse aute. Magna ad nisi cillum nulla reprehenderit proident adipisicing dolore consectetur magna ut elit.

</Alert> -->

<BigValue data={order_volume} value=sales comparison=sales_growth_pct comparisonTitle="last week" fmt=usd/>
<BigValue data={order_volume} value=orders comparison=orders_growth_pct comparisonTitle="last week"/>
<BigValue data={order_volume} value=aov title="AOV" comparison=aov_growth_pct comparisonTitle="last week" fmt=usd/>

<LineChart 
  data={order_volume} 
  yAxisTitle="in Sales" 
  y=sales 
  yFmt=usd 
  yMax=500000  
  echartsOptions={{
      color: ['#2165b0', '#7a7fbd', '#57b4ad', '#8cb87a'],
      textStyle: { fontFamily: 'Plus Jakarta Sans'},
      xAxis: {
        axisTick: {
          show: false
        }
      }
    }}
>
  <ReferenceArea data={seasons} xMin=start_date xMax=end_date label=name/>
</LineChart>

<!-- <ButtonGroup name=period>
    <ButtonGroupItem valueLabel="Weekly" value="week" />
    <ButtonGroupItem valueLabel="Daily" value="day" />
    <ButtonGroupItem valueLabel="Monthly" value="month" />
</ButtonGroup> -->

<!-- <Alert class="border rounded px-4 py-2">

# Action item

Et officia sit ea ex tempor dolor esse aute. Magna ad nisi cillum nulla reprehenderit proident adipisicing dolore consectetur magna ut elit.

</Alert>

<Alert class="border rounded px-4 py-2">

# Action item

Et officia sit ea ex tempor dolor esse aute. Magna ad nisi cillum nulla reprehenderit proident adipisicing dolore consectetur magna ut elit.

</Alert> -->
