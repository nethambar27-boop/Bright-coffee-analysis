1. ---Check the data that is in the table
select*
from brightcoffee.coffeesales.`1785257374032_bright_coffee_shop_sales`


2. --check if all colomns are in correct format
  --unit price needs to be changed from , to .
  select
      CAST (REPLACE(unit_price,',','.') AS DOUBLE) AS unit_price
  from brightcoffee.coffeesales.`1785257374032_bright_coffee_shop_sales`

 3. ---Count the number of records which are there
  select COUNT(*) 
  from brightcoffee.coffeesales.`1785257374032_bright_coffee_shop_sales`

 4.  ----Check for Null values
  select
      count(*) 
  from brightcoffee.coffeesales.`1785257374032_bright_coffee_shop_sales`
  where transaction_id is null or transaction_date is null or transaction_time is null or transaction_qty is null or store_id is null or store_location is null or product_id is null or unit_price is null or product_category is null or product_type is null or product_detail is null;   --There was no null value found

  5. ---checking duplicates values
  select
      transaction_id,
      transaction_date,
      transaction_time,
      transaction_qty,
      store_id,
      store_location,
      product_id,
      unit_price,
      count(*)
  from brightcoffee.coffeesales.`1785257374032_bright_coffee_shop_sales`
  group by all
  having count(*) > 1;---- no duplicates found

  
 6. ---calculating the total revenue
  select
      round(sum(transaction_qty *  CAST (REPLACE(unit_price,',','.') AS DOUBLE) ::double),2) as total_revenue
  from brightcoffee.coffeesales.`1785257374032_bright_coffee_shop_sales` --- use ROUND() function to round the result to 2 decimal places

7. --- Calculating the TOTAL REVANUE per PRODUCT CATEGORTY and product detail
 select
      Product_category,
      product_detail,
      round(sum(transaction_qty *  CAST (REPLACE(unit_price,',','.') AS DOUBLE) ::double),2) as total_revenue
  from brightcoffee.coffeesales.`1785257374032_bright_coffee_shop_sales`
  Group by all;

  8. --- Calculating Total Revenue per store location 
  select
      store_location,
      round(sum(transaction_qty *  CAST (REPLACE(unit_price,',','.') AS DOUBLE) ::double),2) as total_revenue
  from brightcoffee.coffeesales.`1785257374032_bright_coffee_shop_sales`
  Group by all;
  
  
  9.---checking the  minimum and maximum time from the dataset before doing the time backet
  select
      min(transaction_time) as min_time,
      max(transaction_time) as max_time
  from brightcoffee.coffeesales.`1785257374032_bright_coffee_shop_sales`;

  10. -----Calculating the Total revenue based on the time of the day--
  --6:00 am - 11:59 am > morning
  --12:00 pm - 16:59pm > afternoon
  --17:00 pm - 11:59 pm > evening
  select
      case
          when date_format(transaction_time,'HH:mm:ss')between '06:00:00' and '11:59:59' then 'morning'
          when date_format(transaction_time,'HH:mm:ss') between '12:00:00' and '16:59:59' then 'afternoon'
          when date_format(transaction_time,'HH:mm:ss') between '17:00:00' and '23:59:59' then 'evening'
          else 'night'
      end as time_of_day
    from brightcoffee.coffeesales.`1785257374032_bright_coffee_shop_sales`;

   11.  --- calculating the 3 hour time bucket
    select
         transaction_time,
         date_format(transaction_time,'HH:mm:ss') as time,
         case
          when date_format(transaction_time,'HH:mm:ss')between '06:00:00' and '08:59:59' then '06:00:00 - 08:59:59'
          when date_format(transaction_time,'HH:mm:ss') between '09:00:00' and '11:59:59' then '09:00:00 - 11:59:59'
          when date_format(transaction_time,'HH:mm:ss') between '12:00:00' and '14:59:59' then '12:00:00 - 14:59:59'
          when date_format(transaction_time,'HH:mm:ss') between '15:00:00' and '17:59:59' then '15:00:00 - 17:59:59'
          when date_format(transaction_time,'HH:mm:ss') between '18:00:00' and '20:59:59' then '18:00:00 - 20:59:59'
          when date_format(transaction_time,'HH:mm:ss') between '21:00:00' and '23:59:59' then '21:00:00 - 23:59:59'
          else 'night'
      end as time_bucket
    from brightcoffee.coffeesales.`1785257374032_bright_coffee_shop_sales`;

   13. --- calculating the Total revenue per time of the day
    select,
      round(sum(transaction_qty *  CAST (REPLACE(unit_price,',','.') AS DOUBLE) ::double),2) as total_revenue
    from brightcoffee

 14. ----we want to see how much we made per total backet 
  select
      case
          when date_format(transaction_time,'HH:mm:ss')between '06:00:00' and '11:59:59' then 'morning'
          when date_format(transaction_time,'HH:mm:ss') between '12:00:00' and '16:59:59' then 'afternoon'
          when date_format(transaction_time,'HH:mm:ss') between '17:00:00' and '23:59:59' then 'evening'
          else 'night'
      end as time_of_day,
    round(sum(transaction_qty *  CAST (REPLACE(unit_price,',','.') AS DOUBLE) ::double),2) as total_revenue,
    product_category,
    from brightcoffee.coffeesales.`1785257374032_bright_coffee_shop_sales`
    GROUP BY ALL;
  14. ----Calculating the total revenue per day of the week, month and day of the week
  select
      transaction_date,
      MONTHNAME(transaction_date) as month,
      MONTH(transaction_date) as month_number,
      DATE_FORMAT(transaction_date,'yyyy-MM-dd') as month_id,
      DAYNAME(transaction_date) as day,
      DAYOFWEEK(transaction_date) as day_of_week
    from brightcoffee.coffeesales.`1785257374032_bright_coffee_shop_sales`;
    
    -----------------------combining everything-------------------------------------
     select
         transaction_date,
         MONTHNAME(transaction_date) as month,
         MONTH(transaction_date) as month_number,
         DATE_FORMAT(transaction_date,'yyyy-MMM') as month_id,
         DAYNAME(transaction_date) as day,
         DAYOFWEEK(transaction_date) as day_of_week,
         count(transaction_id) as total_trasactions,
         count(product_id) as total_products,
         product_category,
         product_detail,
         product_type,
         store_location,
         case
            when date_format(transaction_time,'HH:mm:ss')between '06:00:00' and '11:59:59' then 'morning'
            when date_format(transaction_time,'HH:mm:ss') between '12:00:00' and '16:59:59' then 'afternoon'
            when date_format(transaction_time,'HH:mm:ss') between '17:00:00' and '23:59:59' then 'evening'
            else 'night'
         end as time_of_day,
         case
            when date_format(transaction_time,'HH:mm:ss')between '06:00:00' and '08:59:59' then '06:00:00 - 08:59:59'
            when date_format(transaction_time,'HH:mm:ss') between '09:00:00' and '11:59:59' then '09:00:00 - 11:59:59'
            when date_format(transaction_time,'HH:mm:ss') between '12:00:00' and '14:59:59' then '12:00:00 - 14:59:59'
            when date_format(transaction_time,'HH:mm:ss') between '15:00:00' and '17:59:59' then '15:00:00 - 17:59:59'
            when date_format(transaction_time,'HH:mm:ss') between '18:00:00' and '20:59:59' then '18:00:00 - 20:59:59'
            when date_format(transaction_time,'HH:mm:ss') between '21:00:00' and '23:59:59' then '21:00:00 - 23:59:59'
            else 'night'
         end as time_bucket,
         Sum(transaction_qty *  CAST(REPLACE(unit_price,',','.') AS DECIMAL(10,2))) as total_revenue
     from brightcoffee.coffeesales.`1785257374032_bright_coffee_shop_sales`
     group by all;

   

 