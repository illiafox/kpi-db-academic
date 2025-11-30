-- Обсяг закупок по постачальниках
SELECT s.supplier_id, s.name,
COUNT(po.order_id) AS orders_count,
COALESCE(SUM(po.total_amount), 0::money) AS total_cents
FROM suppliers s
LEFT JOIN purchase_orders po ON po.supplier_id = s.supplier_id
GROUP BY s.supplier_id
ORDER BY total_cents DESC
LIMIT 20;
