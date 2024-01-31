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

<CohortTable data={cohort_retention_pivot} periodTitle="Cohort Month"/>


```sql initial_cohort_revenue
select
  c.cohort_month,
  cs.cohort_size,
  sum(oi.quantity * oi.unitprice) as initial_revenue
from ecommerce.customers c
left join ecommerce.order_items oi on c.customerID = oi.customerID
left join ${cohort_size} cs on c.cohort_month = cs.cohort_month
where date_diff('month', c.cohort_month, date_trunc('month', oi.invoice_date)) = 0
group by 1,2
```


```sql dollar_retention
select
  c.cohort_month,
  icr.cohort_size,
  'Month' || lpad(date_diff('month', c.cohort_month, date_trunc('month', oi.invoice_date))::varchar, 2, '0') || '_pct' as month_offset,
  sum(oi.quantity * oi.unitprice) / first(icr.initial_revenue) as dollar_retention
from ecommerce.customers c
left join ecommerce.order_items oi on c.customerID = oi.customerID
left join ${initial_cohort_revenue} icr on c.cohort_month = icr.cohort_month
group by all
order by 1, 2
```

```sql dollar_retention_pivot
PIVOT ${dollar_retention} ON month_offset USING first(dollar_retention)
```


## Dollar Retention

Dollar Retention measures the total revenue earned from each customer cohort monthly, as a percentage of the cohort's initial revenue. It is possible to achieve dollar retention greater than 100%.

<CohortTable data={dollar_retention_pivot} periodTitle="Cohort Month"/>


