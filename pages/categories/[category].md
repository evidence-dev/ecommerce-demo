# {params.category}

```sql products
select
    Description,
    StockCode,
    sum(Quantity) as products_sold,
    sum(UnitPrice*Quantity) as total_sales,
    case
        when Description ilike '%bag%' then 'Bags'
        when Description ilike '%mug%' then 'Mugs'
        when Description ilike '%jar%' then 'Jars'
        when Description ilike '%holder%' then 'Holders'
        when Description ilike '%craft%' then 'Crafts'
        when Description ilike '%decoration%' then 'Decorations'
        else 'Other'
    end as category,
    '?stockcode=' || StockCode as link
from ecommerce.order_items
where category = '${params.category}'
group by 1,2
order by 3 desc
```

<DataTable
    data={products}
    link=link
    search
    rows=5
/>


<Dropdown data={products} value="StockCode" label="Description" name="stockcode" />


```sql product_details
select
    InvoiceNo,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Description
from ecommerce.order_items
where StockCode = '${inputs.stockcode}'
```

```sql orders_by_month
select
    date_trunc('month', InvoiceDate) as month,
    sum(Quantity) as products_sold
from ecommerce.order_items
where StockCode = '${inputs.stockcode}'
group by 1
order by 1
```





{#if product_details.length > 0}

## Orders for {product_details[0].Description}

<div class="grid grid-cols-1 gap-4 md:grid-cols-2">

<DataTable data={product_details} rows=7/>

<LineChart
    data={orders_by_month}
    x=month
    y=products_sold
    title="Quantity sold by Month"
/>

</div>

{:else}

Select a product to see details

{/if}







