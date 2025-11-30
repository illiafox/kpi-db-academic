DROP TRIGGER IF EXISTS purchase_orders_apply_received_to_inventory ON purchase_orders;
DROP FUNCTION IF EXISTS po_apply_received_to_inventory();

DROP TRIGGER IF EXISTS purchase_order_items_recalc_total_aiud ON purchase_order_items;
DROP FUNCTION IF EXISTS poi_after_change_recalc_total();
DROP FUNCTION IF EXISTS po_recalc_total(integer);

DROP TRIGGER IF EXISTS purchase_order_items_compute_total_price ON purchase_order_items;
DROP FUNCTION IF EXISTS poi_compute_total_price();

DROP TRIGGER IF EXISTS supplier_products_set_updated_at ON supplier_products;
DROP TRIGGER IF EXISTS suppliers_set_updated_at ON suppliers;
DROP TRIGGER IF EXISTS products_set_updated_at ON products;
DROP FUNCTION IF EXISTS set_updated_at();
