-- Change the current session's context to the pluggable database XEPDB1 --
ALTER SESSION SET CONTAINER = XEPDB1;

-- Drop the user HR along with all of its associated objects recursively --
DROP USER HR CASCADE;

-- Create a new user named HR with the password 'hr'
CREATE USER HR IDENTIFIED BY hr;

-- Set the default tablespace for the user HR to 'users'
DEFAULT TABLESPACE users;

-- Set the temporary tablespace for the user HR to 'TEMP'
TEMPORARY TABLESPACE TEMP;

-- Grant unlimited quota on the 'users' tablespace to the user HR
QUOTA unlimite on users;

-- Set the quota on the 'system' tablespace to 0 for the user HR
QUOTA 0 on system;

-- Grant the CONNECT and RESOURCE roles to the user HR
GRANT CONNECT, RESOURCE TO HR;

-- Grant permissions to create sessions, views, tables, modify sessions, sequences, procedures, and triggers to the user HR
GRANT CREATE SESSION, CREATE VIEW, CREATE TABLE, ALTER SESSION, CREATE SEQUENCE, CREATE PROCEDURE, CREATE TRIGGER TO HR;

-- Grant permissions to create synonyms, database links, and use unlimited tablespace to the user HR
GRANT CREATE SYNONYM, CREATE DATABASE LINK, UNLIMITED TABLESPACE TO HR;
