-- Обсяг закупок по постачальниках
SELECT s.supplier_id, s.name,
COUNT(po.order_id) AS orders_count,
SUM(po.total_amount) AS total
FROM suppliers s
LEFT JOIN purchase_orders po ON po.supplier_id = s.supplier_id
GROUP BY s.supplier_id
ORDER BY total DESC
LIMIT 20;
