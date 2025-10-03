-- 定期購入マート
create table dm_subscription as
select
    s.subscription_id,
    s.customer_id,
    s.product_id,
    s.contract_date,
    s.cancel_date,
    s.status,
    count(distinct o.order_id) as total_orders,
    sum(o.total_amount) as total_amount,
    max(o.order_date) as last_order_date
from subscription s
left join order_detail od
    on s.subscription_id = od.subscription_id
left join order_header o
    on od.order_id = o.order_id
group by
    s.subscription_id,
    s.customer_id,
    s.product_id,
    s.contract_date,
    s.cancel_date,
    s.status;
