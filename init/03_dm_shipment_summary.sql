create table dm_shipment_summary as
select
    sh.shipment_id,
    sh.customer_id,
    sh.shipment_date,
    count(*) over(
        partition by sh.customer_id
        order by sh.shipment_date
        rows between unbounded preceding and current row
    ) as customer_frequency,
    sh.shipment_status,
    case
        when bool_or(p.product_category = '本品') then 'include_main'
        else 'trial_only'
    end as shipment_category1,
    case
        when bool_or(sd.shipment_type = 'サブスク') then 'include_subscription'
        else 'spot_only'
    end as shipment_category2,
    string_agg(distinct sd.product_id, ',') as shipment_product_ids,
    string_agg(distinct p.product_name, ',') as shipment_product_names,
    sh.total_amount,
    sum(sd.quantity) as total_quantity,
    sum(case when p.product_category = '本品' then sd.quantity else 0 end) as main_quantity,
    sum(case when p.product_category = 'トライアル' then sd.quantity else 0 end) as trial_quantity
from shipment_header sh
join shipment_detail sd on sh.shipment_id = sd.shipment_id
join product p on sd.product_id = p.product_id
group by
    sh.shipment_id, sh.customer_id, sh.shipment_date,
    sh.shipment_status, sh.total_amount;
