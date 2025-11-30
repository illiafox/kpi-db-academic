CREATE OR REPLACE VIEW v_products_full AS
SELECT
    p.product_id,
    p.code,
    p.name,
    pc.name AS category_name,
    m.name AS manufacturer_name,
    p.pack_weight_g,
    p.price,
    COALESCE(SUM(fi.qty_units), 0) AS total_qty_units,
    p.description,
    p.added_at,
    p.updated_at
FROM products p
         JOIN product_categories pc ON pc.category_id = p.category_id
         LEFT JOIN manufacturers m ON m.manufacturer_id = p.manufacturer_id
         LEFT JOIN facility_inventory fi ON fi.product_id = p.product_id
GROUP BY
    p.product_id, pc.name, m.name;


CREATE OR REPLACE VIEW v_suppliers_list AS
SELECT
    s.supplier_id,
    s.name,
    s.phone_main,
    s.representative_name,
    s.address,
    s.city,
    s.region,
    s.postal_code,
    s.latitude,
    s.longitude,
    COUNT(sp.product_id) FILTER (WHERE sp.is_active) AS active_products
FROM suppliers s
         LEFT JOIN supplier_products sp ON sp.supplier_id = s.supplier_id
GROUP BY s.supplier_id;


CREATE OR REPLACE VIEW v_purchase_orders_full AS
SELECT
    po.order_id,
    po.status,
    po.total_amount,
    po.added_at,
    po.note,
    s.supplier_id,
    s.name AS supplier_name,
    f.facility_id,
    f.name AS facility_name,
    f.type AS facility_type
FROM purchase_orders po
         JOIN suppliers s ON s.supplier_id = po.supplier_id
         JOIN facilities f ON f.facility_id = po.facility_id;


CREATE OR REPLACE VIEW v_totals AS
SELECT
    (SELECT COUNT(*) FROM products) AS products_count,
    (SELECT COUNT(*) FROM suppliers) AS suppliers_count,
    COALESCE((
                 SELECT SUM(fi.qty_units * p.price)
                 FROM facility_inventory fi
                          JOIN products p ON p.product_id = fi.product_id
             ), (0)::money) AS total_stock_sum;
