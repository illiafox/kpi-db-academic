-- Постачальники товару
SELECT s.supplier_id, s.name AS supplier_name,
sp.available_units, sp.price
FROM supplier_products sp
JOIN suppliers s ON s.supplier_id = sp.supplier_id
JOIN products p  ON p.product_id  = sp.product_id
WHERE p.product_id = 3202
AND sp.is_active = true
ORDER BY sp.price ASC, s.name
LIMIT 10;
