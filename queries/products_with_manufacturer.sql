-- Товари з виробником
SELECT p.product_id, p.name, p.code, m.name AS manufacturer_name, pc.name AS category_name
FROM products p
JOIN product_categories pc ON pc.category_id = p.category_id
LEFT JOIN manufacturers m ON m.manufacturer_id = p.manufacturer_id
ORDER BY p.name
LIMIT 20;
