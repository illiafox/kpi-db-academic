REVOKE ALL PRIVILEGES ON
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
    FROM analytics_role, catalog_manager_role, procurement_role, warehouse_role;

REVOKE ALL PRIVILEGES ON
    v_products_full,
    v_suppliers_list,
    v_purchase_orders_full,
    v_totals
    FROM analytics_role;

REVOKE ALL PRIVILEGES ON SEQUENCE
    product_categories_category_id_seq,
    manufacturers_manufacturer_id_seq,
    products_product_id_seq
    FROM catalog_manager_role;

REVOKE ALL PRIVILEGES ON SEQUENCE
    suppliers_supplier_id_seq,
    supplier_price_history_price_id_seq,
    purchase_orders_order_id_seq
    FROM procurement_role;

REVOKE ALL PRIVILEGES ON SEQUENCE
    facilities_facility_id_seq
    FROM warehouse_role;

REVOKE admin_role FROM user_admin;
REVOKE procurement_role FROM user_procurement;
REVOKE warehouse_role FROM user_warehouse;
REVOKE catalog_manager_role FROM user_catalog;
REVOKE analytics_role FROM user_analytics;


DROP USER IF EXISTS user_admin;
DROP USER IF EXISTS user_procurement;
DROP USER IF EXISTS user_warehouse;
DROP USER IF EXISTS user_catalog;
DROP USER IF EXISTS user_analytics;

DROP ROLE IF EXISTS admin_role;
DROP ROLE IF EXISTS procurement_role;
DROP ROLE IF EXISTS warehouse_role;
DROP ROLE IF EXISTS catalog_manager_role;
DROP ROLE IF EXISTS analytics_role;
