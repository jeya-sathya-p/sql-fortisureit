-- Q11 Step 1: which region has the highest return value?
SELECT r.RegionName, ROUND(SUM(ret.ReturnQuantity * oi.UnitPrice), 2) AS ReturnValue
FROM Returns ret
JOIN OrderItemsClean oi ON ret.OrderItemID = oi.OrderItemID
JOIN Orders o  ON oi.OrderID = o.OrderID
JOIN Stores s  ON o.StoreID = s.StoreID
JOIN Regions r ON s.RegionID = r.RegionID
WHERE ret.ReturnDate BETWEEN '2026-10-01' AND '2026-10-31'
  AND o.OrderStatus = 'Completed'
GROUP BY r.RegionName
ORDER BY ReturnValue DESC;

-- Q11 Step 2: category breakdown for that region (replace 'North' with actual winner)
WITH region_returns AS (
    SELECT p.Category,
           SUM(ret.ReturnQuantity * oi.UnitPrice) AS ReturnValue
    FROM Returns ret
    JOIN OrderItemsClean oi ON ret.OrderItemID = oi.OrderItemID
    JOIN Products p ON oi.ProductID = p.ProductID
    JOIN Orders o  ON oi.OrderID = o.OrderID
    JOIN Stores s  ON o.StoreID = s.StoreID
    JOIN Regions r ON s.RegionID = r.RegionID
    WHERE ret.ReturnDate BETWEEN '2026-10-01' AND '2026-10-31'
      AND o.OrderStatus = 'Completed'
      AND r.RegionName = 'North'          -- <-- change to top region from step 1
    GROUP BY p.Category
)
SELECT Category,
       ROUND(ReturnValue, 2) AS ReturnValue,
       CASE WHEN (SELECT SUM(ReturnValue) FROM region_returns) = 0 THEN 'N/A'
            ELSE CAST(ROUND(ReturnValue * 100.0 /
                            (SELECT SUM(ReturnValue) FROM region_returns), 2) AS TEXT) || '%'
       END AS ShareOfRegionReturns
FROM region_returns
ORDER BY ReturnValue DESC;