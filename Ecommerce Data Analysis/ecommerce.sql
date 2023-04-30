 -- Q1
 /*
  Find the division/district/year/month wise total_sale_price joining fact table and respective dimension table
*/
 
SELECT 
    store_dim.division,
    store_dim.district,
    time_dim.year,
    time_dim.month,
    sum(fact_table.unit_price) AS total_sale_price
FROM 
    fact_table
    JOIN store_dim  ON fact_table.store_key = store_dim.store_key
    JOIN time_dim  ON fact_table.time_key = time_dim.time_key
    
GROUP BY
    store_dim.division,
    store_dim.district,
    time_dim.year,
    time_dim.month;
    
 -- Roll UP 
 
SELECT 
    IFNULL(store_dim.division, 'Total') AS division,
    IFNULL(store_dim.district, 'Total') AS district,
    IFNULL(time_dim.year, 'Total') AS year,
    IFNULL(time_dim.month, 'Total') AS month,
    SUM(fact_table.unit_price) AS total_sale_price
FROM 
    fact_table
    JOIN store_dim ON fact_table.store_key = store_dim.store_key
    JOIN time_dim ON fact_table.time_key = time_dim.time_key
GROUP BY
    store_dim.division,
    store_dim.district,
    time_dim.year,
    time_dim.month
WITH ROLLUP;

-- SlICE

SELECT 
    IFNULL(store_dim.division, 'Total') AS division,
    IFNULL(store_dim.district, 'Total') AS district,
    IFNULL(time_dim.year, 'Total') AS year,
    IFNULL(time_dim.month, 'Total') AS month,
    SUM(fact_table.unit_price) AS total_sale_price
FROM 
    fact_table
    JOIN store_dim ON fact_table.store_key = store_dim.store_key
    JOIN time_dim ON fact_table.time_key = time_dim.time_key
WHERE
    store_dim.district = 'SYLHET'
    
GROUP BY
    store_dim.division,
    store_dim.district,
    time_dim.year,
    time_dim.month;

-- DICE

SELECT 
    IFNULL(store_dim.division, 'Total') AS division,
    IFNULL(store_dim.district, 'Total') AS district,
    IFNULL(time_dim.year, 'Total') AS year,
    IFNULL(time_dim.month, 'Total') AS month,
    SUM(fact_table.unit_price) AS total_sale_price
FROM 
    fact_table
    JOIN store_dim ON fact_table.store_key = store_dim.store_key
    JOIN time_dim ON fact_table.time_key = time_dim.time_key
WHERE
    (store_dim.division = 'DHAKA' OR store_dim.division IS NULL)
    AND (store_dim.district = 'MYMENSINGH' OR store_dim.district IS NULL)
    AND (time_dim.year = 2020 OR time_dim.year IS NULL)
    -- AND (time_dim.month = 01 OR time_dim.month IS NULL)
GROUP BY
    store_dim.division,
    store_dim.district,
    time_dim.year,
    time_dim.month;
    
  -- Q2
  /*
   Find the customer/bank/transaction(cash/online) wise total_sale_price joining fact table and respective dimension table
  */
  
  SELECT
    customer_dim.name as customer,
    trans_dim.trans_type as transaction,
    trans_dim.bank_name as bank,  
    SUM(fact_table.unit_price) AS total_sale_price
FROM
    fact_table
    JOIN customer_dim ON fact_table.coustomer_key = customer_dim.coustomer_key
    JOIN trans_dim ON fact_table.payment_key = trans_dim.payment_key
GROUP BY
    customer_dim.name,
    trans_dim.trans_type,
    trans_dim.bank_name;
    
-- Roll UP 

SELECT
    customer_dim.name as customer,
    trans_dim.trans_type as transaction,
    trans_dim.bank_name as bank,  
    SUM(fact_table.unit_price) AS total_sale_price
FROM
    fact_table
    JOIN customer_dim ON fact_table.coustomer_key = customer_dim.coustomer_key
    JOIN trans_dim ON fact_table.payment_key = trans_dim.payment_key
GROUP BY
    customer_dim.name,
    trans_dim.trans_type,
    trans_dim.bank_name
WITH ROLLUP;    

-- Q3
/*
Total sales in Barisal for item 'Pepsi - 12 oz cans'
*/

SELECT
    SUM(fact_table.total_price) AS total_sale_price
FROM
    fact_table
    JOIN store_dim ON fact_table.store_key = store_dim.store_key
    JOIN item_dim ON fact_table.item_key = item_dim.item_key
WHERE
    store_dim.district = 'Barisal'
    AND item_dim.item_name = 'Pepsi - 12 oz cans';
 
 
-- Q4 
/*
 Total sales in 2015 for supplier 'BIGSO AB'
*/    
SELECT
    SUM(fact_table.total_price) AS total_sale_price
FROM
    fact_table
    JOIN time_dim ON fact_table.time_key = time_dim.time_key
    JOIN item_dim ON fact_table.item_key = item_dim.item_key
WHERE
    time_dim.year = 2015
    AND item_dim.supplier = 'BIGSO AB';


-- Q5
/*
Total sales of Dhaka in 2015
*/
SELECT
    SUM(fact_table.total_price) AS total_sale_price
FROM
    fact_table
    JOIN store_dim ON fact_table.store_key = store_dim.store_key
    JOIN time_dim ON fact_table.time_key = time_dim.time_key
WHERE
    store_dim.division = 'DHAKA'
    AND time_dim.year = 2015;
    
-- Q6
/*
For each store(item supplier), what are the top three products offered that are most often purchased?

    S1-> item1 -> quantity_sales

    S1-> item2 -> quantity_sales

    S1-> item3 -> quantity_sales
*/    
SELECT
	store_dim.store_key AS store,
    item_dim.item_name AS item,
    
    SUM(fact_table.total_price) AS total_quantity_sales
FROM
    fact_table
    JOIN item_dim ON fact_table.item_key = item_dim.item_key
     JOIN store_dim ON fact_table.store_key = store_dim.store_key
GROUP BY
    item_dim.item_name
    
ORDER BY
    total_quantity_sales DESC
LIMIT 3;

-- Q7
/*
 What products have been sold through card or mobile since X days?

    input: X = 5 days

    output: [item1, item2, item3, ...........]
*/
SELECT DISTINCT
    item_dim.item_name
FROM
    fact_table
    JOIN trans_dim ON fact_table.payment_key = trans_dim.payment_key
    JOIN item_dim ON fact_table.item_key = item_dim.item_key
    JOIN time_dim ON fact_table.time_key = time_dim.time_key
WHERE
    (trans_dim.trans_type = 'card' or trans_dim.trans_type = 'mobile')
    or DATEDIFF(CURDATE(), time_dim.day) <= 9
group by 
item_dim.item_name
with rollup;

-- Q8
/*
What season(quarter) is the worst for each product item? As example,

       item1-> q1

       item2-> q2
*/
SELECT
    item_dim.item_name AS item,
    time_dim.quarter AS worst_season
FROM
    fact_table
    JOIN item_dim ON fact_table.item_key = item_dim.item_key
    JOIN time_dim ON fact_table.time_key = time_dim.time_key
GROUP BY
    item_dim.item_name,
    time_dim.quarter
HAVING
    SUM(fact_table.total_price) = (
        SELECT
            MIN(total_price_sum)
        FROM
            (SELECT
                item_dim.item_name,
                time_dim.quarter,
                SUM(fact_table.total_price) AS total_price_sum
            FROM
                fact_table
                JOIN item_dim ON fact_table.item_key = item_dim.item_key
                JOIN time_dim ON fact_table.time_key = time_dim.time_key
            GROUP BY
                item_dim.item_name,
                time_dim.quarter) AS subquery
        WHERE
            subquery.item_name = item_dim.item_name
    );
    
-- Q9
/*
 Break down the total sales of items geographically (division-wise).

     item1-> division1->total_sales

     item1-> division2->total_sales
*/
SELECT
    item_dim.item_name AS item,
    store_dim.division AS division,
    SUM(fact_table.quantity) AS total_sales
FROM
    fact_table
    JOIN item_dim ON fact_table.item_key = item_dim.item_key
    JOIN store_dim ON fact_table.store_key = store_dim.store_key
GROUP BY
    item_dim.item_name,
    store_dim.division;
    
-- Q10
/*
What are the average sales of products sales per store monthly?

     S1->M1-> avg_sales

	 s1-> M2 -> avg_sales
*/ 

SELECT
    store_dim.store_key AS store,
    time_dim.month AS month,
    AVG(fact_table.quantity) AS avg_sales
FROM
    fact_table
    JOIN item_dim ON fact_table.item_key = item_dim.item_key
    JOIN store_dim ON fact_table.store_key = store_dim.store_key
    JOIN time_dim ON fact_table.time_key = time_dim.time_key
GROUP BY
    store_dim.store_key,
    time_dim.month;
   
    

     

    




    

    