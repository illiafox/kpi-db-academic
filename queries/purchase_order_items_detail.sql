-- Деталі конкретного замовлення (позиції)
SELECT po.order_id,
p.code, p.name,
i.qty_units, i.unit_price, i.total_price
FROM purchase_order_items i
JOIN purchase_orders po ON po.order_id = i.order_id
JOIN products p         ON p.product_id = i.product_id
WHERE po.order_id = 2
ORDER BY p.name
LIMIT 20;
