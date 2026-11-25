-- Q8(a): Completed orders + gross sales by region for October 2026
SELECT
    r.RegionName,
    COUNT(DISTINCT o.OrderID)          AS CompletedOrders,
    ROUND(SUM(oi.Quantity * oi.UnitPrice), 2) AS GrossSales
FROM Orders o
JOIN Stores  s ON o.StoreID = s.StoreID
JOIN Regions r ON s.RegionID = r.RegionID
JOIN OrderItemsClean oi ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Completed'
  AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
GROUP BY r.RegionName
ORDER BY GrossSales DESC;

-- Q8(b): Return value by region for October 2026 returns
-- Assigned to original selling store/region; returns against earlier orders included
SELECT
    r.RegionName,
    ROUND(SUM(ret.ReturnQuantity * oi.UnitPrice), 2) AS ReturnValue
FROM Returns ret
JOIN OrderItemsClean oi ON ret.OrderItemID = oi.OrderItemID
JOIN Orders o ON oi.OrderID = o.OrderID
JOIN Stores s ON o.StoreID = s.StoreID
JOIN Regions r ON s.RegionID = r.RegionID
WHERE ret.ReturnDate BETWEEN '2026-10-01' AND '2026-10-31'
  AND o.OrderStatus = 'Completed'
GROUP BY r.RegionName
ORDER BY ReturnValue DESC;

-- Q8(c): Net sales per region (join both outputs)
WITH g AS (
    SELECT r.RegionName,
           COUNT(DISTINCT o.OrderID) AS CompletedOrders,
           SUM(oi.Quantity * oi.UnitPrice) AS GrossSales
    FROM Orders o
    JOIN Stores s  ON o.StoreID = s.StoreID
    JOIN Regions r ON s.RegionID = r.RegionID
    JOIN OrderItemsClean oi ON oi.OrderID = o.OrderID
    WHERE o.OrderStatus = 'Completed'
      AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
    GROUP BY r.RegionName
),
rv AS (
    SELECT r.RegionName, SUM(ret.ReturnQuantity * oi.UnitPrice) AS ReturnValue
    FROM Returns ret
    JOIN OrderItemsClean oi ON ret.OrderItemID = oi.OrderItemID
    JOIN Orders o ON oi.OrderID = o.OrderID
    JOIN Stores s ON o.StoreID = s.StoreID
    JOIN Regions r ON s.RegionID = r.RegionID
    WHERE ret.ReturnDate BETWEEN '2026-10-01' AND '2026-10-31'
      AND o.OrderStatus = 'Completed'
    GROUP BY r.RegionName
)
SELECT
    g.RegionName,
    g.CompletedOrders,
    ROUND(g.GrossSales, 2) AS GrossSales,
    ROUND(COALESCE(rv.ReturnValue, 0), 2) AS ReturnValue,
    ROUND(g.GrossSales - COALESCE(rv.ReturnValue, 0), 2) AS NetSales
FROM g
LEFT JOIN rv ON g.RegionName = rv.RegionName
ORDER BY NetSales DESC;

-- Q9: Leader comparison (run after Q8(c) and note values)
-- Highest gross sales region:  see top row of Q8(a)
-- Highest net  sales region:  see top row of Q8(c)
-- Did the leader change?     compare the two names
-- Net sales gap:             NetSales(top1) - NetSales(top2) from Q8(c)