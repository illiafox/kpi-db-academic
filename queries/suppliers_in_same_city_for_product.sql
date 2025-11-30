-- Знайти постачальника у тому ж місті, що й об'єкт (facility)
SELECT
f.name AS facility_name,
f.city AS facility_city,
s.supplier_id,
s.name AS supplier_name,
sp.price
FROM facilities f
JOIN products p ON p.product_id = 1
JOIN suppliers s ON s.city = f.city
JOIN supplier_products sp ON sp.supplier_id = s.supplier_id AND sp.product_id = p.product_id
WHERE f.facility_id = 1
AND sp.is_active = true
ORDER BY sp.price ASC, s.name
LIMIT 20;
