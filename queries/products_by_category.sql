-- Список товарів заданої категорії
SELECT p.product_id, p.code, p.name, p.pack_weight_g,  p.price
FROM products p
JOIN product_categories pc ON pc.category_id = p.category_id
WHERE pc.name = 'Кава та чай'
ORDER BY p.price
LIMIT 20;
