CREATE TABLE product_categories
(
    category_id SERIAL PRIMARY KEY,
    parent_id   INTEGER REFERENCES product_categories (category_id) ON DELETE SET NULL,
    name        TEXT    NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE manufacturers
(
    manufacturer_id SERIAL PRIMARY KEY,
    name            TEXT NOT NULL UNIQUE,
    country         TEXT
);

CREATE TABLE products
(
    product_id      SERIAL PRIMARY KEY,
    category_id     INTEGER     NOT NULL REFERENCES product_categories (category_id) ON DELETE RESTRICT,

    manufacturer_id INTEGER     REFERENCES manufacturers (manufacturer_id) ON DELETE SET NULL,
    code            TEXT        NOT NULL UNIQUE,
    name            TEXT        NOT NULL,

    pack_weight_g   INTEGER     NOT NULL CHECK (pack_weight_g > 0),

    description     TEXT,
    price           MONEY       NOT NULL CHECK (price > 0::money),

    added_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX product_category_idx ON products (category_id);
CREATE INDEX product_manufacturer_idx ON products (manufacturer_id);

CREATE INDEX product_fts_gin_idx
    ON products
        USING GIN (
                   to_tsvector('simple', name || ' ' || coalesce(description,'') || ' ' || code)
            );
