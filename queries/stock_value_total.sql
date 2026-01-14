-- Загальна вартість запасів (money) та кількість позицій
SELECT
COUNT(DISTINCT p.product_id) AS products_in_stock,
SUM(fi.qty_units * p.price) AS total_stock_sum
FROM facility_inventory fi
JOIN products p ON p.product_id = fi.product_id;
