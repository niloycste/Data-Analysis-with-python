

SELECT
    customer_dim.name AS customer,
    trans_dim.trans_type AS transaction,
    trans_dim.bank_name AS bank,
    SUM(fact_table.unit_price) AS total_sale_price
FROM
    fact_table
    JOIN customer_dim ON fact_table.coustomer_key = customer_dim.coustomer_key
    JOIN trans_dim ON fact_table.payment_key = trans_dim.payment_key
GROUP BY
    customer_dim.name,
    trans_dim.trans_type,
    trans_dim.bank_name
UNION
SELECT
    customer_dim.name AS customer,
    trans_dim.trans_type AS transaction,
    'Total' AS bank,
    SUM(fact_table.unit_price) AS total_sale_price
FROM
    fact_table
    JOIN customer_dim ON fact_table.coustomer_key = customer_dim.coustomer_key
    JOIN trans_dim ON fact_table.payment_key = trans_dim.payment_key
GROUP BY
    customer_dim.name,
    trans_dim.trans_type
UNION
SELECT
    customer_dim.name AS customer,
    'Total' AS transaction,
    'Total' AS bank,
    SUM(fact_table.unit_price) AS total_sale_price
FROM
    fact_table
    JOIN customer_dim ON fact_table.coustomer_key = customer_dim.coustomer_key
GROUP BY
    customer_dim.name
UNION
SELECT
    'Total' AS customer,
    'Total' AS transaction,
    'Total' AS bank,
    SUM(fact_table.unit_price) AS total_sale_price
FROM
    fact_table;
