-- Постачальники, які постачають товари певної категорії
SELECT DISTINCT s.supplier_id, s.name AS category_name
FROM suppliers s
JOIN supplier_products sp ON sp.supplier_id = s.supplier_id
JOIN products p ON p.product_id = sp.product_id
JOIN product_categories pc ON pc.category_id = p.category_id
WHERE pc.name = 'Молочні продукти'
AND sp.is_active = true
ORDER BY s.name
LIMIT 20;
