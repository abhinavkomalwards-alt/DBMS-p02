USE abhinav_dbms;

-- INNER JOIN
SELECT a.user_id, a.user_name, a.email
FROM data1 AS a
INNER JOIN data2 AS b ON b.user_id = a.user_id;

-- LEFT JOIN
SELECT a.user_id, a.user_name, b.email AS filtered_email
FROM data1 AS a
LEFT JOIN data2 AS b ON b.user_id = a.user_id;

-- RIGHT JOIN
SELECT b.user_id, b.user_name, a.email AS original_email
FROM data1 AS a
RIGHT JOIN data2 AS b ON b.user_id = a.user_id;

-- Multiple-table JOIN
SELECT p.user_id, p.user_name, c.email, c.phone,
       'credential-present' AS credential_status
FROM data3 AS p
JOIN data4 AS c ON c.user_id = p.user_id
JOIN data5 AS s ON s.user_id = p.user_id;

-- SELF JOIN: users sharing an email domain
SELECT a.user_name AS user_a, b.user_name AS user_b,
       SUBSTRING_INDEX(a.email, '@', -1) AS email_domain
FROM data1 AS a
JOIN data1 AS b
  ON SUBSTRING_INDEX(a.email, '@', -1) = SUBSTRING_INDEX(b.email, '@', -1)
 AND a.user_id < b.user_id;
