-- Drop the table "job_history" and all associated constraints. --
DROP TABLE job_history CASCADE CONSTRAINTS;

-- Drop the table "departments" and all associated constraints. --
DROP TABLE departments CASCADE CONSTRAINTS;

-- Drop the table "employees" and all associated constraints. --
DROP TABLE employees CASCADE CONSTRAINTS;

-- Drop the table "jobs" and all associated constraints. --
DROP TABLE jobs CASCADE CONSTRAINTS;

-- Drop the table "locations" and all associated constraints. --
DROP TABLE locations CASCADE CONSTRAINTS;

-- Drop the table "countries" and all associated constraints. --
DROP TABLE countries CASCADE CONSTRAINTS;

-- Drop the table "regions" and all associated constraints. --
DROP TABLE regions CASCADE CONSTRAINTS;

-- Drop the sequence "locations_seq". --
DROP SEQUENCE locations_seq;

-- Drop the sequence "departments_seq". --
DROP SEQUENCE departments_seq;

-- Drop the sequence "employees_seq". --
DROP SEQUENCE employees_seq;

-- Set the session language to American English. --
ALTER SESSION SET NLS_LANGUAGE="American";

-- Set the session territory to America. --
ALTER SESSION SET NLS_TERRITORY="America";

-- Create the "regions" table with a primary key constraint. --
CREATE TABLE regions (
  region_id NUMBER CONSTRAINT regions_id_nn NOT NULL,
  region_name VARCHAR2(25)
);

-- Create a unique index for "region_id" in the "regions" table. --
CREATE UNIQUE INDEX reg_id_pk ON regions (region_id);

-- Add a primary key constraint to the "regions" table. --
ALTER TABLE regions ADD CONSTRAINT reg_id_pk PRIMARY KEY (region_id);

-- Create the "countries" table with a primary key and a foreign key constraint. --
CREATE TABLE countries (
  country_id CHAR(2) CONSTRAINT country_id_nn NOT NULL,
  country_name VARCHAR2(40),
  region_id NUMBER,
  CONSTRAINT country_c_id_pk PRIMARY KEY (country_id)
) ORGANIZATION INDEX;

-- Add a foreign key constraint to the "countries" table that references "regions". --
ALTER TABLE countries ADD CONSTRAINT countr_reg_fk FOREIGN KEY (region_id) REFERENCES regions(region_id);

-- Create the "locations" table with several constraints. --
CREATE TABLE locations (
  location_id NUMBER(4),
  street_address VARCHAR2(40),
  postal_code VARCHAR2(12),
  city VARCHAR2(30) CONSTRAINT loc_city_nn NOT NULL,
  state_province VARCHAR2(25),
  country_id CHAR(2)
);

-- Create a unique index for "location_id" in the "locations" table. --
CREATE UNIQUE INDEX loc_id_pk ON locations (location_id);

-- Add primary key and foreign key constraints to the "locations" table. --
ALTER TABLE locations ADD (
    CONSTRAINT loc_id_pk PRIMARY KEY (location_id),
    CONSTRAINT loc_c_id_fk FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

-- Create a sequence "locations_seq" for auto-incrementing location IDs. --
CREATE SEQUENCE locations_seq START WITH 3300 INCREMENT BY 100 MAXVALUE 9900 NOCACHE NOCYCLE;

-- Create the "departments" table with constraints. --
CREATE TABLE departments (
  department_id NUMBER(4),
  department_name VARCHAR2(30) CONSTRAINT dept_name_nn NOT NULL,
  manager_id NUMBER(6),
  location_id NUMBER(4)
);

-- Create a unique index for "department_id" in the "departments" table. --
CREATE UNIQUE INDEX dept_id_pk ON departments (department_id);

-- Add primary key and foreign key constraints to the "departments" table. --
ALTER TABLE departments ADD (
  CONSTRAINT dept_id_pk PRIMARY KEY (department_id),
  CONSTRAINT dept_loc_fk FOREIGN KEY (location_id) REFERENCES locations (location_id)
);

-- Create a sequence "departments_seq" for auto-incrementing department IDs. --
CREATE SEQUENCE departments_seq START WITH 280 INCREMENT BY 10 MAXVALUE 9990 NOCACHE NOCYCLE;

-- Create the "jobs" table with constraints. --
CREATE TABLE jobs (
  job_id VARCHAR2(10),
  job_title VARCHAR2(35) CONSTRAINT job_title_nn NOT NULL,
  min_salary NUMBER(6),
  max_salary NUMBER(6)
);

-- Create a unique index for "job_id" in the "jobs" table. --
CREATE UNIQUE INDEX job_id_pk ON jobs (job_id);

-- Add a primary key constraint to the "jobs" table. --
ALTER TABLE jobs ADD CONSTRAINT job_id_pk PRIMARY KEY(job_id);

-- Create the "employees" table with multiple constraints. --
CREATE TABLE employees (
  employee_id NUMBER(6),
  first_name VARCHAR2(20),
  last_name VARCHAR2(25) CONSTRAINT emp_last_name_nn NOT NULL,
  email VARCHAR2(25) CONSTRAINT emp_email_nn NOT NULL,
  phone_number VARCHAR2(20),
  hire_date DATE CONSTRAINT emp_hire_date_nn NOT NULL,
  job_id VARCHAR2(10) CONSTRAINT emp_job_nn NOT NULL,
  salary NUMBER(8,2),
  commission_pct NUMBER(2,2),
  manager_id NUMBER(6),
  department_id NUMBER(4),
  CONSTRAINT emp_salary_min CHECK (salary > 0),
  CONSTRAINT emp_email_uk UNIQUE (email)
);

-- Create a unique index for "employee_id" in the "employees" table. --
CREATE UNIQUE INDEX emp_emp_id_pk ON employees (employee_id);

-- Add primary key, foreign key, and additional constraints to the "employees" table. --
ALTER TABLE employees ADD (
  CONSTRAINT emp_emp_id_pk PRIMARY KEY (employee_id),
  CONSTRAINT emp_dept_fk FOREIGN KEY (department_id) REFERENCES departments,
  CONSTRAINT emp_job_fk FOREIGN KEY (job_id) REFERENCES jobs (job_id),
  CONSTRAINT emp_manager_fk FOREIGN KEY (manager_id) REFERENCES employees (employee_id)
);

-- Add a foreign key constraint to the "departments" table for the manager_id that references "employees". --
ALTER TABLE departments ADD (
  CONSTRAINT dept_mgr_fk FOREIGN KEY (manager_id) REFERENCES employees (employee_id)
);

-- Create a sequence "employees_seq" for auto-incrementing employee IDs. --
CREATE SEQUENCE employees_seq START WITH 207 INCREMENT BY 1 NOCACHE NOCYCLE;

-- Create the "job_history" table with constraints. --
CREATE TABLE job_history (
  employee_id NUMBER(6) CONSTRAINT jhist_employee_nn NOT NULL,
  start_date DATE CONSTRAINT jhist_start_date_nn NOT NULL,
  end_date DATE CONSTRAINT jhist_end_date_nn NOT NULL,
  job_id VARCHAR2(10) CONSTRAINT jhist_job_nn NOT NULL,
  department_id NUMBER(4),
  CONSTRAINT jhist_date_interval CHECK (end_date > start_date)
);

-- Create a unique index for "employee_id" and "start_date" in the "job_history" table. --
CREATE UNIQUE INDEX jhist_emp_id_st_date_pk ON job_history (employee_id, start_date);

-- Add primary key, foreign key, and additional constraints to the "job_history" table. --
ALTER TABLE job_history ADD (
  CONSTRAINT jhist_emp_id_st_date_pk PRIMARY KEY (employee_id, start_date),
  CONSTRAINT jhist_job_fk FOREIGN KEY (job_id) REFERENCES jobs,
  CONSTRAINT jhist_emp_fk FOREIGN KEY (employee_id) REFERENCES employees,
  CONSTRAINT jhist_dept_fk FOREIGN KEY (department_id) REFERENCES departments
);

-- Create a read-only view "emp_details_view" for detailed employee information. --
CREATE OR REPLACE VIEW emp_details_view
  (employee_id,
   job_id,
   manager_id,
   department_id,
   location_id,
   country_id,
   first_name,
   last_name,
   salary,
   commission_pct,
   department_name,
   job_title,
   city,
   state_province,
   country_name,
   region_name)
AS
SELECT
  e.employee_id,
  e.job_id,
  e.manager_id,
  e.department_id,
  d.location_id,
  l.country_id,
  e.first_name,
  e.last_name,
  e.salary,
  e.commission_pct,
  d.department_name,
  j.job_title,
  l.city,
  l.state_province,
  c.country_name,
  r.region_name
FROM
  employees e
  INNER JOIN departments d ON e.department_id = d.department_id
  INNER JOIN jobs j ON j.job_id = e.job_id
  INNER JOIN locations l ON d.location_id = l.location_id
  INNER JOIN countries c ON l.country_id = c.country_id
  INNER JOIN regions r ON c.region_id = r.region_id
WITH READ ONLY;

COMMIT;
