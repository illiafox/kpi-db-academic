-- Найдешевший активний постачальник для продукту
SELECT s.supplier_id, s.name, sp.price, sp.available_units
FROM supplier_products sp
JOIN suppliers s ON s.supplier_id = sp.supplier_id
WHERE sp.product_id = 1891
AND sp.is_active = true
AND sp.available_units > 0
ORDER BY sp.price ASC
LIMIT 5;
