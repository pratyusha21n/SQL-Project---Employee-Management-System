-- create new database for the tables
create database EMS;

-- check database createdor not
show databases;

-- use database
use ems;

-- create tables in dtabase for the storage of data
-- Table 1: Job Department
CREATE TABLE JobDepartment (
    Job_ID INT PRIMARY KEY,
    jobdept VARCHAR(50),
    name VARCHAR(100),
    description TEXT,
    salaryrange VARCHAR(50)
);

-- describe table
describe JobDepartment;

-- Table 2: Salary/Bonus
CREATE TABLE SalaryBonus (
    salary_ID INT PRIMARY KEY,
    Job_ID INT,
    amount DECIMAL(10,2),
    annual DECIMAL(10,2),
    bonus DECIMAL(10,2),
    CONSTRAINT fk_salary_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(Job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
-- descibe tables
describe SalaryBonus;

-- Table 3: Employee
CREATE TABLE Employee (
    emp_ID INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    contact_add VARCHAR(100),
    emp_email VARCHAR(100) UNIQUE,
    emp_pass VARCHAR(50),
    Job_ID INT,
    CONSTRAINT fk_employee_job FOREIGN KEY (Job_ID)
          REFERENCES JobDepartment(Job_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Table 4: Qualification
CREATE TABLE Qualification (
    QualID INT PRIMARY KEY,
    Emp_ID INT,
    Position VARCHAR(50),
    Requirements VARCHAR(255),
    Date_In DATE,
    CONSTRAINT fk_qualification_emp FOREIGN KEY (Emp_ID)
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table 5: Leaves
CREATE TABLE Leaves (
    leave_ID INT PRIMARY KEY,
    emp_ID INT,
    date DATE,
    reason TEXT,
    CONSTRAINT fk_leave_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
-- describe
describe leaves;

-- Table 6: Payroll
CREATE TABLE Payroll (
    payroll_ID INT PRIMARY KEY,
    emp_ID INT,
    job_ID INT,
    salary_ID INT,
    leave_ID INT,
    date DATE,
    report TEXT,
    total_amount DECIMAL(10,2),
    CONSTRAINT fk_payroll_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_salary FOREIGN KEY (salary_ID) REFERENCES SalaryBonus(salary_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_leave FOREIGN KEY (leave_ID) REFERENCES Leaves(leave_ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

/*1.
How many unique employees are currently in the system?
Which departments have the highest number of employees?
What is the average salary per department?
Who are the top 5 highest-paid employees?
What is the total salary expenditure across the company?
*/

use ems;
-- How many unique employees are currently in the system?
select count(DISTINCT emp_ID) as unique_employees from employee
where job_Id IS NOT NULL;


-- Which departments have the highest number of employees?

with highest_employees as(
  select j.jobdept as dept_name , count(e.emp_ID) as count_per_dep , RANK() OVER(order by count(e.emp_ID) desc) as dept_rank
  from employee as e
  join jobdepartment as j 
  on e.job_id = j.job_id
  group by j.jobdept
  
)
select * from highest_employees where dept_rank =1;

-- What is the average salary per department?

SELECT jd.jobdept, AVG(s.annual) AS avg_salary
FROM salarybonus s
JOIN jobdepartment jd ON s.job_id = jd.job_id
GROUP BY jd.jobdept
ORDER BY avg_salary DESC;
  
-- Who are the top 5 highest-paid employees?
-- can also solve this by order by + limit
WITH ranked_employees AS (
    SELECT 
        e.emp_id,
        e.firstname,
        s.annual,
        RANK() OVER (ORDER BY s.annual DESC) AS salary_rank
    FROM employee e
   JOIN salarybonus s 
   ON e.job_id = s.job_id

)
SELECT *
FROM ranked_employees
WHERE salary_rank <= 5;
  
-- What is the total salary expenditure across the company?
SELECT 
    SUM(COALESCE(annual,0) + (COALESCE(bonus,0))) AS total_expenditure
FROM salarybonus;


/* 2. JOB ROLE AND DEPARTMENT ANALYSIS
How many different job roles exist in each department?
What is the average salary range per department?
Which job roles offer the highest salary?
Which departments have the highest total salary allocation? */


-- How many different job roles exist in each department?
-- when groupby didnt work go through windows or cte+joins

SELECT DISTINCT jobdept, j.name AS roles_dept,
       COUNT(name) OVER(PARTITION BY jobdept) AS number_roles
FROM jobdepartment j;

-- What is the average salary range per department?

SELECT 
  jobdept,
  AVG((
    CAST(REPLACE(SUBSTRING_INDEX(salaryrange, '-', 1), '$', '') AS UNSIGNED) +
    CAST(REPLACE(SUBSTRING_INDEX(salaryrange, '-', -1), '$', '') AS UNSIGNED)
  ) / 2) AS avg_salaryrange
FROM jobdepartment
GROUP BY jobdept;

-- Which job roles offer the highest salary?
-- other way rather than the subquerys but here subquery is most suitable.
with highest_salary as (
select max(s.annual) as high_sal from salarybonus as s
)
select j.Job_ID,j.jobdept,j.name,h.high_sal
from jobdepartment as j
join salarybonus as s on s.job_id = j.Job_ID 
join highest_salary as h on s.annual = h.high_sal;

-- Which departments have the highest total salary allocation? */
-- if there any other jobs with same total cant be missed.

select jobdept , total_salary from
(select j.jobdept , sum(s.annual) as total_salary , rank() over(order by sum(s.annual) DESC) as rnk
from jobdepartment as j
join salarybonus as s
on s.Job_ID = j.Job_ID
group by j.jobdept) as sal_details
where rnk =1;


-- subquery
SELECT jobdept, total_salary
FROM (
    SELECT j.jobdept,
           SUM(s.annual) AS total_salary
    FROM jobdepartment j
    JOIN salarybonus s ON s.Job_ID = j.Job_ID
    GROUP BY j.jobdept
) AS dept_totals
WHERE total_salary = (
    SELECT MAX(SUM(s.annual))
    FROM jobdepartment j
    JOIN salarybonus s ON s.Job_ID = j.Job_ID
    GROUP BY j.jobdept
);

/*
3. QUALIFICATION AND SKILLS ANALYSIS
How many employees have at least one qualification listed?
Which positions require the most qualifications?
Which employees have the highest number of qualifications? */

-- 1st , How many employees have at least one qualification listed?

SELECT COUNT(DISTINCT E.emp_ID) AS EmployeesWithQualification
FROM Employee E
INNER JOIN Qualification Q
ON E.emp_ID = Q.Emp_ID;
  
-- 2nd ,Which positions require the most qualifications?
SELECT Position, COUNT(*) AS num_req
FROM Qualification
GROUP BY Position
ORDER BY num_req DESC;

-- 3rd Which employees have the highest number of qualifications?
select Emp_ID, count(*) as num_req
from qualification group by Emp_ID order by num_req desc;

-- other way
SELECT Emp_ID, COUNT(*) AS num_req
FROM Qualification
GROUP BY Emp_ID
HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM Qualification
        GROUP BY Emp_ID
    ) AS sub
);


/*4. LEAVE AND ABSENCE PATTERNS
Which year had the most employees taking leaves?
What is the average number of leave days taken by its employees per department?
Which employees have taken the most leaves?
What is the total number of leave days taken company-wide?
How do leave days correlate with payroll amounts?*/

-- 1st ,Which year had the most employees taking leaves?
-- each year from date , count of employess + leaves

with cte1 as (select * ,year(date) as years from leaves)
select count(emp_id) as no_of_employee , years from cte1 
group by years ORDER BY no_of_employee DESC
LIMIT 1;

-- 2nd ,What is the average number of leave days taken by its employees per department?
-- each dept +  average number of leave days(calculate it) -->( based on)taken by its employees per dept

WITH emp_leave_count AS (
    SELECT e.emp_ID, j.jobdept,
           COUNT(l.leave_ID) AS total_leaves
    FROM Employee e
    JOIN JobDepartment j ON e.Job_ID = j.Job_ID
    LEFT JOIN Leaves l ON e.emp_ID = l.emp_ID
    GROUP BY e.emp_ID, j.jobdept
)
SELECT 
    jobdept,
    AVG(total_leaves) AS avg_leave_days FROM emp_leave_count GROUP BY jobdept;
    
-- 3rd ,Which employees have taken the most leaves?

WITH leave_count AS (
    SELECT emp_ID, COUNT(*) AS total_leaves
    FROM Leaves GROUP BY emp_ID
),
max_leave AS ( SELECT MAX(total_leaves) AS highest_leave FROM leave_count )

SELECT e.emp_ID, e.firstname,
    e.lastname, lc.total_leaves
FROM leave_count lc
JOIN max_leave ml ON lc.total_leaves = ml.highest_leave
JOIN Employee e ON e.emp_ID = lc.emp_ID;

-- 4th
-- total number of leave days +  taken company-wide

with  details as(select * ,datediff(l.date,l.date)+1 as no_of_leaves from leaves l)
      select sum(no_of_leaves) as total_leaves_in_company from details;

-- 5th  How do leave days correlate with payroll amounts?
/* To analyze the correlation between leave days and payroll amounts, 
    we calculate total leaves and total payroll per employee and compare them.*/
    
WITH leave_count AS (
    SELECT emp_ID, COUNT(*) AS total_leaves
    FROM Leaves GROUP BY emp_ID
),
payroll_total AS (
    SELECT 
        emp_ID, SUM(total_amount) AS total_payroll
    FROM Payroll GROUP BY emp_ID
)
SELECT e.emp_ID, e.firstname, e.lastname,
    COALESCE(lc.total_leaves, 0) AS total_leaves, pt.total_payroll
FROM Employee e
LEFT JOIN leave_count lc 
    ON e.emp_ID = lc.emp_ID
LEFT JOIN payroll_total pt 
    ON e.emp_ID = pt.emp_ID;
    
    
/*5. PAYROLL AND COMPENSATION ANALYSIS
What is the total monthly payroll processed?
What is the average bonus given per department?
Which department receives the highest total bonuses?
What is the average value of total_amount after considering leave deductions? */

-- 1st ,What is the total monthly payroll processed?
with month_data as (select *, month(`date`) as monthly  from payroll)
select monthly,sum(total_amount)as total_month_pay from month_data group by monthly ORDER BY monthly;

-- 2nd ,What is the average bonus given per department?
-- avg bonus + per dept
with sal_data as (select * from jobdepartment j inner join salarybonus s using(job_id))
select jobdept , avg(bonus) as avg_bonus from sal_data group by jobdept order by avg_bonus desc;

-- 3rd Which department receives the highest total bonuses?
-- high + per dept+toatal bonus

with sal_data as (select  j.jobdept,sum(s.bonus) as total_bonus ,
                   rank() over(order by sum(s.bonus) desc) as rnk
                   from jobdepartment j inner join salarybonus s using(job_id)
                   group by j.jobdept)
select * from sal_data where rnk =1;


/* details needed
1. leave details
2. payroll details 
then we controll the details accordingly */

-- 4th What is the average value of total_amount after considering leave deductions?
WITH leave_days AS (
    SELECT 
        emp_id, SUM(DATEDIFF(date, date) + 1) AS total_leave_days
    FROM leaves
    GROUP BY emp_id
),
payroll_data AS (
    SELECT 
        p.emp_id, p.total_amount,
        IFNULL(ld.total_leave_days, 0) AS leave_days,
        (IFNULL(ld.total_leave_days, 0) * 500) AS leave_deduction,
        (p.total_amount - (IFNULL(ld.total_leave_days, 0) * 500)) AS adjusted_amount
    FROM payroll p
    LEFT JOIN leave_days ld ON p.emp_id = ld.emp_id
)
SELECT  AVG(adjusted_amount) AS avg_adjusted_pay FROM payroll_data;
