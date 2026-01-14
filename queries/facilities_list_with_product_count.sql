-- Отримати склади та кількість товарів на них (відсортувати за спадінням)
SELECT f.facility_id,
       f.name,
       SUM(fi.qty_units) AS total_products_qty
FROM facilities f
         LEFT JOIN facility_inventory fi ON fi.facility_id = f.facility_id
WHERE f.type = 'warehouse'
GROUP BY f.facility_id
ORDER BY total_products_qty DESC
LIMIT 5;
