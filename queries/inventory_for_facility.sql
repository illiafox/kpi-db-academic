-- Наявність по конкретному складу/магазину
SELECT f.name AS facility_name, f.type,
p.code, p.name AS product_name,
fi.qty_units, p.price
FROM facility_inventory fi
JOIN facilities f ON f.facility_id = fi.facility_id
JOIN products p   ON p.product_id  = fi.product_id
WHERE f.facility_id = 10
ORDER BY p.name
LIMIT 20;
