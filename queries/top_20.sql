DROP INDEX product_fts_gin_idx;
CREATE INDEX product_fts_gin_idx
    ON products
        USING GIN (
                   to_tsvector('simple', name || ' ' || coalesce(description, '') || ' ' || code)
            );


EXPLAIN (ANALYZE, BUFFERS)
SELECT p.product_id, p.code, p.name
FROM products p
WHERE to_tsvector('simple', p.name || ' ' || coalesce(p.description, '') || ' ' || p.code)
          @@ plainto_tsquery('simple', 'хліб');

CREATE INDEX supplier_earth_gist_idx
    ON suppliers
        USING GIST (ll_to_earth(latitude, longitude));

EXPLAIN (ANALYZE, BUFFERS)
SELECT s.supplier_id,
       s.name,
       earth_distance(ll_to_earth(s.latitude, s.longitude), ll_to_earth(f.latitude, f.longitude)) AS distance_m
FROM suppliers s
         JOIN facilities f ON f.facility_id = 3
WHERE s.latitude IS NOT NULL
  AND s.longitude IS NOT NULL
  AND f.latitude IS NOT NULL
  AND f.longitude IS NOT NULL
ORDER BY ll_to_earth(s.latitude, s.longitude) <-> ll_to_earth(f.latitude, f.longitude)
LIMIT 10;