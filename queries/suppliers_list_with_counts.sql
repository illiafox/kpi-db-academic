-- Список постачальників + к-сть активних товарів
SELECT s.supplier_id,
       s.name,
       COUNT(sp.product_id) FILTER (WHERE sp.is_active) AS active_products
FROM suppliers s
         LEFT JOIN supplier_products sp ON sp.supplier_id = s.supplier_id
GROUP BY s.supplier_id
ORDER BY s.name
LIMIT 20;
