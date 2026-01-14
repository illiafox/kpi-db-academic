SELECT
    s.name AS supplier,
    p.name AS product,
    sph.price::numeric AS price,
    (sph.price::numeric - LAG(sph.price::numeric) OVER (
        PARTITION BY sph.supplier_id, sph.product_id
        ORDER BY sph.price_id
        )) AS diff_from_prev
FROM supplier_price_history sph
         JOIN suppliers s ON s.supplier_id = sph.supplier_id
         JOIN products p  ON p.product_id = sph.product_id
ORDER BY diff_from_prev DESC NULLS LAST
