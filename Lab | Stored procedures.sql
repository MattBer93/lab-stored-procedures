use sakila;

-- 1)
-- In the previous lab we wrote a query to find first name, last name, and emails of all the customers 
-- who rented Action movies. 
-- Convert the query into a simple stored procedure. Use the following query:
select c.first_name, c.last_name, c.email
from category ca 
join film_category fm using (category_id)
join film f using (film_id)
join inventory i using (film_id)
join rental r using (inventory_id) 
join customer c using(customer_id) 
where name = 'Action'
group by first_name, last_name, email;


DELIMITER // 
create procedure cus_action_movies_proc()
begin 
	select c.first_name, c.last_name, c.email
	from category ca 
	join film_category fm using (category_id)
	join film f using (film_id)
	join inventory i using (film_id)
	join rental r using (inventory_id) 
	join customer c using(customer_id) 
	where name = 'Action'
	group by first_name, last_name, email;
end // 
DELIMITER ;

call cus_action_movies_proc();


-- 2)
-- Now keep working on the previous stored procedure to make it more dynamic. 
-- Update the stored procedure in a such manner that it can take a string argument 
-- for the category name and return the results for all customers that rented movie of that category/genre. 
-- For eg., it could be action, animation, children, classics, etc.
DELIMITER // 
create procedure cus_per_movie_cat_proc(in category varchar(20))
begin 
	select c.first_name, c.last_name, c.email, ca.name
	from category ca 
	join film_category fm using (category_id)
	join film f using (film_id)
	join inventory i using (film_id)
	join rental r using (inventory_id) 
	join customer c using(customer_id) 
	where name = category
	group by first_name, last_name, email, name;
end // 
DELIMITER ;

call cus_per_movie_cat_proc('children');


-- 3)
-- Write a query to check the number of movies released in each movie category. 
select ca.name, count(fc.film_id) as movies_per_category 
from film_category fc
join category ca using (category_id)
group by ca.name
order by count(film_id) desc;

-- Convert the query in to a stored procedure to filter only those categories that have movies 
-- released greater than a certain number. Pass that number as an argument in the stored procedure.
DELIMITER // 
create procedure movies_higher_than_threshold_proc(in threshold int)
begin
	select ca.name, count(fc.film_id) as movies_per_category 
	from film_category fc
	join category ca using (category_id)
	group by ca.name
    having count(film_id) >= threshold
	order by count(film_id) desc;
end
// DELIMITER ;

call movies_higher_than_threshold_proc(50);






