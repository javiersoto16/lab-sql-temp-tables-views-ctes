USE sakila
CREATE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer AS c
LEFT JOIN rental AS r 
    ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.email;


CREATE TEMPORARY TABLE temp_customer_payments AS
SELECT 
    c.customer_id,
    SUM(p.amount) AS total_paid
FROM customer c
LEFT JOIN payment p 
    ON c.customer_id = p.customer_id
GROUP BY c.customer_id;


WITH customer_summary AS (
    SELECT 
        crs.customer_name,
        crs.email,
        crs.rental_count,
        tcp.total_paid,
        (tcp.total_paid / crs.rental_count) AS average_payment_per_rental
    FROM customer_rental_summary crs
    LEFT JOIN temp_customer_payments tcp
        ON crs.customer_id = tcp.customer_id
)
SELECT 
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(average_payment_per_rental, 2) AS average_payment_per_rental
FROM customer_summary;

