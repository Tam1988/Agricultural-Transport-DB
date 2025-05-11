/* 
===========================================
Agricultural Goods Transportation Management System
Author: Ajaluwa Tamara
Date: [05/10/2023]
===========================================
*/

-- Step 1: Create the Database
CREATE DATABASE AgriculturalTransportDB;
USE AgriculturalTransportDB;

/* 
===========================================
Step 2: Define Tables with Constraints
===========================================
*/   

-- Farmers Table: Stores farmer details
CREATE TABLE Farmers (
    farmer_id INT PRIMARY KEY AUTO_INCREMENT ,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,  
    phone VARCHAR(15) NOT NULL,
    address TEXT NOT NULL,
    registration_date DATE NOT NULL
);

-- Agricultural Goods Table: Tracks goods owned by farmers
CREATE TABLE AgriculturalGoods (
    goods_id INT PRIMARY KEY AUTO_INCREMENT ,
    name VARCHAR(100) NOT NULL,
    type ENUM('Grain', 'Vegetable', 'Fruit', 'Legume', 'Root', 'Other') NOT NULL,  
    quantity DECIMAL(10,2) NOT NULL,
    packaging_type ENUM('Bag', 'Crate', 'Box', 'Bulk') NOT NULL, 
    farmer_id INT NOT NULL,
    FOREIGN KEY (farmer_id) REFERENCES Farmers(farmer_id)  
);

-- Transport Vehicles Table: Stores vehicle details
CREATE TABLE TransportVehicles (
    vehicle_id INT PRIMARY KEY AUTO_INCREMENT ,
    vehicle_type ENUM('Truck', 'Van', 'Trailer', 'Refrigerated Truck') NOT NULL,
    capacity DECIMAL(10,2) NOT NULL, 
    license_plate VARCHAR(20) UNIQUE NOT NULL,  
    status ENUM('Available', 'In Transit', 'Under Maintenance') DEFAULT 'Available'
);

-- Drivers Table: Stores driver details
CREATE TABLE Drivers (
    driver_id INT PRIMARY KEY AUTO_INCREMENT ,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL, 
    experience_years INT,
    assigned_vehicle_id INT UNIQUE,  
    FOREIGN KEY (assigned_vehicle_id) REFERENCES TransportVehicles(vehicle_id)  
);

-- Delivery Routes Table: Stores predefined transport routes
CREATE TABLE DeliveryRoutes (
    route_id INT PRIMARY KEY AUTO_INCREMENT ,
    starting_position VARCHAR(255) NOT NULL,  
    destination VARCHAR(255) NOT NULL, 
    estimated_time DECIMAL(5,2) NOT NULL,
    distance_km DECIMAL(10,2) NOT NULL 
);

-- Shipments Table: Tracks agricultural goods transportation
CREATE TABLE Shipments (
    shipment_id INT PRIMARY KEY  AUTO_INCREMENT ,
    goods_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    driver_id INT NOT NULL,
    route_id INT NOT NULL,
    shipment_date DATE NOT NULL,
    delivery_status ENUM('Pending', 'In Transit', 'Delivered', 'Delayed') DEFAULT 'Pending',
    FOREIGN KEY (goods_id) REFERENCES AgriculturalGoods(goods_id),
    FOREIGN KEY (vehicle_id) REFERENCES TransportVehicles(vehicle_id),
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id),
    FOREIGN KEY (route_id) REFERENCES DeliveryRoutes(route_id)  
);

-- Transactions Table: Tracks payments for transportation services
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT ,
    farmer_id INT NOT NULL,
    shipment_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
    payment_status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    FOREIGN KEY (farmer_id) REFERENCES Farmers(farmer_id),
    FOREIGN KEY (shipment_id) REFERENCES Shipments(shipment_id)  
);
 
/*
===========================================
Step 3: Audit Log Table  
===========================================
*/

-- Tracking shipment status changes for accountability
CREATE TABLE ShipmentLogs (
    log_id INT PRIMARY KEY AUTO_INCREMENT ,
    shipment_id INT NOT NULL,
    status_change ENUM ('Pending', 'In Transit', 'Delivered', 'Delayed') DEFAULT 'Pending',
    change_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (shipment_id) REFERENCES Shipments(shipment_id) 
);

/* 
===========================================
Step 3: Performance Enhancements (Indexes)
===========================================
*/
-- Indexes to speed up queries
CREATE INDEX idxfarmers_email ON Farmers(email);
CREATE INDEX idxvehicles_license ON TransportVehicles(license_plate);
CREATE INDEX idxshipments_date ON Shipments(shipment_date);
