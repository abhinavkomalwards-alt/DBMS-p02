-- Run 01_setup_tables.sql, 02_import_datasets.sql and 06_stored_procedures.sql first.
-- The guards below also let this file run safely when opened by itself.
CREATE DATABASE IF NOT EXISTS abhinav_dbms;
USE abhinav_dbms;

CREATE TABLE IF NOT EXISTS data3 (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS data4 (
    user_id INT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_data4_user_views FOREIGN KEY (user_id) REFERENCES data3(user_id),
    UNIQUE KEY uq_data4_email_views (email)
);

CREATE OR REPLACE VIEW vw_user_directory AS
SELECT p.user_id, p.user_name, c.email, c.phone
FROM data3 AS p
JOIN data4 AS c ON c.user_id = p.user_id;

CREATE OR REPLACE VIEW vw_email_domains AS
SELECT SUBSTRING_INDEX(email, '@', -1) AS email_domain,
       COUNT(*) AS user_count
FROM data4
GROUP BY SUBSTRING_INDEX(email, '@', -1);

SELECT * FROM vw_user_directory ORDER BY user_id;
SELECT * FROM vw_email_domains ORDER BY user_count DESC, email_domain;
