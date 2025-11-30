-- Найближчий постачальник для товару (earthdistance + GiST)
WITH q AS (SELECT 50.4501::double precision AS lat,
                  30.5234::double precision AS lon,
                  3202                       AS product_id)
SELECT s.supplier_id,
       s.name,
       s.city,
       sp.available_units,
       sp.price,
       ROUND((
                 earth_distance(
                         ll_to_earth(s.latitude, s.longitude),
                         ll_to_earth(q.lat, q.lon)
                 ) / 1000.0
                 )::numeric, 1) AS distance_km
FROM q
         JOIN supplier_products sp ON sp.product_id = q.product_id
         JOIN suppliers s ON s.supplier_id = sp.supplier_id
WHERE sp.is_active = true
  AND sp.available_units > 0
  AND s.latitude IS NOT NULL
  AND s.longitude IS NOT NULL
ORDER BY ll_to_earth(s.latitude, s.longitude) <-> ll_to_earth(q.lat, q.lon)
LIMIT 10;

