delete from mart.f_sales
where date_id = (replace('{{ds}}', '-', '')::integer - {{ params.date_delta }});

insert into mart.f_sales (date_id, item_id, customer_id, city_id, quantity, payment_amount)
select 
     dc.date_id
    ,uol.item_id
    ,uol.customer_id
    ,uol.city_id
    ,uol.quantity
    ,case 
	    when uol.status = 'refunded' 
	    	then -uol.payment_amount 
	    else uol.payment_amount 
	 end as payment_amount
from staging.user_order_log uol
left join mart.d_calendar as dc 
    on uol.date_time::Date = dc.date_actual
where uol.date_time::Date = ('{{ds}}'::date - {{ params.date_delta }});