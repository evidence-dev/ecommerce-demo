# Retention

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

## Customer Retention

Customer Retention measures the percentage of each monthly customer cohort that purchases in a future month. Customer retention, cannot exceed 100%.

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

## Dollar Retention

Dollar Retention measures the total revenue earned from each customer cohort monthly, as a percentage of the cohort's initial revenue. It is possible to achieve dollar retention greater than 100%.

<DataTable data={cohort_retention_pivot} rows=all title="Dollar retention, months">
  <Column id='cohort_month' title='Cohort' fmt='mmm yyyy'/>
  <Column id='cohort_size' title='Cohort Size' fmt='usd'/>
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

## Blue Onion Benchmarks

<div class="rounded px-2  border-3 border-dashed w-full h-72 border-blue-200 border bg-blue-50 text-lg flex items-center mt-4 font-bold text-blue-900">
<span class="mx-auto">
Benchmark Data Available on the Premiere Plan
</span>
</div>
