create table dm_customer as
with age_calc as (
    select
        customer_id,
        extract(year from age(current_date, birth_date))::int as age
    from customer
),
sub_count as (
    select customer_id, count(distinct subscription_id) as subscription_count
    from subscription
    where status = 'Active'
    group by customer_id
),
f1 as (
    select distinct on (customer_id) customer_id, shipment_id as f1_shipment_id
    from dm_shipment_summary
    order by customer_id, shipment_date
),
f2 as (
    select customer_id, shipment_id as f2_shipment_id
    from (
        select customer_id, shipment_id,
               row_number() over(partition by customer_id order by shipment_date) as rn
        from dm_shipment_summary
    ) t
    where rn = 2
),
ad_f1 as (
    select distinct on (customer_id) customer_id, tracking_id as f1_tracking_id
    from ad_tracking
    order by customer_id, tracking_date
),
ad_f2 as (
    select customer_id, tracking_id as f2_tracking_id
    from (
        select customer_id, tracking_id,
               row_number() over(partition by customer_id order by tracking_date) as rn
        from ad_tracking
    ) t
    where rn = 2
),
rfm as (
    select
        customer_id,
        max(shipment_date) as last_shipment_date,
        count(*) as f,
        sum(total_amount) as m,
        sum(case when shipment_date >= date_trunc('year', current_date) then total_amount else 0 end) as m_this_year,
        sum(case when shipment_date >= current_date - interval '12 months' then total_amount else 0 end) as m_last_12m
    from dm_shipment_summary
    group by customer_id
)
select
    c.customer_id,
    a.age,
    (a.age/10*10)::int as age_group,
    coalesce(s.subscription_count,0) as subscription_count,
    f1.f1_shipment_id,
    f2.f2_shipment_id,
    adf1.f1_tracking_id,
    adf2.f2_tracking_id,
    (current_date - r.last_shipment_date)::int as r,
    r.f,
    r.m,
    r.m_this_year,
    r.m_last_12m
from customer c
join age_calc a on c.customer_id = a.customer_id
left join sub_count s on c.customer_id = s.customer_id
left join f1 on c.customer_id = f1.customer_id
left join f2 on c.customer_id = f2.customer_id
left join ad_f1 adf1 on c.customer_id = adf1.customer_id
left join ad_f2 adf2 on c.customer_id = adf2.customer_id
left join rfm r on c.customer_id = r.customer_id;
