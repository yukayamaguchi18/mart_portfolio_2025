-- Customer
CREATE TABLE customer (
    customer_id TEXT PRIMARY KEY,
    last_name TEXT,
    first_name TEXT,
    last_name_kana TEXT,
    first_name_kana TEXT,
    birth_date DATE,
    gender TEXT,
    member_type TEXT,
    join_date DATE,
    email TEXT,
    allow_email INT,
    phone TEXT,
    allow_phone INT,
    default_delivery_id TEXT,
    allow_dm INT
);
COPY customer FROM '/data/customer.csv' WITH (FORMAT csv, HEADER true);

-- Delivery
CREATE TABLE delivery (
    delivery_id TEXT PRIMARY KEY,
    customer_id TEXT,
    zipcode TEXT,
    prefecture TEXT,
    city TEXT,
    address TEXT
);
COPY delivery FROM '/data/delivery.csv' WITH (FORMAT csv, HEADER true);

-- Product
CREATE TABLE product (
    product_id TEXT PRIMARY KEY,
    product_name TEXT,
    product_line TEXT,
    product_category TEXT,
    price INT
);
COPY product FROM '/data/product.csv' WITH (FORMAT csv, HEADER true);

-- Campaign
CREATE TABLE campaign (
    campaign_id TEXT PRIMARY KEY,
    campaign_name TEXT,
    campaign_category TEXT
);
COPY campaign FROM '/data/campaign.csv' WITH (FORMAT csv, HEADER true);

-- Ad
CREATE TABLE ad (
    ad_id TEXT PRIMARY KEY,
    ad_name TEXT,
    ad_category TEXT
);
COPY ad FROM '/data/ad.csv' WITH (FORMAT csv, HEADER true);

-- Subscription
CREATE TABLE subscription (
    subscription_id TEXT PRIMARY KEY,
    customer_id TEXT,
    status TEXT,
    contract_date DATE,
    cancel_date DATE,
    product_id TEXT,
    campaign_id TEXT
);
COPY subscription FROM '/data/subscription.csv' WITH (FORMAT csv, HEADER true);

-- Order Header
CREATE TABLE order_header (
    order_id TEXT PRIMARY KEY,
    customer_id TEXT,
    order_date DATE,
    status TEXT,
    total_amount INT
);
COPY order_header FROM '/data/order_header.csv' WITH (FORMAT csv, HEADER true);

-- Order Detail
CREATE TABLE order_detail (
    order_id TEXT,
    product_id TEXT,
    order_type TEXT,
    subscription_id TEXT,
    quantity INT,
    campaign_id TEXT
);
COPY order_detail FROM '/data/order_detail.csv' WITH (FORMAT csv, HEADER true);

-- Shipment Header
CREATE TABLE shipment_header (
    shipment_id TEXT PRIMARY KEY,
    customer_id TEXT,
    shipment_date DATE,
    status TEXT,
    total_amount INT
);
COPY shipment_header FROM '/data/shipment_header.csv' WITH (FORMAT csv, HEADER true);

-- Shipment Detail
CREATE TABLE shipment_detail (
    shipment_id TEXT,
    product_id TEXT,
    shipment_type TEXT,
    subscription_id TEXT,
    quantity INT,
    campaign_id TEXT
);
COPY shipment_detail FROM '/data/shipment_detail.csv' WITH (FORMAT csv, HEADER true);

-- Ad Tracking
CREATE TABLE ad_tracking (
    tracking_id TEXT PRIMARY KEY,
    customer_id TEXT,
    ad_id TEXT,
    tracking_type TEXT,
    order_id TEXT,
    tracking_date DATE
);
COPY ad_tracking FROM '/data/ad_tracking.csv' WITH (FORMAT csv, HEADER true);
