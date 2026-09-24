USE abhinav_dbms;

DROP TRIGGER IF EXISTS trg_data4_contact_update;

DELIMITER $$

CREATE TRIGGER trg_data4_contact_update
AFTER UPDATE ON data4
FOR EACH ROW
BEGIN
    IF NOT (OLD.email <=> NEW.email) THEN
        INSERT INTO user_audit (user_id, old_email, new_email)
        VALUES (NEW.user_id, OLD.email, NEW.email);
    END IF;
END$$

DELIMITER ;

-- Test the trigger:
-- UPDATE data4 SET email = 'updated@example.com' WHERE user_id = 1;
-- SELECT * FROM user_audit ORDER BY audit_id DESC;
