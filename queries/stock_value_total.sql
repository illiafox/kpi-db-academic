-- Загальна вартість запасів (money) та кількість позицій
SELECT
COUNT(DISTINCT p.product_id) AS products_in_stock,
COALESCE(SUM(fi.qty_units * p.price), (0)::money) AS total_stock_sum
FROM facility_inventory fi
JOIN products p ON p.product_id = fi.product_id
LIMIT 20;
