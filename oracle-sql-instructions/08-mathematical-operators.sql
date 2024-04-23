/*
The SQL command is structured to select specific columns from
the employees table and also compute a new value based on one
of these columns.
*/
SELECT
    first_name,
    last_name,
    salary, salary * 1.15
FROM
    employees;
