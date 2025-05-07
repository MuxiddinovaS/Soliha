--Task: Retrieve employees who earn the minimum salary in the company. Tables: employees (columns: id, name, salary)
select * from employees
where salary= (select min(salary) from employees)

--Task: Retrieve products priced above the average price. Tables: products (columns: id, product_name, price)
select * from products
where price > (select avg(price) from products)

--Find Employees in Sales Department Task: Retrieve employees who work in the "Sales" department. Tables: employees (columns: id, name, department_id), departments (columns: id, department_name)
select * from employees
where department_id = (select id from departments where department_name = 'Sales') 

SELECT *
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM orders
);

--Retrieve products with the highest price in each category. Tables: products (columns: id, product_name, price, category_id)
select * from products as p
where price = (select max(price) from products where category_id = p.category_id)

--Retrieve employees working in the department with the highest average salary. Tables: employees (columns: id, name, salary, department_id), departments (columns: id, department_name)
SELECT e.id, e.name, e.salary, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.id
WHERE e.department_id = (
    SELECT TOP 1 department_id
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
);

--Task: Retrieve employees earning more than the average salary in their department. Tables: employees (columns: id, name, salary, department_id)
SELECT *
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);

--Task: Retrieve students who received the highest grade in each course. Tables: students (columns: student_id, name), grades (columns: student_id, course_id, grade)
SELECT s.student_id, s.name, g.course_id, g.grade
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.grade = (
    SELECT MAX(grade)
    FROM grades
    WHERE course_id = g.course_id
)
--Find Third-Highest Price per Category Task: Retrieve products with the third-highest price in each category. Tables: products (columns: id, product_name, price, category_id)
WITH RankedProducts AS (
    SELECT id, product_name, price, category_id,
           ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rn
    FROM products
)
SELECT id, product_name, price, category_id
FROM RankedProducts
WHERE rn = 3;

--Task: Retrieve employees with salaries above the company average but below the maximum in their department. Tables: employees (columns: id, name, salary, department_id)

SELECT e.*
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees
) 
AND e.salary < (
    SELECT MAX(salary)
    FROM employees
    WHERE department_id = e.department_id
);
