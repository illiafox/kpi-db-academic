CREATE OR REPLACE FUNCTION set_updated_at()
    RETURNS trigger
    LANGUAGE plpgsql
AS
$$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END
$$;

CREATE TRIGGER products_set_updated_at
    BEFORE UPDATE
    ON products
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER suppliers_set_updated_at
    BEFORE UPDATE
    ON suppliers
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER supplier_products_set_updated_at
    BEFORE UPDATE
    ON supplier_products
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


CREATE OR REPLACE FUNCTION poi_compute_total_price()
    RETURNS trigger
    LANGUAGE plpgsql
AS
$$
BEGIN
    NEW.total_price = NEW.qty_units * NEW.unit_price;
    RETURN NEW;
END
$$;

CREATE TRIGGER purchase_order_items_compute_total_price
    BEFORE INSERT OR UPDATE OF qty_units, unit_price
    ON purchase_order_items
    FOR EACH ROW
EXECUTE FUNCTION poi_compute_total_price();


CREATE OR REPLACE FUNCTION po_recalc_total(p_order_id integer)
    RETURNS void
    LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE purchase_orders po
    SET total_amount = COALESCE(
            (SELECT SUM(i.total_price)
             FROM purchase_order_items i
             WHERE i.order_id = p_order_id),
            (0)::money
                       )
    WHERE po.order_id = p_order_id;
END
$$;

CREATE OR REPLACE FUNCTION poi_after_change_recalc_total()
    RETURNS trigger
    LANGUAGE plpgsql
AS
$$
DECLARE
    v_order_id integer;
BEGIN
    v_order_id := COALESCE(NEW.order_id, OLD.order_id);
    PERFORM po_recalc_total(v_order_id);
    RETURN NULL;
END
$$;

CREATE TRIGGER purchase_order_items_recalc_total_aiud
    AFTER INSERT OR UPDATE OR DELETE
    ON purchase_order_items
    FOR EACH ROW
EXECUTE FUNCTION poi_after_change_recalc_total();


CREATE OR REPLACE FUNCTION po_apply_received_to_inventory()
    RETURNS trigger
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF OLD.status IS DISTINCT FROM NEW.status
        AND NEW.status = 'received'::purchase_order_status THEN

        INSERT INTO facility_inventory (facility_id, product_id, qty_units)
        SELECT NEW.facility_id, i.product_id, i.qty_units
        FROM purchase_order_items i
        WHERE i.order_id = NEW.order_id
        ON CONFLICT (facility_id, product_id)
            DO UPDATE SET qty_units = facility_inventory.qty_units + EXCLUDED.qty_units;

        UPDATE supplier_products sp
        SET available_units = sp.available_units - i.qty_units,
            updated_at      = now()
        FROM purchase_order_items i
        WHERE i.order_id = NEW.order_id
          AND sp.supplier_id = NEW.supplier_id
          AND sp.product_id = i.product_id;

        IF EXISTS (SELECT 1
                   FROM supplier_products sp
                   WHERE sp.supplier_id = NEW.supplier_id
                     AND sp.available_units < 0) THEN
            RAISE EXCEPTION 'Supplier available_units became negative for supplier_id=%', NEW.supplier_id;
        END IF;

    END IF;

    RETURN NEW;
END
$$;

CREATE TRIGGER purchase_orders_apply_received_to_inventory
    AFTER UPDATE OF status
    ON purchase_orders
    FOR EACH ROW
EXECUTE FUNCTION po_apply_received_to_inventory();
