-- Q2: Deduplicate OrderItems, keeping latest LoadedAt per OrderItemID
DROP TABLE IF EXISTS OrderItemsClean;
CREATE TABLE OrderItemsClean AS
WITH ranked AS (
    SELECT OrderItemID, OrderID, ProductID, Quantity, UnitPrice, LoadedAt,
           ROW_NUMBER() OVER (
               PARTITION BY OrderItemID
               ORDER BY LoadedAt DESC, UnitPrice DESC
           ) AS rn
    FROM OrderItems
)
SELECT OrderItemID, OrderID, ProductID, Quantity, UnitPrice, LoadedAt
FROM ranked WHERE rn = 1;

-- Before/after check
SELECT 'Raw' AS Stage, COUNT(*) AS Rows FROM OrderItems
UNION ALL
SELECT 'Clean', COUNT(*) FROM OrderItemsClean;

-- Show rows removed (for audit)
SELECT * FROM OrderItems
WHERE OrderItemID IN (
    SELECT OrderItemID FROM OrderItems
    GROUP BY OrderItemID HAVING COUNT(*) > 1
)
ORDER BY OrderItemID, LoadedAt;