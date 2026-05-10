CREATE DATABASE fir_system;
USE fir_system;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role ENUM('admin', 'police', 'citizen') NOT NULL
);

CREATE TABLE Police_Stations (
    station_id INT AUTO_INCREMENT PRIMARY KEY,
    station_name VARCHAR(100),
    address TEXT,
    contact_no VARCHAR(15)
);

CREATE TABLE Citizens (
    citizen_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    name VARCHAR(100),
    aadhar_no VARCHAR(12) UNIQUE,
    address TEXT,
    phone_no VARCHAR(15),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Police_Officers (
    officer_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    name VARCHAR(100),
    rank VARCHAR(50),
    station_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (station_id) REFERENCES Police_Stations(station_id)
);

CREATE TABLE FIRs (
    fir_id INT AUTO_INCREMENT PRIMARY KEY,
    citizen_id INT,
    station_id INT,
    officer_id INT,
    date_filed DATE,
    status ENUM('filed', 'under_investigation', 'resolved', 'closed') DEFAULT 'filed',
    description TEXT,
    FOREIGN KEY (citizen_id) REFERENCES Citizens(citizen_id),
    FOREIGN KEY (station_id) REFERENCES Police_Stations(station_id),
    FOREIGN KEY (officer_id) REFERENCES Police_Officers(officer_id)
);

CREATE TABLE FIR_Logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    fir_id INT,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('filed', 'under_investigation', 'resolved', 'closed'),
    remarks TEXT,
    FOREIGN KEY (fir_id) REFERENCES FIRs(fir_id)
);
