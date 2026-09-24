CREATE DATABASE IF NOT EXISTS abhinav_dbms;
USE abhinav_dbms;

DROP VIEW IF EXISTS vw_user_directory;
DROP VIEW IF EXISTS vw_email_domains;
DROP TRIGGER IF EXISTS trg_data4_contact_update;
DROP PROCEDURE IF EXISTS sp_normalize_users;
DROP PROCEDURE IF EXISTS sp_users_by_domain;
DROP TABLE IF EXISTS user_audit;
DROP TABLE IF EXISTS data5;
DROP TABLE IF EXISTS data4;
DROP TABLE IF EXISTS data3;
DROP TABLE IF EXISTS data2;
DROP TABLE IF EXISTS data1;

CREATE TABLE data1 (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    user_password VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    UNIQUE KEY uq_data1_email (email)
);

CREATE TABLE data2 LIKE data1;

CREATE TABLE data3 (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE data4 (
    user_id INT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_data4_user FOREIGN KEY (user_id) REFERENCES data3(user_id),
    UNIQUE KEY uq_data4_email (email)
);

CREATE TABLE data5 (
    user_id INT PRIMARY KEY,
    password_hash CHAR(64) NOT NULL,
    password_updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_data5_user FOREIGN KEY (user_id) REFERENCES data3(user_id)
);

CREATE TABLE user_audit (
    audit_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    old_email VARCHAR(255) NOT NULL,
    new_email VARCHAR(255) NOT NULL,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
