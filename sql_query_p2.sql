-- create a table --

drop table if exists retailsales;
create table retailsales
(
	transactions_id int,
	sale_date date,
	sale_time time,
	customer_id int,
	gender varchar(15),
	age int,
	category varchar(15),
	quantity int,
	price_per_unit int,
	cogs float,
	total_sale float

)
-- import values from dataset --

-- display all transactions --

select * from retailsales

-- count total number of records --

select count(*) from retailsales;

--  Data Cleaning --

select * from retailsales
where transactions_id is null
	  or
	  sale_date is null
	  or 
	  sale_time is null
	  or
	  customer_id is null
	  or 
	  gender is null
	  or
	  age is null
	  or
	  category is null
	  or 
	  quantity is null
	  or
	  price_per_unit is null
	  or
	  cogs is null
	  or
	  total_sale is null
;

delete from retailsales
where transactions_id is null
	  or
	  sale_date is null
	  or 
	  sale_time is null
	  or
	  customer_id is null
	  or 
	  gender is null
	  or
	  age is null
	  or
	  category is null
	  or 
	  quantity is null
	  or
	  price_per_unit is null
	  or
	  cogs is null
	  or
	  total_sale is null;
	  
-- display count of records --

select count(*) from retailsales;

-- data analysis & Findings --
-- The following SQL queries were developed to answer specific business questions: --

-- 1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**: --
select * from retailsales 
where sale_date='2022-11-05';

-- 2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**: --
select 
	*
from retailsales
where category = 'Clothing'
	  and 
	  quantity >=4
	  and
	  To_char(sale_date,'yyyy-mm')='2022-11';

-- 3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:  --
select category,sum(total_sale)
from retailsales
group by 1;

-- 4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**: --
select round(avg(age),2) from retailsales
where category='Beauty';

-- 5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**: --
select * from retailsales 
where total_sale>1000;

-- 6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**: --
select
	   gender,
	   category,
	   count(*) as total_trans
from retailsales 
group by 1,2
order by 1

-- 7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**: --
select year,
month,
average_sale from
(select
	   extract(year from sale_date) as year,
	   extract(month from sale_date) as month,
	   avg(total_sale) as average_sale,
	   rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retailsales
group by 1,2) as t1
where rank=1

-- 8. **Write a SQL query to find the top 5 customers based on the highest total sales **: --
select customer_id, sum(total_sale)
from retailsales group by 1
limit 5

-- 9. **Write a SQL query to find the number of unique customers who purchased items from each category.**: --
select count(distinct customer_id),category
from retailsales 
group by 2

-- 10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**: --
with hoursale
as(
select *,
case when extract(hour from sale_time)<12 then 'Morning'
      when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
	  else 'Evening' end as shift
	  from retailsales)
	  select shift,count(*) as total_orders
	  from hoursale
	  group by 1