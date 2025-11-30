-- Товари конкретного виробника
SELECT p.product_id, p.code, p.name, m.name AS manufacturer_name
FROM products p
JOIN manufacturers m ON m.manufacturer_id = p.manufacturer_id
WHERE m.name = 'Henkel'
ORDER BY p.name
LIMIT 20;
