delete from staging.user_order_log
where date_time::date = ('{{ds}}'::date - {{ params.date_delta }});

alter table staging.user_order_log add column if not exists status varchar(30);