SELECT
    p.code,
    p.name,
    s.name AS supplier,
    COUNT(DISTINCT sp.supplier_id) AS active_suppliers
FROM products p
         JOIN supplier_products sp
              ON sp.product_id = p.product_id
                  AND sp.is_active = TRUE
         JOIN suppliers s
              ON s.supplier_id = sp.supplier_id
GROUP BY p.code, p.name, s.name
HAVING COUNT(DISTINCT sp.supplier_id) = 1