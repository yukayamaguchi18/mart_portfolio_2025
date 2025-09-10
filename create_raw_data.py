import pandas as pd
import random
import os
from faker import Faker
from datetime import timedelta
fake = Faker("ja_JP")

# ------------------------
# 出力フォルダ
# ------------------------
output_dir = "data"
os.makedirs(output_dir, exist_ok=True)

# ------------------------
# マスタ件数設定
# ------------------------
num_customers = 50
num_deliveries = 80
num_products = 20
num_campaigns = 10
num_ads = 10
num_orders = 100
num_subscriptions = 20
num_tracking = 200

# ------------------------
# 顧客マスタ
# ------------------------
customers = []
for i in range(1, num_customers+1):
    gender = random.choice(['男','女'])
    customers.append({
        '顧客ID': f"C{i:04d}",
        '苗字': fake.last_name(),
        '名前': fake.first_name_male() if gender=='男' else fake.first_name_female(),
        '苗字カナ': fake.last_kana_name(),
        '名前カナ': fake.first_kana_name(),
        '誕生日': fake.date_of_birth(minimum_age=18, maximum_age=70),
        '性別': gender,
        '会員区分': random.choice(['通常会員','サブスク会員']),
        '入会日': fake.date_between(start_date='-5y', end_date='today'),
        'メールアドレス': fake.email(),
        'メルマガ送信許可区分': random.choice([0,1]),
        '電話番号': fake.phone_number(),
        '電話許可区分': random.choice([0,1]),
        'デフォルトお届け先ID': f"D{random.randint(1,num_deliveries):04d}",
        'ダイレクトメール送付許可区分': random.choice([0,1])
    })
df_customers = pd.DataFrame(customers)

# ------------------------
# お届け先マスタ
# ------------------------
deliveries = []
for i in range(1, num_deliveries+1):
    deliveries.append({
        'お届け先ID': f"D{i:04d}",
        '顧客ID': f"C{random.randint(1,num_customers):04d}",
        '郵便番号': fake.postcode(),
        '都道府県': fake.prefecture(),
        '市区町村': fake.city(),
        '番地以降': fake.street_address()
    })
df_deliveries = pd.DataFrame(deliveries)

# ------------------------
# 商品マスタ
# ------------------------
products = []
for i in range(1, num_products+1):
    line = random.choice(['フローラル','ピュア','ナチュラル'])
    category = random.choice(['本品','トライアル'])
    products.append({
        '商品ID': f"P{i:04d}",
        '商品名': f"{line}商品{i}",
        '商品ライン': line,
        '商品カテゴリ': category,
        '価格': random.randint(500,5000)
    })
df_products = pd.DataFrame(products)

# ------------------------
# キャンペーンマスタ
# ------------------------
campaigns = []
for i in range(1, num_campaigns+1):
    campaigns.append({
        'キャンペーンID': f"CP{i:03d}",
        'キャンペーン名': f"キャンペーン{i}",
        'キャンペーンカテゴリ': random.choice(['入会','セール','トライアル'])
    })
df_campaigns = pd.DataFrame(campaigns)

# ------------------------
# 広告マスタ
# ------------------------
ads = []
for i in range(1, num_ads+1):
    ads.append({
        '広告ID': f"AD{i:03d}",
        '広告名': f"広告{i}",
        '広告カテゴリ': random.choice(['SNS','リスティング','オフライン'])
    })
df_ads = pd.DataFrame(ads)

# ------------------------
# サブスク契約テーブル
# ------------------------
subscriptions = []
for i in range(1, num_subscriptions+1):
    customer_id = f"C{random.randint(1,num_customers):04d}"
    product_id = f"P{random.randint(1,num_products):04d}"
    contract_date = fake.date_between(start_date='-3y', end_date='today')
    subscriptions.append({
        'サブスク契約ID': f"S{i:04d}",
        '顧客ID': customer_id,
        '契約ステータス': random.choice(['有効','解約']),
        '契約日': contract_date,
        '解約日': fake.date_between(start_date=contract_date, end_date='today') if random.random()<0.3 else None,
        '商品ID': product_id,
        'キャンペーンID': random.choice(df_campaigns['キャンペーンID'].tolist() + [None])
    })
df_subscriptions = pd.DataFrame(subscriptions)

# ------------------------
# 受注ヘッダー
# ------------------------
orders = []
for i in range(1, num_orders+1):
    customer_id = f"C{random.randint(1,num_customers):04d}"
    order_date = fake.date_between(start_date='-2y', end_date='today')
    orders.append({
        '受注ID': f"O{i:04d}",
        '顧客ID': customer_id,
        '受注日': order_date,
        '受注ステータス': random.choice(['完了','キャンセル','未処理']),
        '合計金額': random.randint(1000,10000)
    })
df_orders = pd.DataFrame(orders)

# ------------------------
# 受注明細
# ------------------------
order_details = []
for order_id in df_orders['受注ID']:
    num_items = random.randint(1,2)
    for _ in range(num_items):
        sub_flag = random.random() < 0.3
        sub_id = None
        if sub_flag and not df_subscriptions.empty:
            sub_id = random.choice(df_subscriptions['サブスク契約ID'].tolist())
        order_details.append({
            '受注ID': order_id,
            '商品ID': f"P{random.randint(1,num_products):04d}",
            '受注区分': 'サブスク' if sub_id else 'スポット',
            'サブスク契約ID': sub_id,
            '数量': random.randint(1,3),
            'キャンペーンID': random.choice(df_campaigns['キャンペーンID'].tolist() + [None])
        })
df_order_details = pd.DataFrame(order_details)

# ------------------------
# 出荷ヘッダー
# ------------------------
shipments = []
for i, row in df_orders.iterrows():
    ship_date = fake.date_between(start_date=row['受注日'], end_date='today')
    shipments.append({
        '出荷ID': f"S{i+1:04d}",
        '顧客ID': row['顧客ID'],
        '出荷日': ship_date,
        '出荷ステータス': random.choice(['出荷済み','キャンセル','未出荷']),
        '合計金額': row['合計金額']
    })
df_shipments = pd.DataFrame(shipments)

# ------------------------
# 出荷明細
# ------------------------
shipment_details = []
for shipment_id in df_shipments['出荷ID']:
    num_items = random.randint(1,2)
    for _ in range(num_items):
        sub_flag = random.random() < 0.3
        sub_id = None
        if sub_flag and not df_subscriptions.empty:
            sub_id = random.choice(df_subscriptions['サブスク契約ID'].tolist())
        shipment_details.append({
            '出荷ID': shipment_id,
            '商品ID': f"P{random.randint(1,num_products):04d}",
            '出荷区分': 'サブスク' if sub_id else 'スポット',
            'サブスク契約ID': sub_id,
            '数量': random.randint(1,3),
            'キャンペーンID': random.choice(df_campaigns['キャンペーンID'].tolist() + [None])
        })
df_shipment_details = pd.DataFrame(shipment_details)

# ------------------------
# 広告トラッキング (現実的な日付)
# ------------------------
tracking = []
tracking_types = ['クリック','コンバージョン','表示']
for i in range(1, num_tracking+1):
    customer_id = f"C{random.randint(1,num_customers):04d}"
    ad_id = f"AD{random.randint(1,num_ads):03d}"
    track_type = random.choice(tracking_types)
    
    order_id = None
    track_date = None
    
    if track_type == 'コンバージョン':
        # コンバージョンは受注IDに紐付け、日付は受注日以降
        order_row = df_orders.sample(1).iloc[0]
        order_id = order_row['受注ID']
        track_date = fake.date_between(start_date=order_row['受注日'], end_date='today')
    else:
        # クリックや表示は受注日以前またはランダム
        order_row = df_orders.sample(1).iloc[0]
        track_date = fake.date_between(start_date=order_row['受注日'] - timedelta(days=30), end_date=order_row['受注日'])
    
    tracking.append({
        'トラッキングID': f"T{i:04d}",
        '顧客ID': customer_id,
        '広告ID': ad_id,
        'トラッキング区分': track_type,
        '受注ID': order_id,
        'トラッキング日': track_date
    })
df_tracking = pd.DataFrame(tracking)

# ------------------------
# CSV出力
# ------------------------
df_customers.to_csv(os.path.join(output_dir,"customer.csv"), index=False)
df_deliveries.to_csv(os.path.join(output_dir,"delivery.csv"), index=False)
df_products.to_csv(os.path.join(output_dir,"product.csv"), index=False)
df_campaigns.to_csv(os.path.join(output_dir,"campaign.csv"), index=False)
df_ads.to_csv(os.path.join(output_dir,"ad.csv"), index=False)
df_subscriptions.to_csv(os.path.join(output_dir,"subscription.csv"), index=False)
df_orders.to_csv(os.path.join(output_dir,"order_header.csv"), index=False)
df_order_details.to_csv(os.path.join(output_dir,"order_detail.csv"), index=False)
df_shipments.to_csv(os.path.join(output_dir,"shipment_header.csv"), index=False)
df_shipment_details.to_csv(os.path.join(output_dir,"shipment_detail.csv"), index=False)
df_tracking.to_csv(os.path.join(output_dir,"ad_tracking.csv"), index=False)

print("すべてのCSVファイルを data/ フォルダに生成しました！")