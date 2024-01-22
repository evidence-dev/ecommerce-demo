select 
    *,
    date_trunc('day',strptime(InvoiceDate, '%m/%d/%Y %H:%M')) as invoice_date
 from data