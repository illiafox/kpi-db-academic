-- Список закупок з постачальником і об'єктом
SELECT po.order_id, po.status, po.total_amount, po.added_at,
s.name AS supplier_name,
f.name AS facility_name, f.type AS facility_type
FROM purchase_orders po
JOIN suppliers s  ON s.supplier_id = po.supplier_id
JOIN facilities f ON f.facility_id = po.facility_id
ORDER BY po.added_at DESC
LIMIT 20;
