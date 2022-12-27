delete from mart.f_customer_retention 
where period_id = concat(date_part('year', '{{ds}}'::date - {{ params.date_delta }}), '-', date_part('week', '{{ds}}'::date - {{ params.date_delta }}));

with for_f_customer_retention as (
select 
	 concat(dc.year_actual, '-', dc.week_of_year) as period_id 
	,fs1.customer_id 
	,fs1.id 
	,fs1.item_id 
	,fs1.payment_amount 
	,case 
		when fs1.payment_amount > 0 then 'shipped'
		else 'refunded'
	 end status
from mart.f_sales fs1
inner join mart.d_calendar dc 
	on fs1.date_id = dc.date_id 
where concat(dc.year_actual, '-', dc.week_of_year) = concat(date_part('year', '{{ds}}'::date - {{ params.date_delta }}), '-', date_part('week', '{{ds}}'::date - {{ params.date_delta }}))
order by 
	 period_id
	,customer_id
), 

for_f_customer_retention_2 as (
select 
	 period_id
	,customer_id
	,item_id
	,count(case when status = 'shipped' then '1' end) as count_orders
	,count(case when status = 'refunded' then '1' end) as count_returns
	,sum(payment_amount) as payment_amount
from for_f_customer_retention
group by 
	 period_id
	,customer_id
	,item_id
order by customer_id
)

insert into mart.f_customer_retention 
select 
	 count(distinct case when count_orders = 1 then customer_id end) as new_customers_count
	,count(distinct case when count_orders > 1 then customer_id end) as returning_customers_count
	,count(distinct case when count_returns > 0 then customer_id end) as refunded_customer_count
	,'weekly' as period_name 
	,period_id
	,item_id
	,sum(case when count_orders = 1 then payment_amount end) as new_customers_revenue 
	,sum(case when count_orders > 1 then payment_amount end) as returning_customers_revenue
	,count(case when count_returns > 0 then customer_id end) as customers_refunded
from for_f_customer_retention_2
group by 
	 period_id
	,item_id
order by 
	 period_id
	,item_id
	

	
 
	