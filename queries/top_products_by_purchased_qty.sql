-- Топ-10 товарів за сумарною кількістю в закупках
SELECT p.product_id, p.name,
SUM(i.qty_units) AS total_qty_units
FROM purchase_order_items i
JOIN products p ON p.product_id = i.product_id
JOIN purchase_orders po ON po.order_id = i.order_id
GROUP BY p.product_id
ORDER BY total_qty_units DESC
LIMIT 50;
