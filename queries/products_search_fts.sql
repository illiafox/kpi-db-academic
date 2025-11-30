-- Full Text Search по назві/опису/коду
SELECT p.product_id, p.code, p.name, pc.name AS category_name, p.price
FROM products p
JOIN product_categories pc ON pc.category_id = p.category_id
WHERE to_tsvector('simple', p.name || ' ' || coalesce(p.description, '') || ' ' || p.code)
@@ websearch_to_tsquery('simple','Хліб натуральний')
ORDER BY p.price
LIMIT 20;
