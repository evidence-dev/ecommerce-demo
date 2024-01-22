select DISTINCT
    CustomerID,
    count(DISTINCT InvoiceNo) as total_orders,
    MIN(invoice_date) as first_order,
    count(InvoiceNo) as total_items,
    sum(UnitPrice*Quantity) as total_spent
from ${order_items}
group by 1