-- Загальний залишок по кожному товару (сума по всіх об'єктах)
SELECT p.product_id, p.name,
COALESCE(SUM(fi.qty_units), 0) AS total_qty_units
FROM products p
LEFT JOIN facility_inventory fi ON fi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_qty_units DESC, p.name
LIMIT 20;
