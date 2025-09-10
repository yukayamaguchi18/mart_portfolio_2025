-- 顧客
COPY customer FROM '/data/customer.csv' WITH (FORMAT csv, HEADER true);

-- 配送
COPY delivery FROM '/data/delivery.csv' WITH (FORMAT csv, HEADER true);

-- 商品
COPY product FROM '/data/product.csv' WITH (FORMAT csv, HEADER true);

-- キャンペーン
COPY campaign FROM '/data/campaign.csv' WITH (FORMAT csv, HEADER true);

-- 広告
COPY ad FROM '/data/ad.csv' WITH (FORMAT csv, HEADER true);

-- サブスクリプション
COPY subscription FROM '/data/subscription.csv' WITH (FORMAT csv, HEADER true);

-- 受注ヘッダ
COPY order_header FROM '/data/order_header.csv' WITH (FORMAT csv, HEADER true);

-- 受注明細
COPY order_detail FROM '/data/order_detail.csv' WITH (FORMAT csv, HEADER true);

-- 出荷ヘッダ
COPY shipment_header FROM '/data/shipment_header.csv' WITH (FORMAT csv, HEADER true);

-- 出荷明細
COPY shipment_detail FROM '/data/shipment_detail.csv' WITH (FORMAT csv, HEADER true);

-- 広告トラッキング
COPY ad_tracking FROM '/data/ad_tracking.csv' WITH (FORMAT csv, HEADER true);
