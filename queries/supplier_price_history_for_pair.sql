-- Історія цін для пари (supplier_id, product_id)
SELECT s.name AS supplier_name, p.name AS product_name,
sph.price_id, sph.price, sph.note
FROM supplier_price_history sph
JOIN suppliers s ON s.supplier_id = sph.supplier_id
JOIN products p  ON p.product_id  = sph.product_id
WHERE sph.supplier_id = 1 AND sph.product_id = 871
ORDER BY sph.price_id DESC
LIMIT 20;
