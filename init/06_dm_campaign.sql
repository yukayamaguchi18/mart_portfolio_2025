-- キャンペーン効果マート
create table dm_campaign as
select
    c.campaign_id,
    c.campaign_name,
    c.campaign_category,
    count(distinct od.order_id) as total_orders,
    count(distinct o.customer_id) as total_customers,
    sum(o.total_amount) as total_amount,
    avg(o.total_amount) as avg_order_amount,
    count(distinct case when s.subscription_id is not null then s.customer_id end) as subscription_started
from campaign c
left join order_detail od
    on c.campaign_id = od.campaign_id
left join order_header o
    on od.order_id = o.order_id
left join subscription s
    on c.campaign_id = s.campaign_id
group by
    c.campaign_id,
    c.campaign_name,
    c.campaign_category;
