-- Q4: Orders with matching customers
SELECT o.OrderID, o.CustomerID, c.CustomerName
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY o.OrderID;

-- Q5: Orders with unmatched customer IDs
SELECT o.OrderID, o.CustomerID
FROM Orders o
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL
ORDER BY o.OrderID;
-- Expected: OrderID 1006, CustomerID 99

-- Q6: Customers with no orders
SELECT c.CustomerID, c.CustomerName
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL
ORDER BY c.CustomerID;
-- Expected: CustomerID 99 is NOT in Customers; check who is missing
-- (from your data, one customer has no order — verify after running)

-- Q7: Order lines with more than one return transaction
SELECT OrderItemID,
       COUNT(*)            AS ReturnTransactionCount,
       SUM(ReturnQuantity) AS TotalReturnedUnits
FROM Returns
GROUP BY OrderItemID
HAVING COUNT(*) > 1
ORDER BY OrderItemID;
-- Expected: OrderItemID 5003 with 2 returns