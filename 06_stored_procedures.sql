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
    CONSTRAINT fk_data4_user_procedures FOREIGN KEY (user_id) REFERENCES data3(user_id),
    UNIQUE KEY uq_data4_email_procedures (email)
);

CREATE TABLE IF NOT EXISTS data5 (
    user_id INT PRIMARY KEY,
    password_hash CHAR(64) NOT NULL,
    password_updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_data5_user_procedures FOREIGN KEY (user_id) REFERENCES data3(user_id)
);

DROP PROCEDURE IF EXISTS sp_normalize_users;
DROP PROCEDURE IF EXISTS sp_users_by_domain;

DELIMITER $$

CREATE PROCEDURE sp_normalize_users()
BEGIN
    INSERT INTO data3 (user_id, user_name)
    SELECT user_id, user_name FROM data1 AS new
    ON DUPLICATE KEY UPDATE user_name = new.user_name;

    INSERT INTO data4 (user_id, email, phone)
    SELECT user_id, email, phone FROM data1 AS new
    ON DUPLICATE KEY UPDATE email = new.email, phone = new.phone;

    INSERT INTO data5 (user_id, password_hash)
    SELECT user_id, SHA2(user_password, 256) FROM data1 AS new
    ON DUPLICATE KEY UPDATE password_hash = SHA2(new.user_password, 256),
                            password_updated_at = CURRENT_TIMESTAMP;
END$$

CREATE PROCEDURE sp_users_by_domain(IN requested_domain VARCHAR(255))
BEGIN
    SELECT p.user_id, p.user_name, c.email, c.phone
    FROM data3 AS p
    INNER JOIN data4 AS c ON c.user_id = p.user_id
    WHERE LOWER(SUBSTRING_INDEX(c.email, '@', -1)) = LOWER(requested_domain)
    ORDER BY p.user_id;
END$$

DELIMITER ;

CALL sp_normalize_users();
-- CALL sp_users_by_domain('gmail.com');
