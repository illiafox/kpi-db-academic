-- Закупки по статусу
SELECT po.order_id,
       po.total_amount,
       s.name AS supplier_name,
       f.name AS facility_name
FROM purchase_orders po
         JOIN suppliers s ON s.supplier_id = po.supplier_id
         JOIN facilities f ON f.facility_id = po.facility_id
WHERE po.status = 'shipped'
ORDER BY po.added_at DESC
LIMIT 20;