SELECT
    s.supplier_id,
    s.name AS supplier,
    COUNT(DISTINCT pc.category_id) AS categories_count
FROM suppliers s
         JOIN supplier_products sp
              ON sp.supplier_id = s.supplier_id
                  AND sp.is_active = TRUE
         JOIN products p
              ON p.product_id = sp.product_id
         JOIN product_categories pc
              ON pc.category_id = p.category_id
GROUP BY s.supplier_id, s.name
ORDER BY categories_count DESC, s.name;