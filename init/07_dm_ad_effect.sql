-- 広告効果マート
create table dm_ad_effect as
select
    a.ad_id,
    a.ad_name,
    a.ad_category,
    count(case when t.tracking_type = 'Impression' then 1 end) as impressions,
    count(case when t.tracking_type = 'Click' then 1 end) as clicks,
    count(case when t.tracking_type = 'Conversion' then 1 end) as conversions,
    count(distinct t.order_id) as total_orders,
    sum(o.total_amount) as total_amount
from ad a
left join ad_tracking t
    on a.ad_id = t.ad_id
left join order_header o
    on t.order_id = o.order_id
group by
    a.ad_id,
    a.ad_name,
    a.ad_category;
