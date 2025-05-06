


--You need to write a query that outputs "100-Steven King", meaning emp_id + first_name + last_name in that format using employees table.
SELECT CONCAT( EMPLOYEE_ID, '-', FIRST_NAME, ' ', LAST_NAME) AS full_info
FROM employees
WHERE EMPLOYEE_ID= 100;

--Update the portion of the phone_number in the employees table, within the phone number the substring '124' will be replaced by '999'
update Employees
set PHONE_NUMBER = REPLACE(phone_number, '124', '999')
--That displays the first name and the length of the first name for all employees whose name starts with the letters 'A', 'J' or 'M'. Give each column an appropriate label. Sort the results by the employees' first names.(Employees)
SELECT 
  first_name AS "First Name", 
  LEN(first_name) AS "Name Length"
FROM employees
WHERE first_name LIKE 'A%' 
   OR first_name LIKE 'J%' 
   OR first_name LIKE 'M%'
ORDER BY first_name;

--Write an SQL query to find the total salary for each manager ID.(Employees table)
select MANAGER_ID,
sum(Salary) as totalsalary
from Employees
group by manager_id
--Write a query to retrieve the year and the highest value from the columns Max1, Max2, and Max3 for each row in the TestMax table
SELECT 
  YEAR1, 
  GREATEST(Max1, Max2, Max3) AS highest_value
FROM TestMax;

--Find me odd numbered movies and description is not boring.(cinema)
select * from cinema
where id % 2=1
and description not like '%boring%';
--You have to sort data based on the Id but Id with 0 should always be the last row. Now the question is can you do that with a single order by column.(SingleOrder)
select * from SingleOrder
ORDER BY CASE WHEN id = 0 THEN 1 ELSE 0 END, id
--Write an SQL query to select the first non-null value from a set of columns. If the first column is null, move to the next, and so on. If all columns are null, return null.(person)
SELECT 
  COALESCE(id, ssn, passportid, itin) AS first_non_null
FROM person;
--Find the employees who have been with the company for more than 10 years, but less than 15 years. Display their Employee ID, First Name, Last Name, Hire Date, and the Years of Service (calculated as the number of years between the current date and the hire date, rounded to two decimal places).(Employees)
SELECT  
    EMPLOYEE_ID
    FIRST_NAME,
    LAST_NAME,
    HIRE_DATE,
    ROUND(DATEDIFF(DAY, HIRE_DATE, GETDATE()) / 365.25, 2) AS YearsOfService
FROM 
    Employees
WHERE 
    ROUND(DATEDIFF(DAY, HIRE_DATE, GETDATE()) / 365.25, 2) > 10
    AND ROUND(DATEDIFF(DAY, HIRE_DATE, GETDATE()) / 365.25, 2) < 15;

--Find the employees who have a salary greater than the average salary of their respective department.(Employees)
SELECT 
    EMPLOYEE_ID,
    DEPARTMENT_ID,
    SALARY
FROM 
    Employees e
WHERE 
    SALARY > (
        SELECT AVG(SALARY)
        FROM Employees
        WHERE DEPARTMENT_ID = e.DEPARTMENT_ID
    );






--Write an SQL query that separates the uppercase letters, lowercase letters, numbers, and other characters from the given string 'tf56sd#%OqH' into separate columns.
SELECT 
    STRING_AGG(CASE WHEN SUBSTRING('tf56sd#%OqH', number, 1) LIKE '[A-Z]' THEN SUBSTRING('tf56sd#%OqH', number, 1) END, '') AS UppercaseLetters,

    
    STRING_AGG(CASE WHEN SUBSTRING('tf56sd#%OqH', number, 1) LIKE '[a-z]' THEN SUBSTRING('tf56sd#%OqH', number, 1) END, '') AS LowercaseLetters,

    
    STRING_AGG(CASE WHEN SUBSTRING('tf56sd#%OqH', number, 1) LIKE '[0-9]' THEN SUBSTRING('tf56sd#%OqH', number, 1) END, '') AS Numbers,

   
    STRING_AGG(CASE WHEN SUBSTRING('tf56sd#%OqH', number, 1) NOT LIKE '[A-Za-z0-9]' THEN SUBSTRING('tf56sd#%OqH', number, 1) END, '') AS OtherCharacters

FROM 
    master.dbo.spt_values 
WHERE 
    type = 'P' AND number <= LEN('tf56sd#%OqH')

--Split column FullName into 3 part ( Firstname, Middlename, and Lastname).(Students Table)
SELECT 
  FullName,
  PARSENAME(REPLACE(FullName, ' ', '.'), 3) AS FirstName,
  PARSENAME(REPLACE(FullName, ' ', '.'), 2) AS MiddleName,
  PARSENAME(REPLACE(FullName, ' ', '.'), 1) AS LastName
FROM Students;

--For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas. (Orders Table)
SELECT *
FROM Orders
WHERE DeliveryState = 'TX'
  AND CustomerID IN (
    SELECT CustomerID
    FROM Orders
    WHERE DeliveryState = 'CA'
);

--Write an SQL query to transform a table where each product has a total quantity into a new table where each row represents a single unit of that product.For example, if A and B, it should be A,B and B,A.(Ungroup)
WITH ProductUnits AS (
    SELECT ProductName, Quantity      
    FROM Products
    CROSS APPLY (SELECT TOP (Quantity) 1 AS Unit FROM master.dbo.spt_values) AS Units
)
SELECT ProductName
FROM ProductUnits;

--Write an SQL statement that can group concatenate the following values.(DMLTable)
SELECT 
  STRING_AGG(String, ', ') AS concatenated_values
FROM DMLTable;

--Write an SQL query to determine the Employment Stage for each employee based on their HIRE_DATE. The stages are defined as follows:
--If the employee has worked for less than 1 year ? 'New Hire'
--If the employee has worked for 1 to 5 years ? 'Junior'
--If the employee has worked for 5 to 10 years ? 'Mid-Level'
--If the employee has worked for 10 to 20 years ? 'Senior'
--If the employee has worked for more than 20 years ? 'Veteran'(Employees)
SELECT
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    HIRE_DATE,
    CASE 
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) < 1 THEN 'New Hire'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 1 AND 5 THEN 'Junior'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 6 AND 10 THEN 'Mid-Level'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 11 AND 20 THEN 'Senior'
        ELSE 'Veteran'
    END AS EMPLOYMENT_STAGE
FROM 
    Employees;


--Find the employees who have a salary greater than the average salary of their respective department(Employees)
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    E.DEPARTMENT_ID,
    E.SALARY
FROM 
    Employees E
WHERE 
    E.SALARY > (
        SELECT 
            AVG(E2.SALARY)
        FROM 
            Employees E2
        WHERE 
            E2.DEPARTMENT_ID = E.DEPARTMENT_ID
    );


--Find all employees whose names (concatenated first and last) contain the letter "a" and whose salary is divisible by 5(Employees)
SELECT 
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    SALARY
FROM 
    Employees
WHERE 
    LOWER (concat(FIRST_NAME , LAST_NAME)) LIKE '%a%'  
    AND SALARY % 5 = 0;

--The total number of employees in each department and the percentage of those employees who have been with the company for more than 3 years(Employees)
SELECT 
    DEPARTMENT_ID,
    COUNT(*) AS TOTAL_EMPLOYEES,
    ROUND(
        100.0 * SUM(CASE 
                      WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 3 THEN 1 
                      ELSE 0 
                    END) / COUNT(*), 
        2
    ) AS PERCENT_OVER_3_YEARS
FROM 
    Employees
GROUP BY 
    DEPARTMENT_ID;

SELECT 
    JobDescription,
    (SELECT TOP 1 SpacemanID 
     FROM Personal p1 
     WHERE p1.JobDescription = p.JobDescription 
     ORDER BY MissionCount ASC) AS MOST_EXPERIENCED_ID,
     
    (SELECT TOP 1 SpacemanID
     FROM Personal p2 
     WHERE p2.JobDescription = p.JobDescription
     ORDER BY MissionCount DESC) AS LEAST_EXPERIENCED_ID
FROM 
    Personal p
GROUP BY 
    JobDescription;


--Write an SQL query that replaces each row with the sum of its value and the previous row's value. (Students table)
SELECT 
    StudentID,
   FullName,
    Grade,
    Grade + ISNULL(LAG(Grade) OVER (ORDER BY StudentID), 0) AS SUM_WITH_PREVIOUS
FROM 
    Students;

--Given the following hierarchical table, write an SQL statement that determines the level of depth each employee has from the president. (Employee table)
WITH OrgTree AS (
    SELECT  
        EmployeeID,
        ManagerID,
        0 AS JobTitle
    FROM 
        Employee
    WHERE 
        ManagerID IS NULL

    UNION ALL

    SELECT 
        e.EmployeeID,
        e.ManagerID,
        o.JobTitle + 1
    FROM 
        Employee e
    JOIN 
        OrgTree o ON e.ManagerID = o.EmployeeID
)
SELECT 
    EmployeeID,
    ManagerID,
    JobTitle
FROM 
    OrgTree
ORDER BY 
    JobTitle, EmployeeID;

--You are given the following table, which contains a VARCHAR column that contains mathematical equations. Sum the equations and provide the answers in the output.(Equations)
DECLARE @TotalSum DECIMAL(18, 2) = 0;

DECLARE @Equation VARCHAR(MAX);

DECLARE equation_cursor CURSOR FOR
    SELECT equation
    FROM Equations;

OPEN equation_cursor;

FETCH NEXT FROM equation_cursor INTO @Equation;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Evaluate the equation dynamically using sp_executesql
    EXEC sp_executesql N'SELECT @result = ' + @Equation, N'@result DECIMAL(18,2) OUTPUT', @result OUTPUT;
    
    -- Add the result to the total sum
    SET @TotalSum = @TotalSum + @result;
    
    FETCH NEXT FROM equation_cursor INTO @Equation;
END

CLOSE equation_cursor;
DEALLOCATE equation_cursor;
SELECT @TotalSum AS TotalSum;

--Given the following dataset, find the students that share the same birthday.(Student Table)
SELECT 
    S1.StudentName,
    S1.Birthday
FROM 
    Student S1
JOIN 
    Student S2
    ON S1.Birthday = S2.Birthday
    AND S1.StudentName <> S2.StudentName
ORDER BY 
    S1.Birthday, S1.StudentName;

--You have a table with two players (Player A and Player B) and their scores. If a pair of players have multiple entries, aggregate their scores into a single row for each unique pair of players. Write an SQL query to calculate the total score for each unique player pair(PlayerScores)
SELECT 
    LEAST(PlayerA, PlayerB) AS Player1, 
    GREATEST(PlayerA, PlayerB) AS Player2,
    SUM(Score) AS TotalScore
FROM 
    PlayerScores
GROUP BY 
    LEAST(PlayerA, PlayerB), 
    GREATEST(PlayerA, PlayerB)
ORDER BY 
    Player1, Player2;
