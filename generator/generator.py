import os
import random
from datetime import datetime, timedelta, timezone

import psycopg2
from psycopg2.extras import execute_values
from faker import Faker

fake = Faker("uk_UA")

TABLES = [
    "purchase_order_items",
    "purchase_orders",
    "facility_inventory",
    "facilities",
    "supplier_price_history",
    "supplier_products",
    "suppliers",
    "products",
    "manufacturers",
    "product_categories",
]

UKR_LOCATIONS = [
    ("Київ", "м. Київ", 50.4501, 30.5234, 14),
    ("Львів", "Львівська", 49.8397, 24.0297, 8),
    ("Харків", "Харківська", 49.9935, 36.2304, 9),
    ("Одеса", "Одеська", 46.4825, 30.7233, 8),
    ("Дніпро", "Дніпропетровська", 48.4647, 35.0462, 8),
    ("Запоріжжя", "Запорізька", 47.8388, 35.1396, 5),
    ("Вінниця", "Вінницька", 49.2331, 28.4682, 4),
    ("Полтава", "Полтавська", 49.5883, 34.5514, 3),
    ("Чернігів", "Чернігівська", 51.4982, 31.2893, 3),
    ("Черкаси", "Черкаська", 49.4444, 32.0598, 3),
    ("Суми", "Сумська", 50.9077, 34.7981, 2),
    ("Житомир", "Житомирська", 50.2547, 28.6587, 2),
    ("Івано-Франківськ", "Івано-Франківська", 48.9226, 24.7111, 2),
    ("Ужгород", "Закарпатська", 48.6208, 22.2879, 1),
    ("Чернівці", "Чернівецька", 48.2921, 25.9358, 1),
    ("Тернопіль", "Тернопільська", 49.5535, 25.5948, 1),
    ("Кропивницький", "Кіровоградська", 48.5079, 32.2623, 1),
    ("Миколаїв", "Миколаївська", 46.9750, 31.9946, 2),
    ("Херсон", "Херсонська", 46.6354, 32.6169, 1),
    ("Рівне", "Рівненська", 50.6199, 26.2516, 1),
    ("Луцьк", "Волинська", 50.7472, 25.3254, 1),
]

PRODUCT_CATEGORIES = [
    ("Напої", None, "Вода, соки, газовані напої, енергетики"),
    ("Кава та чай", None, "Кава, чай, какао"),
    ("Молочні продукти", None, "Молоко, йогурти, сир"),
    ("М'ясо та ковбаси", None, "Ковбаси, сосиски, м'ясні вироби"),
    ("Риба та морепродукти", None, "Риба, морепродукти, консерви"),
    ("Хліб та випічка", None, "Хліб, булочки, випічка"),
    ("Крупи та макарони", None, "Рис, гречка, паста"),
    ("Бакалія", None, "Олія, соуси, спеції"),
    ("Снеки", None, "Чипси, горішки, сухарики"),
    ("Солодощі", None, "Печиво, шоколад, цукерки"),
    ("Заморожені продукти", None, "Пельмені, овочі, морозиво"),
    ("Овочі та фрукти", None, "Свіжі овочі та фрукти"),
    ("Консерви", None, "Овочеві та м'ясні консерви"),
    ("Дитяче харчування", None, "Пюре, каші, суміші"),
    ("Корм для тварин", None, "Сухий і вологий корм"),
    ("Побутова хімія", None, "Пральні та мийні засоби"),
    ("Гігієна", None, "Шампуні, мило, зубна паста"),
    ("Паперова продукція", None, "Серветки, туалетний папір, рушники"),
    ("Канцелярія", None, "Зошити, ручки, офісні товари"),
    ("Посуда та кухонні товари", None, "Контейнери, губки, фольга"),
    ("Алкогольні напої (демо)", None, "Для демо-даних (без реального використання)"),
    ("Безалкогольне пиво (демо)", None, "Для демо-даних"),
    ("Аптека (демо)", None, "Базові товари для демо"),
    ("Електроніка (демо)", None, "Дрібна електроніка для демо"),
    ("Інше", None, "Різне"),
]

MANUFACTURERS = [
    ("Roshen", "Україна"),
    ("Nestle", "Швейцарія"),
    ("Coca-Cola", "США"),
    ("PepsiCo", "США"),
    ("Danone", "Франція"),
    ("Unilever", "Велика Британія"),
    ("Procter & Gamble", "США"),
    ("Mondelez", "США"),
    ("Kraft Heinz", "США"),
    ("Ferrero", "Італія"),
    ("Mars", "США"),
    ("Kellogg's", "США"),
    ("Barilla", "Італія"),
    ("Heineken", "Нідерланди"),
    ("Carlsberg", "Данія"),
    ("Lactalis", "Франція"),
    ("Arla", "Данія"),
    ("Bonduelle", "Франція"),
    ("Dr. Oetker", "Німеччина"),
    ("Oriflame", "Швеція"),
    ("Henkel", "Німеччина"),
    ("Colgate-Palmolive", "США"),
    ("Kimberly-Clark", "США"),
    ("Reckitt", "Велика Британія"),
    ("Johnson & Johnson", "США"),
    ("LG", "Південна Корея"),
    ("Samsung", "Південна Корея"),
    ("Sony", "Японія"),
    ("Philips", "Нідерланди"),
    ("Bosch", "Німеччина"),
    ("Xiaomi", "Китай"),
    ("Huawei", "Китай"),
    ("Lenovo", "Китай"),
    ("Canon", "Японія"),
    ("HP", "США"),
    ("IKEA", "Швеція"),
    ("Tefal", "Франція"),
    ("Dove", "Велика Британія"),
    ("Nivea", "Німеччина"),
    ("Generic Foods", "Україна"),
]

CATEGORY_PRODUCTS = {
    "Напої": ["Вода мінеральна", "Сік яблучний", "Сік апельсиновий", "Напій газований", "Енергетик"],
    "Кава та чай": ["Кава мелена", "Кава розчинна", "Чай чорний", "Чай зелений", "Какао"],
    "Молочні продукти": ["Молоко", "Йогурт", "Кефір", "Сир кисломолочний", "Сметана"],
    "М'ясо та ковбаси": ["Ковбаса варена", "Ковбаса копчена", "Сосиски", "Шинка", "Паштет"],
    "Риба та морепродукти": ["Тунець консервований", "Сардина", "Оселедець", "Креветки", "Кальмар"],
    "Хліб та випічка": ["Хліб пшеничний", "Хліб житній", "Булочка", "Круасан", "Печиво здобне"],
    "Крупи та макарони": ["Рис", "Гречка", "Пшоно", "Макарони", "Вівсянка"],
    "Бакалія": ["Олія соняшникова", "Кетчуп", "Майонез", "Соєвий соус", "Сіль кухонна"],
    "Снеки": ["Чипси", "Горішки", "Сухарики", "Попкорн", "Крекери"],
    "Солодощі": ["Шоколад", "Печиво", "Цукерки", "Вафлі", "Мармелад"],
    "Заморожені продукти": ["Пельмені", "Вареники", "Овочі заморожені", "Піца заморожена", "Морозиво"],
    "Овочі та фрукти": ["Яблука", "Банани", "Помідори", "Огірки", "Апельсини"],
    "Консерви": ["Горошок консервований", "Кукурудза", "Квасоля", "Тушонка", "Томати у власному соку"],
    "Дитяче харчування": ["Пюре фруктове", "Пюре овочеве", "Каша дитяча", "Суміш дитяча", "Сік дитячий"],
    "Корм для тварин": ["Корм сухий", "Корм вологий", "Ласощі", "Наповнювач", "Вітаміни"],
    "Побутова хімія": ["Пральний порошок", "Гель для прання", "Засіб для посуду", "Чистячий засіб", "Відбілювач"],
    "Гігієна": ["Шампунь", "Мило", "Зубна паста", "Гель для душу", "Дезодорант"],
    "Паперова продукція": ["Туалетний папір", "Серветки", "Паперові рушники", "Хустинки", "Скатертина паперова"],
    "Канцелярія": ["Зошит", "Ручка", "Олівець", "Маркер", "Папір А4"],
    "Посуда та кухонні товари": ["Фольга", "Плівка харчова", "Губка", "Контейнер", "Пакети для сміття"],
    "Алкогольні напої (демо)": [
        "Пиво світле", "Пиво темне", "Вино червоне", "Вино біле", "Сидр",
        "Вермут", "Джин (демо)", "Ром (демо)", "Віскі (демо)"
    ],
    "Безалкогольне пиво (демо)": [
        "Пиво безалкогольне світле", "Пиво безалкогольне темне", "Пиво 0.0 класичне",
        "Пиво 0.0 пшеничне", "Пиво 0.0 зі смаком"
    ],
    "Аптека (демо)": [
        "Парацетамол", "Ібупрофен", "Вітамін C", "Пластир", "Бинт стерильний",
        "Антисептик", "Сольовий розчин", "Термометр (демо)", "Маска медична"
    ],
    "Електроніка (демо)": [
        "Навушники", "Кабель USB", "Зарядний пристрій", "Павербанк", "Ліхтарик",
        "Батарейки AA", "Батарейки AAA", "Мишка бездротова", "Флеш-накопичувач"
    ],
    "Інше": [
        "Запальничка", "Сірники", "Свічка", "Пакет", "Скотч",
        "Гумові рукавички", "Парасоля", "Подарунковий пакет"
    ],
}

def gen_pack_weight_g(category_name: str) -> int:
    options = {
        "Напої": [330, 500, 1000, 1500, 2000],
        "Кава та чай": [50, 100, 200, 250],
        "Молочні продукти": [200, 400, 500, 900, 1000],
        "М'ясо та ковбаси": [200, 300, 400, 500, 1000],
        "Риба та морепродукти": [120, 160, 200, 400, 1000],
        "Хліб та випічка": [300, 400, 500],
        "Крупи та макарони": [400, 800, 900, 1000, 2000],
        "Бакалія": [250, 400, 500, 750, 1000],
        "Снеки": [40, 70, 100, 150, 250],
        "Солодощі": [80, 100, 200, 300, 500],
        "Заморожені продукти": [300, 450, 500, 900, 1000],
        "Овочі та фрукти": [500, 1000, 1500, 2000],
        "Консерви": [240, 340, 400, 500],
        "Дитяче харчування": [90, 120, 180, 200, 350],
        "Корм для тварин": [100, 400, 1000, 2000, 10000],
        "Побутова хімія": [450, 750, 1000, 2000, 3000],
        "Гігієна": [100, 150, 250, 400, 500],
        "Паперова продукція": [300, 600, 900, 1200],
        "Канцелярія": [20, 50, 100, 200],
        "Посуда та кухонні товари": [50, 100, 150, 250],
        "Алкогольні напої (демо)": [330, 500, 700, 1000],
        "Безалкогольне пиво (демо)": [330, 500],
        "Аптека (демо)": [10, 20, 50, 100, 200],
        "Електроніка (демо)": [100, 150, 250, 400],
        "Інше": [50, 100, 200, 300],
    }

    arr = options.get(category_name)
    if not arr:
        return 100
    return random.choice(arr)

QUALITY_SUFFIX = {
    "Напої": ["", "", " без цукру", " з новим смаком", " класичний"],
    "Кава та чай": ["", "", " класичний", " міцний", " ароматний"],
    "Овочі та фрукти": ["", "", " свіжі", " відбірні"],
    "Побутова хімія": ["", "", " концентрат", " для кольорового", " для білого"],
    "Гігієна": ["", "", " для чутливої шкіри", " ароматизований"],
    "default": ["", "", "", " преміум", " економ", " натуральний"],
    "Алкогольні напої (демо)": ["", "", " класичне", " сухе", " напівсолодке", " витримане"],
    "Безалкогольне пиво (демо)": ["", "", " 0.0", " класичне", " світле", " темне"],
    "Аптека (демо)": ["", "", " форте", " дитяче", " м'яка дія"],
    "Електроніка (демо)": ["", "", " компактний", " швидка зарядка", " універсальний"],
    "Інше": ["", "", " стандарт", " посилений", " компактний"],
}


def random_ukraine_place():
    city, region, lat0, lon0, w = random.choices(
        UKR_LOCATIONS, weights=[x[4] for x in UKR_LOCATIONS], k=1
    )[0]
    lat = lat0 + random.gauss(0, 0.18)
    lon = lon0 + random.gauss(0, 0.25)
    lat = max(44.35, min(52.38, lat))
    lon = max(22.10, min(40.25, lon))
    return city, region, lat, lon


def env_int(name: str, default: int) -> int:
    v = os.getenv(name)
    return default if v is None else int(v)


def env_bool(name: str, default: bool) -> bool:
    v = os.getenv(name)
    if v is None:
        return default
    return v.strip().lower() in ("1", "true", "yes", "y", "on")


def money_str_from_cents(cents: int) -> str:
    return f"{cents / 100:.2f}"


def connect():
    db_url = os.getenv("DATABASE_URL")
    if not db_url:
        raise RuntimeError("DATABASE_URL is not set")
    return psycopg2.connect(db_url)


def truncate_all(cur):
    cur.execute("TRUNCATE " + ", ".join(TABLES) + " RESTART IDENTITY CASCADE;")


def chunked(seq, size):
    for i in range(0, len(seq), size):
        yield seq[i: i + size]


def fetch_ids(cur, table, id_col):
    cur.execute(f"SELECT {id_col} FROM {table} ORDER BY {id_col};")
    return [r[0] for r in cur.fetchall()]


def gen_product_name(category_name: str) -> str:
    base = random.choice(CATEGORY_PRODUCTS[category_name])

    suffix_list = QUALITY_SUFFIX.get(category_name, QUALITY_SUFFIX["default"])
    suffix = random.choice(suffix_list)

    if category_name == "Овочі та фрукти":
        return f"{base}{suffix}".strip()

    if random.random() < 0.25:
        return base

    return f"{base}{suffix}".strip()


def main():
    seed = env_int("SEED", 42)
    products_n = env_int("PRODUCTS", 5000)
    suppliers_n = env_int("SUPPLIERS", 300)
    facilities_n = env_int("FACILITIES", 40)
    orders_n = env_int("ORDERS", 6000)
    do_reset = env_bool("RESET", False)
    batch = env_int("BATCH", 2000)

    random.seed(seed)
    Faker.seed(seed)

    print(f"Generating started")

    with connect() as conn:
        conn.autocommit = False
        with conn.cursor() as cur:
            if do_reset:
                truncate_all(cur)

            # Insert lots of categories (reference data)
            cur.execute("SELECT name FROM product_categories;")
            existing_cat = {r[0] for r in cur.fetchall()}
            cat_rows = [(n, pid, d) for (n, pid, d) in PRODUCT_CATEGORIES if n not in existing_cat]
            if cat_rows:
                execute_values(cur, "INSERT INTO product_categories(name, parent_id, description) VALUES %s", cat_rows)

            cur.execute("SELECT category_id, name FROM product_categories ORDER BY category_id;")
            categories = cur.fetchall()
            category_ids = [c[0] for c in categories]
            category_name_by_id = {cid: name for cid, name in categories}

            # Insert lots of manufacturers (reference data)
            cur.execute("SELECT name FROM manufacturers;")
            existing_m = {r[0] for r in cur.fetchall()}
            manuf_rows = [(n, c) for (n, c) in MANUFACTURERS if n not in existing_m]
            if manuf_rows:
                execute_values(cur, "INSERT INTO manufacturers(name, country) VALUES %s", manuf_rows)

            manufacturer_ids = fetch_ids(cur, "manufacturers", "manufacturer_id")

            # Products
            cur.execute("SELECT code FROM products;")
            existing_codes = {r[0] for r in cur.fetchall()}

            prod_rows = []
            start_code = 100000
            for i in range(products_n):
                code = f"SKU-{start_code + i}"
                if code in existing_codes:
                    continue
                category_id = random.choice(category_ids)
                category_name = category_name_by_id.get(category_id, "Інше")
                name = gen_product_name(category_name)
                manufacturer_id = random.choice(manufacturer_ids) if random.random() < 0.9 else None
                pack_weight_g = gen_pack_weight_g(category_name)
                desc = fake.sentence(nb_words=12)
                price_cents = random.randint(800, 25000)
                prod_rows.append(
                    (category_id, manufacturer_id, code, name, pack_weight_g, desc, money_str_from_cents(price_cents)))

            for part in chunked(prod_rows, batch):
                execute_values(
                    cur,
                    """
                    INSERT INTO products(category_id, manufacturer_id, code, name, pack_weight_g, description, price)
                    VALUES
                    %s
                    """,
                    part,
                    template="(%s, %s, %s, %s, %s, %s, %s::money)",
                )

            cur.execute("SELECT product_id, (price::numeric) FROM products;")
            product_price_cents = {}
            product_ids = []
            for pid, price_num in cur.fetchall():
                product_ids.append(pid)
                product_price_cents[pid] = int(round(float(price_num) * 100))

            # Suppliers (Ukraine-wide)
            cur.execute("SELECT name FROM suppliers;")
            existing_s = {r[0] for r in cur.fetchall()}

            supp_rows = []
            for _ in range(suppliers_n):
                name = f"{fake.company()} LLC"
                if name in existing_s:
                    continue
                phone = fake.phone_number()
                rep = fake.name()
                address = fake.street_address()
                postal = fake.postcode()
                city, region, lat, lon = random_ukraine_place()
                supp_rows.append((name, phone, rep, address, city, region, postal, lat, lon))

            for part in chunked(supp_rows, batch):
                execute_values(
                    cur,
                    """
                    INSERT INTO suppliers(name, phone_main, representative_name, address, city, region, postal_code,
                                          latitude, longitude)
                    VALUES
                    %s
                    """,
                    part,
                )
            supplier_ids = fetch_ids(cur, "suppliers", "supplier_id")

            # Facilities (Ukraine-wide)
            cur.execute("SELECT name FROM facilities;")
            existing_f = {r[0] for r in cur.fetchall()}

            fac_rows = []
            for i in range(facilities_n):
                ftype = "warehouse" if i < max(1, facilities_n // 2) else "supermarket"
                name = f"{'WH' if ftype == 'warehouse' else 'SM'}-{i + 1}"
                if name in existing_f:
                    continue
                address_line1 = fake.street_address()
                address_line2 = None
                postal = fake.postcode()
                country_code = "UA"
                city, region, lat, lon = random_ukraine_place()
                fac_rows.append(
                    (ftype, name, address_line1, address_line2, city, region, postal, country_code, lat, lon))

            for part in chunked(fac_rows, batch):
                execute_values(
                    cur,
                    """
                    INSERT INTO facilities(type, name, address_line1, address_line2, city, region, postal_code,
                                           country_code, latitude, longitude)
                    VALUES
                    %s
                    """,
                    part,
                )
            facility_ids = fetch_ids(cur, "facilities", "facility_id")

            # Facility inventory baseline
            inv_rows = []
            for fid in facility_ids:
                k = random.randint(80, 250) if len(product_ids) >= 250 else max(10, len(product_ids) // 3)
                chosen = random.sample(product_ids, k=min(k, len(product_ids)))
                for pid in chosen:
                    qty = random.randint(0, 500)
                    inv_rows.append((fid, pid, qty))

            for part in chunked(inv_rows, batch):
                execute_values(
                    cur,
                    """
                    INSERT INTO facility_inventory(facility_id, product_id, qty_units)
                    VALUES
                    %s
                    ON CONFLICT (facility_id, product_id)
                    DO UPDATE SET qty_units = EXCLUDED.qty_units
                    """,
                    part,
                )

            # Supplier products (with money price and big availability)
            sp_rows = []
            sp_price_cents = {}

            for sid in supplier_ids:
                k = random.randint(120, 400) if len(product_ids) >= 400 else max(10, len(product_ids) // 2)
                chosen = random.sample(product_ids, k=min(k, len(product_ids)))
                for pid in chosen:
                    retail = product_price_cents.get(pid, random.randint(800, 25000))
                    cents = max(100, int(retail * random.uniform(0.55, 0.92)))
                    available_units = random.randint(2000, 30000)
                    is_active = random.random() < 0.93
                    sp_price_cents[(sid, pid)] = cents
                    sp_rows.append((sid, pid, is_active, available_units, money_str_from_cents(cents)))

            for part in chunked(sp_rows, batch):
                execute_values(
                    cur,
                    """
                    INSERT INTO supplier_products(supplier_id, product_id, is_active, available_units, price)
                    VALUES
                    %s
                    ON CONFLICT (supplier_id, product_id)
                    DO UPDATE
                    SET is_active = EXCLUDED.is_active,
                        available_units = EXCLUDED.available_units,
                        price = EXCLUDED.price,
                        updated_at = now()
                    """,
                    part,
                    template="(%s, %s, %s, %s, %s::money)",
                )

            # Price history (1..3 entries per supplier_product)
            cur.execute("SELECT supplier_id, product_id FROM supplier_products;")
            sp_pairs = cur.fetchall()

            sph_rows = []
            for sid, pid in sp_pairs:
                base_cents = sp_price_cents.get((sid, pid), random.randint(1200, 14000))
                for _ in range(random.randint(1, 3)):
                    cents = max(0, base_cents + random.randint(-300, 600))
                    note = random.choice(["прайс", "акція", "оновлення", None])
                    sph_rows.append((sid, pid, money_str_from_cents(cents), note))

            for part in chunked(sph_rows, batch):
                execute_values(
                    cur,
                    """
                    INSERT INTO supplier_price_history(supplier_id, product_id, price, note)
                    VALUES
                    %s
                    """,
                    part,
                    template="(%s, %s, %s::money, %s)",
                )

            # Orders: safe with trigger (qty <= available_units)
            statuses = ["processing_by_supplier", "shipped", "received"]
            now = datetime.now(timezone.utc)

            created = 0
            attempts = 0
            max_attempts = orders_n * 5

            while created < orders_n and attempts < max_attempts:
                attempts += 1
                sid = random.choice(supplier_ids)
                fid = random.choice(facility_ids)
                target_status = random.choices(statuses, weights=[0.35, 0.35, 0.30], k=1)[0]

                cur.execute(
                    """
                    SELECT product_id, available_units
                    FROM supplier_products
                    WHERE supplier_id = %s
                      AND is_active = true
                      AND available_units > 0
                    """,
                    (sid,),
                )
                rows = cur.fetchall()
                if not rows:
                    continue

                added_at = now - timedelta(days=random.randint(0, 60))
                note = f"закупка {added_at.date().isoformat()}"

                cur.execute(
                    """
                    INSERT INTO purchase_orders(supplier_id, facility_id, status, total_amount, note, added_at)
                    VALUES (%s, %s, %s::purchase_order_status, 0, %s, %s)
                    RETURNING order_id
                    """,
                    (sid, fid, "processing_by_supplier", note, added_at),
                )
                order_id = cur.fetchone()[0]

                avail = {pid: int(a) for pid, a in rows}
                supplier_pids = list(avail.keys())

                chosen = random.sample(
                    supplier_pids,
                    k=min(random.randint(2, 10), len(supplier_pids)),
                )

                item_rows = []
                for pid in chosen:
                    max_qty = min(120, avail.get(pid, 0))
                    if max_qty <= 0:
                        continue

                    qty = random.randint(1, max_qty)
                    avail[pid] -= qty

                    unit_cents = sp_price_cents.get((sid, pid), random.randint(1200, 14000))
                    item_rows.append((order_id, pid, qty, unit_cents))

                if not item_rows:
                    cur.execute("DELETE FROM purchase_orders WHERE order_id = %s;", (order_id,))
                    continue

                execute_values(
                    cur,
                    """
                    INSERT INTO purchase_order_items(order_id, product_id, qty_units, unit_price)
                    VALUES
                    %s
                    """,
                    item_rows,
                )

                cur.execute(
                    "UPDATE purchase_orders SET status=%s::purchase_order_status WHERE order_id=%s;",
                    (target_status, order_id),
                )

                created += 1

            conn.commit()

    print(f"Generating done")


if __name__ == "__main__":
    main()
