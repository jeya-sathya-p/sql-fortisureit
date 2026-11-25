-- Retail Sales SQL Assessment — Schema (SQLite)
PRAGMA foreign_keys = OFF;

DROP TABLE IF EXISTS Returns;
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Stores;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    CustomerID   INTEGER PRIMARY KEY,
    CustomerName TEXT    NOT NULL,
    SignupDate   TEXT
);

CREATE TABLE Stores (
    StoreID   INTEGER PRIMARY KEY,
    StoreName TEXT    NOT NULL,
    RegionRaw TEXT,
    RegionID  INTEGER
);

CREATE TABLE Products (
    ProductID   INTEGER PRIMARY KEY,
    ProductName TEXT    NOT NULL,
    Category    TEXT    NOT NULL
);

CREATE TABLE Orders (
    OrderID     INTEGER PRIMARY KEY,
    OrderDate   TEXT    NOT NULL,
    CustomerID  INTEGER,          -- intentionally nullable (Q5 unmatched)
    StoreID     INTEGER NOT NULL,
    OrderStatus TEXT    NOT NULL
);

CREATE TABLE OrderItems (
    OrderItemID INTEGER,          -- NOT primary key: duplicates must load
    OrderID     INTEGER NOT NULL,
    ProductID   INTEGER NOT NULL,
    Quantity    INTEGER NOT NULL,
    UnitPrice   REAL    NOT NULL,
    LoadedAt    TEXT    NOT NULL
);

CREATE TABLE Returns (
    ReturnID       INTEGER PRIMARY KEY,
    OrderItemID    INTEGER NOT NULL,
    ReturnDate     TEXT    NOT NULL,
    ReturnQuantity INTEGER NOT NULL
);