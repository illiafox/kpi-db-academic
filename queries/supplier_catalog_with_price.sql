-- Каталог: постачальник -> товари, доступність, ціна
SELECT s.name AS supplier_name, p.code, p.name AS product_name,
sp.available_units, sp.price, sp.is_active, sp.updated_at
FROM supplier_products sp
JOIN suppliers s ON s.supplier_id = sp.supplier_id
JOIN products p  ON p.product_id  = sp.product_id
ORDER BY s.name, p.name
LIMIT 20;
