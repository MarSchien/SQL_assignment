USE sakila;

-- 1A 
SELECT first_name, last_name
	FROM actor;
-- 1B
ALTER TABLE sakila.actor
	ADD actor_name varchar(200);

SELECT * FROM actor;

-- Because of safe update mode must provide a where clause condition for the update to work

UPDATE actor
SET actor_name = concat (first_name, ' ',  last_name) 
WHERE actor_id>0;
-- 2A
SELECT actor_id, actor_name
FROM actor
WHERE first_name = "Joe";
-- 2B
SELECT actor_name
FROM actor
WHERE last_name like '%GEN%';
-- 2C
SELECT actor_name
FROM actor
WHERE last_name like '%LI%'
ORDER BY last_name, first_name;
-- 2D
SELECT country_id, country
FROM country
WHERE country in ('Afghanistan', 'Bangladesh', 'China');

-- 3A
ALTER TABLE sakila.actor
ADD description blob not null;
-- 3B
ALTER TABLE sakila.actor
DROP description; 
-- 4A
SELECT last_name, count(last_name) 
FROM sakila.actor
GROUP BY last_name;
-- 4B
SELECT last_name, count(last_name) 
FROM sakila.actor
GROUP BY last_name
HAVING COUNT(last_name)>=2;

-- 4C
SET SQL_SAFE_UPDATES =0;
UPDATE sakila.actor
SET actor_name = 'HARPO WILLIAMS', first_name = 'HARPO'
WHERE actor_name = 'GROUCHO WILLIAMS';
SET SQL_SAFE_UPDATES =1;
-- 4D
UPDATE sakila.actor 
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
-- 5A
SHOW CREATE TABLE actor;
-- 6A
SELECT address.address, staff.first_name, staff.last_name
FROM address
INNER JOIN staff 
ON address.address_id=staff.address_id;
-- 6B
SELECT SUM(payment.amount), staff.first_name, staff.last_name
FROM payment
INNER JOIN staff 
ON staff.staff_id=payment.staff_id 
WHERE payment.payment_date like '2005-08%'
GROUP BY staff.staff_id;
-- 6C
SELECT COUNT(film_actor.actor_id), film.title
FROM film
INNER JOIN film_actor 
ON film.film_id=film_actor.film_id
GROUP BY film.title;
-- 6D
SELECT COUNT(inventory.film_id), film.title
FROM inventory
INNER JOIN film 
ON film.film_id=inventory.film_id
WHERE film.title = 'Hunchback Impossible';
-- 6E
SELECT SUM(payment.amount) AS 'total amount paid', customer.first_name, customer.last_name
FROM payment
INNER JOIN customer 
ON payment.customer_id=customer.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;
-- 7A
SELECT title
FROM film
WHERE title LIKE 'K%' OR title LIKE 'Q%'
AND language_id IN
(
	SELECT language_id
    FROM language
    WHERE name = 'English'
);-- 
-- 7B
SELECT actor_name 
FROM actor
WHERE actor_id IN 
(
	SELECT actor_id
    FROM film_actor
    WHERE film_id = 
    (
		SELECT film_id 
        FROM film
        WHERE title = 'Alone Trip'
    )
    


);

-- 7C       
SELECT customer.first_name, customer.last_name, customer.email, country.country
FROM customer INNER JOIN address 
ON address.address_id=customer.address_id 
INNER JOIN city 
ON address.city_id=city.city_id
INNER JOIN country 
ON city.country_id=country.country_id
WHERE country.country ='Canada';
-- 7D
SELECT film.title, category.name 
FROM film INNER JOIN film_category
ON film.film_id=film_category.film_id
INNER JOIN category 
ON category.category_id=film_category.category_id
WHERE category.name = 'Family';
-- 7E
SELECT film.title, COUNT(film.film_id) AS 'Rental times'
FROM film INNER JOIN inventory
ON film.film_id=inventory.film_id
INNER JOIN rental
ON rental.inventory_id=inventory.inventory_id
GROUP BY film.title
ORDER BY COUNT(film.film_id) DESC;
-- 7F
SELECT store.store_id, SUM(payment.amount) AS 'Total rental profit in dollars'
FROM store INNER JOIN customer
ON store.store_id=customer.store_id
INNER JOIN payment 
ON  payment.customer_id=customer.customer_id
GROUP BY store.store_id;
-- 7G
SELECT store.store_id, city.city, country.country
FROM store INNER JOIN address
ON store.address_id=address.address_id
INNER JOIN city 
ON city.city_id=address.address_id
INNER JOIN country
ON country.country_id=city.country_id
GROUP BY store.store_id;
-- 7H
SELECT category.name, SUM(payment.amount) AS 'Gross Revenue'
FROM category INNER JOIN film_category
ON category.category_id=film_category.category_id
INNER JOIN inventory
ON inventory.film_id=film_category.film_id
INNER JOIN rental
ON rental.inventory_id=inventory.inventory_id
INNER JOIN payment
ON payment.rental_id=rental.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;
-- 8A
CREATE VIEW category_gross_revenue AS
SELECT name, SUM(amount) AS 'Gross Revenue'
FROM category INNER JOIN film_category
ON category.category_id=film_category.category_id
INNER JOIN inventory
ON inventory.film_id=film_category.film_id
INNER JOIN rental
ON rental.inventory_id=inventory.inventory_id
INNER JOIN payment
ON payment.rental_id=rental.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;
-- 8B
SELECT * FROM category_gross_revenue;
-- 8C
DROP VIEW category_gross_revenue;










