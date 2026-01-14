-- Обсяг закупок по складах/магазинах
SELECT f.facility_id,
       f.name,
       f.type,
       COUNT(po.order_id)                       AS orders_count
FROM facilities f
         LEFT JOIN purchase_orders po ON po.facility_id = f.facility_id
GROUP BY f.facility_id
ORDER BY orders_count DESC
LIMIT 20;
