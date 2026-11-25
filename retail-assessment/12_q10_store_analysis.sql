-- Q10(a): Gross sales by store for October 2026
SELECT s.StoreID, s.StoreName, r.RegionName,
       ROUND(SUM(oi.Quantity * oi.UnitPrice), 2) AS GrossSales
FROM Orders o
JOIN Stores s  ON o.StoreID = s.StoreID
JOIN Regions r ON s.RegionID = r.RegionID
JOIN OrderItemsClean oi ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Completed'
  AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
GROUP BY s.StoreID, s.StoreName, r.RegionName
ORDER BY r.RegionName, GrossSales DESC;

-- Q10(b): Return value by store for October 2026 returns
SELECT s.StoreID, s.StoreName,
       ROUND(SUM(ret.ReturnQuantity * oi.UnitPrice), 2) AS ReturnValue
FROM Returns ret
JOIN OrderItemsClean oi ON ret.OrderItemID = oi.OrderItemID
JOIN Orders o ON oi.OrderID = o.OrderID
JOIN Stores s ON o.StoreID = s.StoreID
WHERE ret.ReturnDate BETWEEN '2026-10-01' AND '2026-10-31'
  AND o.OrderStatus = 'Completed'
GROUP BY s.StoreID, s.StoreName
ORDER BY s.StoreID;

-- Q10(c): Store net sales + winner per region + share
WITH gross AS (
    SELECT s.StoreID, s.StoreName, r.RegionName,
           SUM(oi.Quantity * oi.UnitPrice) AS GrossSales
    FROM Orders o
    JOIN Stores s  ON o.StoreID = s.StoreID
    JOIN Regions r ON s.RegionID = r.RegionID
    JOIN OrderItemsClean oi ON oi.OrderID = o.OrderID
    WHERE o.OrderStatus = 'Completed'
      AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
    GROUP BY s.StoreID, s.StoreName, r.RegionName
),
ret AS (
    SELECT s.StoreID, SUM(ret.ReturnQuantity * oi.UnitPrice) AS ReturnValue
    FROM Returns ret
    JOIN OrderItemsClean oi ON ret.OrderItemID = oi.OrderItemID
    JOIN Orders o ON oi.OrderID = o.OrderID
    JOIN Stores s ON o.StoreID = s.StoreID
    WHERE ret.ReturnDate BETWEEN '2026-10-01' AND '2026-10-31'
      AND o.OrderStatus = 'Completed'
    GROUP BY s.StoreID
),
combined AS (
    SELECT g.*, COALESCE(r.ReturnValue, 0) AS ReturnValue,
           g.GrossSales - COALESCE(r.ReturnValue, 0) AS NetSales
    FROM gross g LEFT JOIN ret r ON g.StoreID = r.StoreID
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY RegionName ORDER BY NetSales DESC) AS rnk,
           SUM(NetSales) OVER (PARTITION BY RegionName) AS RegionNet
    FROM combined
)
SELECT StoreID, StoreName, RegionName,
       ROUND(GrossSales, 2) AS GrossSales,
       ROUND(ReturnValue, 2) AS ReturnValue,
       ROUND(NetSales, 2) AS NetSales,
       CASE WHEN rnk = 1 THEN 'WINNER' END AS WinnerFlag,
       CASE WHEN RegionNet = 0 THEN 'N/A'
            ELSE CAST(ROUND(NetSales * 100.0 / RegionNet, 2) AS TEXT) || '%'
       END AS ShareOfRegionNet
FROM ranked
ORDER BY RegionName, rnk, StoreID;