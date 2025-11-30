DROP INDEX IF EXISTS purchase_order_item_product_idx;
DROP TABLE IF EXISTS purchase_order_items;

DROP INDEX IF EXISTS purchase_order_status_idx;
DROP INDEX IF EXISTS purchase_order_facility_idx;
DROP INDEX IF EXISTS purchase_order_supplier_idx;
DROP TABLE IF EXISTS purchase_orders;
DROP TYPE IF EXISTS purchase_order_status;
