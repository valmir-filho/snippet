-- Switch the current session to the pluggable database "XEPDB1". --
ALTER SESSION SET CONTAINER = XEPDB1;

/*
  Drop the user "HR" and all associated objects recursively.
  This is useful for cleaning up before re-creating a user setup.
*/
DROP USER HR CASCADE;

/*
  Create a new user named "HR" with the specified password "hr".
  Set the default tablespace to "users" and temporary tablespace to "TEMP".
  Assign unlimited quota on the "users" tablespace and no quota on "system" tablespace.
  This setup is common for development environments where the user needs flexibility.
*/
CREATE USER HR 
IDENTIFIED BY hr
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE TEMP
QUOTA unlimited on users
QUOTA 0 on system;

-- Grant basic connection and resource management roles to "HR". --
GRANT CONNECT, RESOURCE TO HR;

-- Grant permissions to create and manage sessions, views, tables, sequences, procedures, and triggers. --
GRANT CREATE SESSION, CREATE VIEW, CREATE TABLE, ALTER SESSION, CREATE SEQUENCE, CREATE PROCEDURE, CREATE TRIGGER TO HR;

-- Additionally grant permissions to create synonyms, database links, and unlimited usage of tablespaces. --
GRANT CREATE SYNONYM, CREATE DATABASE LINK, UNLIMITED TABLESPACE TO HR;
