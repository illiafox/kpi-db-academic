CREATE TYPE purchase_order_status AS ENUM ('processing_by_supplier', 'shipped', 'received');

CREATE TABLE purchase_orders
(
    order_id     SERIAL PRIMARY KEY,
    supplier_id  INTEGER               NOT NULL REFERENCES suppliers (supplier_id) ON DELETE RESTRICT,
    facility_id  INTEGER               NOT NULL REFERENCES facilities (facility_id) ON DELETE RESTRICT,
    status       purchase_order_status NOT NULL DEFAULT 'processing_by_supplier',
    total_amount MONEY                 NOT NULL DEFAULT 0 CHECK (total_amount >= 0::money),
    added_at     TIMESTAMPTZ           NOT NULL DEFAULT now(),
    note         TEXT
);

CREATE INDEX purchase_order_supplier_idx ON purchase_orders (supplier_id);
CREATE INDEX purchase_order_facility_idx ON purchase_orders (facility_id);
CREATE INDEX purchase_order_status_idx ON purchase_orders (status);

CREATE TABLE purchase_order_items
(
    order_id    INTEGER NOT NULL REFERENCES purchase_orders (order_id) ON DELETE CASCADE,
    product_id  INTEGER NOT NULL REFERENCES products (product_id) ON DELETE RESTRICT,
    qty_units   INTEGER NOT NULL CHECK (qty_units > 0),
    unit_price  MONEY   NOT NULL CHECK (unit_price >= 0::money),
    total_price MONEY   NOT NULL CHECK (total_price >= 0::money),
    PRIMARY KEY (order_id, product_id)
);

CREATE INDEX purchase_order_item_product_idx ON purchase_order_items (product_id);
