/*
The SQL command you've provided selects specific columns
from the employees table, with some of the columns being
renamed using aliases for clarity or presentation in the results.
*/
SELECT
    first_name AS Name,
    last_name Sobrenome,
    salary AS Salário
FROM
    employees;
