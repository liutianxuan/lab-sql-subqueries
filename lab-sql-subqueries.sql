-- Lab | SQL Subqueries 3.03
-- In this lab, you will be using the Sakila database of movie rentals. Create appropriate joins wherever necessary.

-- Instructions
-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT count(film_id)
FROM inventory
INNER JOIN film USING (film_id)
WHERE title = 'Hunchback Impossible';

-- 2. List all films whose length is longer than the average of all the films.
SELECT title
FROM film
WHERE length > (SELECT AVG(length) as average
      FROM film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (SELECT actor_id 
	   FROM film_actor
	   WHERE film_id = (SELECT film_id 
                        FROM film
                        WHERE title = 'Alone Trip'));

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title
FROM film
WHERE film_id IN (SELECT film_id
				 FROM film_category
                 WHERE category_id IN (SELECT category_id
                                      FROM category
                                      WHERE name = 'Family'));

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (SELECT address_id 
                     FROM address
                     WHERE city_id IN (SELECT city_id
                                       FROM city
                                       WHERE country_id IN (SELECT country_id
                                                            FROM country
                                                            WHERE country = 'Canada')));
                                                          
Select first_name, last_name, email, country
From customer
inner join address
USING (address_id)
inner join city
USING (city_id)
inner join country
USING (country_id)
WHERE country = "Canada";

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT actor_id, count(film_id) count
FROM film_actor
GROUP BY actor_id
ORDER BY count DESC
LIMIT 1;

SELECT title
FROM film 
WHERE film_id IN (SELECT film_id
                  FROM film_actor
                  WHERE actor_id = 107);
#Error Code: 1235. This version of MySQL doesn't yet support 'LIMIT & IN/ALL/ANY/SOME subquery'

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT customer_id, sum(amount)
FROM payment
GROUP BY customer_id
ORDER BY sum(amount) DESC
LIMIT 1;

SELECT title
FROM film
WHERE film_id IN (SELECT film_id
                 FROM rental_inventory
                 WHERE rental_id IN (SELECT rental_id
                                     FROM payment
                                     WHERE customer_id = 526));

-- 8. Customers who spent more than the average payments.
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (SELECT customer_id
                      FROM payment
                      GROUP BY customer_id
                      HAVING sum(amount) > 
                      (SELECT avg(sum)
                      FROM (
                          SELECT sum(amount) as sum
					      FROM payment
					      group by customer_id) sub1
                          )
						);

