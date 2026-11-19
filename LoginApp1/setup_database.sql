-- Database setup script for LoginApp1
CREATE DATABASE IF NOT EXISTS LoginDB;
USE LoginDB;

-- Table 1: Student
CREATE TABLE IF NOT EXISTS Student (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    enrollment_no VARCHAR(50) NOT NULL,
    batch VARCHAR(50) NOT NULL,
    official_email VARCHAR(100) NOT NULL,
    mobile_number VARCHAR(20) NOT NULL,
    dob DATE,
    address VARCHAR(255),
    state VARCHAR(50),
    city VARCHAR(50)
);

-- Table 2: Login
CREATE TABLE IF NOT EXISTS Login (
    user_id VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL
);

-- Default Admin accounts
INSERT INTO Login (user_id, password) 
VALUES 
    ('admin', '1234'),
    ('admin', 'password123');
