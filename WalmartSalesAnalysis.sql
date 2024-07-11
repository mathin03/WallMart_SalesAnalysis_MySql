SELECT * FROM sales;

-- Feature engineering
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales
SET time_of_day = (
             CASE 
             WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
             WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
             ELSE "Eveninig" 
             END);
SELECT time,(
			 CASE 
             WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
             WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
             ELSE "Eveninig" 
             END) AS time_of_date
FROM sales ;

-- day_name

SELECT date,DAYNAME(date)
FROM sales;
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
UPDATE sales
SET day_name =DAYNAME(date);

-- month_name

SELECT date,MONTHNAME(date)
FROM sales;
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales
SET month_name=MONTHNAME(date);

-- Exploratory Data Analysis (EDA)

-- Generic Questions

-- 1.How many unique cities does the data have?

 SELECT * FROM sales;
 
 SELECT DISTINCT city
 FROM sales;
 
--  In which city is each branch?

SELECT  DISTINCT city,branch
FROM sales ;

-- Product
 
 SELECT * FROM sales;
 
-- 1.How many unique product lines does the data have?

 SELECT DISTINCT COUNT(DISTINCT product_line)
 FROM sales;
 
-- 2.What is the most common payment method?

  SELECT  payment_method,COUNT(*)
  FROM sales
  GROUP BY payment_method
  ORDER BY COUNT(*) DESC;
  
-- 3.What is the most selling product line?

  SELECT  product_line,COUNT( product_line) AS count_prod_line
  FROM sales
  GROUP BY   product_line
  ORDER BY count_prod_line DESC;
  
-- 4.What is the total revenue by month?

 SELECT month_name ,SUM(total) AS total_revenue
 FROM sales
 GROUP BY month_name;
 
-- 5.What month had the largest COGS?

SELECT month_name,MAX(cogs) as MaxCOGS
FROM sales
GROUP BY month_name;

-- 6.What product line had the largest revenue?

SELECT product_line,SUM(total)
FROM sales
GROUP BY product_line
ORDER BY SUM(total) DESC;

-- 7.What is the city with the largest revenue?
SELECT city,SUM(total) as city_wise_revenue
FROM sales
GROUP BY city
ORDER BY city_wise_revenue;
-- 8.What product line had the largest VAT?
SELECT product_line,MAX(VAT) as vatt
FROM sales 
GROUP BY product_line
ORDER BY vatt DESC;

-- 9.Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

ALTER TABLE sales ADD COLUMN gb VARCHAR(5);
WITH avg_sales AS (
    SELECT product_line, AVG(quantity) AS avg_quantity
    FROM sales
    GROUP BY product_line
),
overall_avg AS (
    SELECT AVG(quantity) AS overall_avg_quantity
    FROM sales
)

-- Step 3: Update the gb column based on the average sales comparison
UPDATE sales
SET gb = (
    SELECT CASE
        WHEN avg_sales.avg_quantity > overall_avg.overall_avg_quantity THEN 'Good'
        ELSE 'Bad'
    END
    FROM avg_sales, overall_avg
    WHERE sales.product_line = avg_sales.product_line
);

-- 10.Which branch sold more products than average product sold?
SELECT branch,AVG(quantity) AS qty
FROM sales
GROUP BY branch
HAVING AVG(quantity) > (SELECT AVG(quantity)
FROM sales);

-- 11.What is the most common product line by gender?
SELECT gender ,MAX(product_line)
FROM sales
GROUP BY gender;
-- 12.What is the average rating of each product line?
SELECT product_line,AVG(rating)
FROM sales 
GROUP BY product_line;

-- SALES

-- Number of sales made in each time of the day per weekday

SELECT day_name,COUNT(*)
FROM sales
GROUP BY day_name;

-- Which of the customer types brings the most revenue?

SELECT customer_type,SUM(total)
FROM sales
GROUP BY customer_type
ORDER BY SUM(total);

-- Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT city,AVG(VAT)
FROM sales
GROUP BY city
ORDER BY AVG(VAT)
LIMIT 1;

-- Which customer type pays the most in VAT?
 SELECT customer_type,SUM(VAT)
 FROM sales 
 GROUP BY customer_type
 ORDER BY SUM(VAT);

-- CUSTOMER

-- How many unique customer types does the data have?
SELECT DISTINCT customer_type
FROM sales;
-- How many unique payment methods does the data have?
SELECT DISTINCT payment_method 
FROM sales;

-- What is the most common customer type?

SELECT customer_type,COUNT(*)
FROM sales
GROUP BY customer_type
ORDER  BY COUNT(*) DESC;

-- What is the gender of most of the customers?

SELECT gender,COUNT(*)
FROM sales
GROUP BY gender
ORDER BY COUNT(*) DESC;

-- What is the gender distribution per branch?

SELECT gender,COUNT(*)
FROM sales
WHERE branch="A"
GROUP BY gender
ORDER BY COUNT(*) DESC;

-- Which time of the day do customers give most ratings?

SELECT time_of_day,AVG(rating)
FROM sales
GROUP BY time_of_day
ORDER BY AVG(rating);

-- Which time of the day do customers give most ratings per branch?


-- Which day fo the week has the best avg ratings?

SELECT day_name,AVG(rating)
FROM sales
GROUP BY day_name
ORDER BY AVG(rating) DESC;

-- Which day of the week has the best average ratings per branch?
SELECT day_name,AVG(rating)
FROM sales
WHERE branch="C"
GROUP BY day_name
ORDER BY AVG(rating) DESC
LIMIT 1;



