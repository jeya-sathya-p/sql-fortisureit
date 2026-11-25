-- Verify the load matches Read_Me expected counts
SELECT 'Customers'  AS TableName, COUNT(*) AS RowCount FROM Customers
UNION ALL SELECT 'Stores',     COUNT(*) FROM Stores
UNION ALL SELECT 'Products',   COUNT(*) FROM Products
UNION ALL SELECT 'Orders',     COUNT(*) FROM Orders
UNION ALL SELECT 'OrderItems', COUNT(*) FROM OrderItems
UNION ALL SELECT 'Returns',    COUNT(*) FROM Returns;
