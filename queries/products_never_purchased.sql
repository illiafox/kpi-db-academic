-- Товари, які жодного разу не закуповували
SELECT p.product_id, p.name, pc.name AS category_name
FROM products p
         JOIN product_categories pc ON pc.category_id = p.category_id
         LEFT JOIN purchase_order_items i ON i.product_id = p.product_id
WHERE i.product_id IS NULL
ORDER BY p.name
LIMIT 50;
