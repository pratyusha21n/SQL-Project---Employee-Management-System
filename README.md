# Employee Management System (EMS) – SQL Project

## Overview

The **Employee Management System (EMS)** is a SQL-based database project designed to manage and analyze employee-related information within an organization. The project demonstrates practical database design, relational modeling, SQL querying, and business-driven analysis using MySQL.

This project includes:

* Database creation and schema design
* Table relationships using Primary & Foreign Keys
* Data analysis queries for HR and payroll insights
* Employee, payroll, leave, and department management
* SQL result screenshots for query outputs

The project is built to simulate a real-world HR and payroll management environment while showcasing SQL skills required for Data Analyst and SQL Developer roles.

---

# Project Objectives

* Design a normalized relational database system
* Store and manage employee records efficiently
* Perform analytical SQL queries for business insights
* Practice JOINs, CTEs, Aggregate Functions, Subqueries, and Window Functions
* Build a portfolio-ready SQL project for recruiters and hiring managers

---

# Tech Stack

* **Database:** MySQL
* **Language:** SQL
* **Tools Used:** MySQL Workbench
* **Dataset Format:** CSV Files

---

# Database Schema

The project contains the following tables:

| Table Name      | Description                            |
| --------------- | -------------------------------------- |
| `Employee`      | Stores employee personal information   |
| `JobDepartment` | Stores department and job role details |
| `SalaryBonus`   | Stores salary and bonus information    |
| `Qualification` | Stores employee qualifications         |
| `Leaves`        | Stores employee leave records          |
| `Payroll`       | Stores payroll and salary transactions |

---

# Entity Relationship Highlights

* One department can have multiple employees
* One employee can have multiple leave records
* Payroll is linked with employees, departments, salary, and leaves
* Foreign key constraints ensure referential integrity

---

# Key SQL Concepts Used

This project demonstrates the following SQL concepts:

* Database Creation
* Table Creation
* Primary Keys
* Foreign Keys
* Constraints
* Joins
* Common Table Expressions (CTEs)
* Aggregate Functions
* Group By & Having
* Subqueries
* Window Functions
* Data Filtering
* Sorting & Ranking
* Business Analysis Queries

---

# Business Problems Solved

The project answers several business-related questions such as:

### Employee Analysis

* Total unique employees in the organization
* Departments with the highest employee count
* Employee distribution across departments

### Salary & Payroll Analysis

* Average salary by department
* Top 5 highest-paid employees
* Total salary expenditure across the company
* Payroll reporting and compensation tracking

### Leave Management Analysis

* Employees with the highest number of leaves
* Leave tracking and reporting

### Qualification & Department Analysis

* Employee qualification tracking
* Department-wise role analysis

---

# Folder Structure

```bash
sql_project/
│
├── DataSet/
│   ├── Employee.csv
│   ├── JobDepartment.csv
│   ├── Leaves.csv
│   ├── Payroll.csv
│   ├── Qualification.csv
│   └── Salary_Bonus.csv
│
├── SQL_Results/
│   ├── Query result screenshots
│   └── Analysis output images
│
└── Sql_project_final.sql
```

---
# Sample Analytical Queries

## Total Employees

```sql
SELECT COUNT(DISTINCT emp_ID) AS unique_employees
FROM employee
WHERE job_ID IS NOT NULL;
```

## Top 5 Highest Paid Employees

```sql
SELECT firstname, lastname, annual
FROM employee e
JOIN salarybonus s
ON e.job_ID = s.job_ID
ORDER BY annual DESC
LIMIT 5;
```

## Average Salary by Department

```sql
SELECT jd.jobdept,
       AVG(sb.annual) AS average_salary
FROM jobdepartment jd
JOIN salarybonus sb
ON jd.job_ID = sb.job_ID
GROUP BY jd.jobdept;
```

---

# Project Insights

* HR teams can track employee records and payroll efficiently
* Salary analysis helps identify compensation distribution
* Leave analysis supports workforce management decisions
* Department-level insights improve resource planning

---
# Learning Outcomes

Through this project, I gained hands-on experience in:

* Relational Database Design
* Writing Optimized SQL Queries
* Real-world HR & Payroll Analytics
* Data Cleaning and Data Importing
* Business-Oriented Data Analysis
* SQL Problem Solving

---

# Future Improvements

* Build an interactive Power BI dashboard using the database
* Integrate Python for automated reporting
* Add stored procedures and triggers
* Deploy the database on cloud platforms
* Create a web-based HR management application

---
# Project Description
Designed a relational database with 6 normalized tables for HR and payroll analytics
Wrote 20+ advanced SQL queries (joins, CTEs, window functions) for workforce and salary
insights
Examined total salary expenditure of INR52M+ and recognized department-wise
compensation trends
Delivered structured outputs and dashboards for stakeholder reporting

# Author
Nomula Pratyusha |
Data Analyst | SQL | Power BI | Python | Excel

<img width="1010" height="807" alt="ER-Diagram" src="https://github.com/user-attachments/assets/f5fa4d61-ec27-4f5d-bc29-2bd590f9273f" />

---
<img width="862" height="472" alt="EI-4" src="https://github.com/user-attachments/assets/4e79d087-86a8-489a-8b3b-b2c7fe559d37" />

---
<img width="700" height="503" alt="EI-3" src="https://github.com/user-attachments/assets/0ee7282a-c9aa-4b78-95d3-657dd73b09b2" />
<img width="1206" height="482" alt="EI-2-2" src="https://github.com/user-attachments/assets/184dcf7d-65a7-4c61-b132-7102144c68fd" />
<img width="1206" height="715" alt="EI-2-1" src="https://github.com/user-attachments/assets/bf8f43f3-8b44-4907-8726-80fd9d61337a" />
<img width="755" height="320" alt="EI-1" src="https://github.com/user-attachments/assets/49a29028-1c52-4022-9784-c504696510ce" />

<img width="813" height="462" alt="q-3" src="https://github.com/user-attachments/assets/0219146b-bbdc-4672-a958-fd7df9b0482d" />
<img width="662" height="432" alt="q-2" src="https://github.com/user-attachments/assets/4c011528-6213-4651-bc2b-de650245f37f" />
<img width="683" height="317" alt="q-1" src="https://github.com/user-attachments/assets/e6515c34-541a-4c26-a4cd-07ff1f15899a" />

<img width="1022" height="657" alt="p-4" src="https://github.com/user-attachments/assets/f67efdf2-2c6c-4a45-853e-67f4afa2c6fb" />
<img width="1101" height="442" alt="p-3" src="https://github.com/user-attachments/assets/463c637c-b7e1-4e70-a304-d74f9aa10396" />
<img width="1115" height="492" alt="p-2" src="https://github.com/user-attachments/assets/80b3c157-a6a0-481e-b55f-e7160cb48f4c" />
<img width="1072" height="238" alt="p-1" src="https://github.com/user-attachments/assets/7693cf83-98de-4db6-8bc0-dfdc7adf52a1" />

<img width="1165" height="727" alt="l-5" src="https://github.com/user-attachments/assets/0c578f17-f34d-4363-9544-eee8990781b5" />
<img width="1047" height="323" alt="l-4" src="https://github.com/user-attachments/assets/8d807fbd-ad9e-411b-b2a3-dc10d91faeb9" />
<img width="877" height="637" alt="l-3" src="https://github.com/user-attachments/assets/26697c2c-70b4-4e3a-b528-7e639e96cd59" />
<img width="1102" height="651" alt="l-2" src="https://github.com/user-attachments/assets/65286cbb-4eb4-4641-8e0a-7ae0e749a9c2" />
<img width="847" height="352" alt="l-1" src="https://github.com/user-attachments/assets/1ebf4f08-21b8-4cd6-adb7-98be43a6f003" />

<img width="1216" height="472" alt="j-4" src="https://github.com/user-attachments/assets/73259eeb-4c26-4809-833f-f7af6b9b9487" />
<img width="927" height="406" alt="j-3" src="https://github.com/user-attachments/assets/d5f6b48f-9bbd-4416-8da1-7fe6555cbcac" />
<img width="953" height="691" alt="j-2" src="https://github.com/user-attachments/assets/0ff40a67-e760-4720-adaa-723df75d4697" />
<img width="892" height="716" alt="j-1" src="https://github.com/user-attachments/assets/242cb97f-a63d-4362-8a3b-144ba44824dd" />


