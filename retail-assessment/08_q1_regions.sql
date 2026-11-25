-- Q1: Create and populate Regions, link Stores, show mapping + unmapped
DROP TABLE IF EXISTS Regions;
CREATE TABLE Regions (
    RegionID   INTEGER PRIMARY KEY,
    RegionName TEXT NOT NULL UNIQUE
);

INSERT INTO Regions (RegionID, RegionName) VALUES
(1, 'North'), (2, 'South'), (3, 'West');

UPDATE Stores
SET RegionID = CASE
    WHEN UPPER(TRIM(RegionRaw)) IN ('N','NORTH') THEN 1
    WHEN UPPER(TRIM(RegionRaw)) IN ('S','SOUTH') THEN 2
    WHEN UPPER(TRIM(RegionRaw)) IN ('W','WEST')  THEN 3
    ELSE NULL
END;

-- Mapping result
SELECT s.StoreID, s.StoreName, s.RegionRaw, r.RegionName
FROM Stores s
LEFT JOIN Regions r ON s.RegionID = r.RegionID
ORDER BY s.StoreID;

-- Unmapped stores (should be empty)
SELECT StoreID, StoreName, RegionRaw
FROM Stores WHERE RegionID IS NULL;