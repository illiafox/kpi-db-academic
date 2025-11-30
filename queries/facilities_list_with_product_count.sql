-- Склади/магазини + кількість різних товарів у наявності
SELECT f.facility_id, f.name, f.type,
COUNT(fi.product_id) AS distinct_products
FROM facilities f
LEFT JOIN facility_inventory fi ON fi.facility_id = f.facility_id
GROUP BY f.facility_id
ORDER BY COUNT(fi.product_id) DESC
LIMIT 20;
