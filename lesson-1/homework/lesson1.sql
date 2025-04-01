1. Define the following terms: data, database, relational database, and table.
  Data is quantities, numbers, information, facts, observations, measurement, graphs.
Database is electronic storage for data.
Relational data is database relationships in the form of tables. 
Tables are rows and columns within a relational database 
2. List five key features of SQL Server.
  Security, advanced data management, integration, high availability, performance optimization.
3. What are the different authentication modes available when connecting to SQL Server? (Give at least 2)
  Windows authentication mode and SQL server authentication mode
4. Create a new database in SSMS named SchoolDB
  create database SchooIDB
5.Write and execute a query to create a table called Students with columns: StudentID (INT, PRIMARY KEY), Name (VARCHAR(50)), Age (INT).
  CREATE TABLE student(
id int,
name char(50),
age int
);
6. Describe the differences between SQL Server, SSMS, and SQL.
  SQL- structured query language is a programming language for storing and processing information.
SQL server is a relational database management system developed by Microsoft. It is used to store, retrieve, and manage data for enterprise level applications.
SSMS a graphical user interface tool for managing SQL server
7. Research and explain the different SQL commands: DQL, DML, DDL, DCL, TCL with examples.
  DQL  is used to retrieve data , command is SELECT, example is  SELECT * FROM Employees;
DML is used to  Modify data, commands are  INSERT, UPDATE, DELETE, example is  UPDATE Employees SET salary = 55000 WHERE name = 'Alice';
DDL is used to  Define database structure, commands are  CREATE, ALTER, DROP, TRUNCATE, example is  CREATE TABLE Employees (...);
DCL  is used to Manage permissions  GRANT, REVOKE , example is  GRANT SELECT ON Employees TO user1;
TCL  is used Manage transactions  COMMIT, ROLLBACK, SAVEPOINT, example is  ROLLBACK TO BeforeUpdate;
8. Write a query to insert three records into the Students table.
  SELECT * FROM student;
ALTER TABLE student ADD course CHAR(15); 
DROP TABLE student;
TRUNCATE TABLE student;
INSERT INTO student (id, name, age, course) VALUES 
(3,'Vali',25,'Math'),
(4,'Vali',25,'Physics'),
(5,'Vali',25,'Philosophy'),
(6,'Vali',25,'eng'),
(7,'Vali',25,'ru');
