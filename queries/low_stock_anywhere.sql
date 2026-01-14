-- Товари з низьким залишком
SELECT f.name AS facility_name, p.name AS product_name, fi.qty_units
FROM facility_inventory fi
JOIN facilities f ON f.facility_id = fi.facility_id
JOIN products p   ON p.product_id  = fi.product_id
WHERE fi.qty_units <= 50
ORDER BY fi.qty_units, p.name
LIMIT 20;
