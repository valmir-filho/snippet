/*
This SQL command select specific columns
from the employees table and also compute
an increment to the salary. 
*/

SELECT
    first_name,
    last_name,
    salary,
    salary + 100 * 1.15
FROM
    employees;
