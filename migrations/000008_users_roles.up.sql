CREATE ROLE admin_role;
CREATE ROLE procurement_role;
CREATE ROLE warehouse_role;
CREATE ROLE catalog_manager_role;
CREATE ROLE analytics_role;

CREATE USER user_admin WITH PASSWORD 'admin_pass';
GRANT admin_role TO user_admin;

CREATE USER user_procurement WITH PASSWORD 'proc_pass';
GRANT procurement_role TO user_procurement;

CREATE USER user_warehouse WITH PASSWORD 'wh_pass';
GRANT warehouse_role TO user_warehouse;

CREATE USER user_catalog WITH PASSWORD 'cat_pass';
GRANT catalog_manager_role TO user_catalog;

CREATE USER user_analytics WITH PASSWORD 'analytics_pass';
GRANT analytics_role TO user_analytics;

GRANT SELECT ON
    product_categories,
    manufacturers,
    products,
    suppliers,
    supplier_products,
    supplier_price_history,
    facilities,
    facility_inventory,
    purchase_orders,
    purchase_order_items
    TO analytics_role;

GRANT SELECT ON
    v_products_full,
    v_suppliers_list,
    v_purchase_orders_full,
    v_totals
    TO analytics_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON
    product_categories,
    manufacturers,
    products
    TO catalog_manager_role;

GRANT SELECT ON
    suppliers,
    supplier_products,
    supplier_price_history,
    facilities,
    facility_inventory,
    purchase_orders,
    purchase_order_items
    TO catalog_manager_role;

GRANT USAGE, SELECT ON SEQUENCE
    product_categories_category_id_seq,
    manufacturers_manufacturer_id_seq,
    products_product_id_seq
    TO catalog_manager_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON
    suppliers,
    supplier_products,
    purchase_orders,
    purchase_order_items
    TO procurement_role;

GRANT SELECT, INSERT, UPDATE ON
    supplier_price_history
    TO procurement_role;

GRANT SELECT ON
    product_categories,
    manufacturers,
    products,
    facilities,
    facility_inventory
    TO procurement_role;

GRANT USAGE, SELECT ON SEQUENCE
    suppliers_supplier_id_seq,
    supplier_price_history_price_id_seq,
    purchase_orders_order_id_seq
    TO procurement_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON
    facility_inventory
    TO warehouse_role;

GRANT SELECT, INSERT, UPDATE ON
    facilities
    TO warehouse_role;

GRANT SELECT ON
    product_categories,
    manufacturers,
    products,
    suppliers,
    supplier_products,
    supplier_price_history,
    purchase_orders,
    purchase_order_items
    TO warehouse_role;

GRANT USAGE, SELECT ON SEQUENCE
    facilities_facility_id_seq
    TO warehouse_role;

