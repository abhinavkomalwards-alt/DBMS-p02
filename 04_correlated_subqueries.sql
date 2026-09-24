USE abhinav_dbms;

-- Users whose ID is greater than the average ID in their email domain.
SELECT d.user_id, d.user_name, d.email
FROM data1 AS d
WHERE d.user_id > (
    SELECT AVG(other.user_id)
    FROM data1 AS other
    WHERE SUBSTRING_INDEX(other.email, '@', -1) =
          SUBSTRING_INDEX(d.email, '@', -1)
)
ORDER BY d.user_id;

-- Users whose email domain occurs at least twice.
SELECT d.user_id, d.user_name, d.email
FROM data1 AS d
WHERE 2 <= (
    SELECT COUNT(*)
    FROM data1 AS same_domain
    WHERE SUBSTRING_INDEX(same_domain.email, '@', -1) =
          SUBSTRING_INDEX(d.email, '@', -1)
);
