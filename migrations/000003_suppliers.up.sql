CREATE TABLE suppliers
(
    supplier_id         SERIAL PRIMARY KEY,

    name                TEXT        NOT NULL UNIQUE,
    phone_main          TEXT        NOT NULL,
    representative_name TEXT        NOT NULL,

    address             TEXT        NOT NULL,
    city                TEXT        NOT NULL,
    region              TEXT,
    postal_code         TEXT        NOT NULL,

    latitude            DOUBLE PRECISION CHECK (latitude BETWEEN -90 AND 90),
    longitude           DOUBLE PRECISION CHECK (longitude BETWEEN -180 AND 180),

    added_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX supplier_earth_gist_idx
    ON suppliers
        USING GIST (ll_to_earth(latitude, longitude));

CREATE INDEX supplier_city_idx ON suppliers (city);
CREATE INDEX supplier_postal_idx ON suppliers (postal_code);

CREATE TABLE supplier_products
(
    supplier_id     INTEGER     NOT NULL REFERENCES suppliers (supplier_id) ON DELETE CASCADE,
    product_id      INTEGER     NOT NULL REFERENCES products (product_id) ON DELETE CASCADE,

    is_active       BOOLEAN     NOT NULL DEFAULT TRUE,

    available_units INTEGER     NOT NULL DEFAULT 0 CHECK (available_units >= 0),
    price           MONEY       NOT NULL CHECK (price >= 0::money),

    added_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

    PRIMARY KEY (supplier_id, product_id)
);

CREATE INDEX supplier_product_supplier_idx ON supplier_products (supplier_id);
CREATE INDEX supplier_product_product_idx ON supplier_products (product_id);

CREATE TABLE supplier_price_history
(
    price_id    SERIAL PRIMARY KEY,
    supplier_id INTEGER NOT NULL REFERENCES suppliers (supplier_id) ON DELETE CASCADE,
    product_id  INTEGER NOT NULL REFERENCES products (product_id) ON DELETE CASCADE,

    price       MONEY   NOT NULL CHECK (price >= 0::money),

    note        TEXT
);

