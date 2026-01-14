-- Товари, де виробник не вказаний
SELECT p.product_id, p.name, pc.name AS category_name
FROM products p
JOIN product_categories pc ON pc.category_id = p.category_id
WHERE p.manufacturer_id IS NULL
ORDER BY p.name
LIMIT 20;
