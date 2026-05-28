/*  employees 
employee_id	first_name	last_name	email	hire_date	job_id	salary	manager_id	department_id
100	John	Smith	   john.smith@company.com	   2020-01-15	IT_MGR	   120000	NULL	10
101	Alice	Johnson	alice.johnson@company.com	2021-03-20	IT_PROG	   85000	100	10
102	Bob	Wilson	bob.wilson@company.com	   2021-06-10	IT_PROG	   80000	100	10
103	Carol	Davis	   carol.davis@company.com	   2019-09-05	HR_REP	   60000	NULL	20
104	David	Brown	   david.brown@company.com	   2022-02-14	FIN_ANALYST	70000	NULL	30
105	Emma	Taylor	emma.taylor@company.com	   2020-11-30	MKT_MGR	   95000	NULL	40
106	Frank	Green	   frank.green@company.com	   2021-08-25	SALES_REP	65000	105	40
107	Grace	White	   grace.white@company.com	   2019-05-12	IT_PROG	   90000	100	10
108	Henry	Clark	   henry.clark@company.com	   2022-07-18	HR_REP	   55000	103	20
109	Ivy	Martinez	ivy.martinez@company.com	2023-01-10	FIN_ANALYST	68000	104	30

departments 
department_id	department_name	location
10	IT	San Francisco
20	HR	New York
30	Finance	Chicago
40	Marketing	Los Angeles
50	Operations	Seattle

jobs 
job_id	job_title	min_salary	max_salary
IT_PROG	Software Developer	60000	120000
IT_MGR	IT Manager	90000	150000
HR_REP	HR Representative	45000	75000
FIN_ANALYST	Financial Analyst	50000	85000
MKT_MGR	Marketing Manager	70000	110000
SALES_REP	Sales Representative	40000	80000

*/

---Calculate total salary for IT employees versus non-IT employees.
SELECT
   SUM(
      CASE
         WHEN job_id LIKE 'IT%' THEN salary
         ELSE 0
      END
   ) AS it_total_salary,
   SUM(
      CASE
         WHEN job_id NOT LIKE 'IT%' THEN salary
         ELSE 0
      END
   ) AS non_it_total_salary
FROM employees;

-----Return employee count and average salary by hire year.
SELECT  SUBSTR(hire_date, 1, 4)AS hire_year, COUNT(employee_id) AS employees_hired, round(AVG(salary),2) AS avg_salary
FROM employees
GROUP BY hire_year
ORDER BY hire_year  ASC;

---Return departments with more than 1 employee and average salary above $65,000.
SELECT d.department_name, count(e.employee_id) as employee_count, AVG(e.salary) AS avg_salary
FROM employees e 
JOIN departments d 
on e.department_id = d.department_id
GROUP BY d.department_name
HAVING e.salary > 65000
ORDER BY employee_count DESC

----Return the department salary summary.
SELECT d.department_name, count(e.employee_id) as total_employees, SUM(e.salary) AS total_salary_cost, AVG(salary) AS avg_salary
FROM employees e 
JOIN departments d 
on e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY total_employees DESC

----Return the department salary spread summary for the expected output.
SELECT d.department_name, count(e.employee_id) as employee_count, MIN(e.salary) AS min_salary, MAX(e.salary) AS max_salary, AVG(salary) AS avg_salary
FROM employees e 
JOIN departments d 
on e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY employee_count DESC

---------Return salary metrics for managers versus non-managers.
SELECT CASE
WHEN manager_id IS NULL THEN 'Manager'
ELSE 'Non-Manager'
END AS employee_type,
 COUNT(employee_id) as employee_count, round(AVG(salary),2) AS avg_salary, MIN(salary)  as min_salary, MAX(salary) AS max_salary
FROM employees 
GROUP BY employee_type

-----Return salary analysis by tenure group.
 select CASE
  WHEN TIMESTAMPDIFF(year, hire_date, CURRENT_DATE) < 2 THEN 'New (< 2 years)'
  WHEN TIMESTAMPDIFF(year, hire_date, CURRENT_DATE) < 4 THEN 'Mid (2-4 years)'
  ELSE 'Senior (4+ years)'
 END AS tenure_group, 
 COUNT(employee_id) as employee_count, round(AVG(salary),2) AS avg_salary, MIN(salary)  as min_salary, MAX(salary) AS max_salary
 FROM employees
 GROUP BY tenure_group
--or
SELECT
  CASE
    WHEN (DATEDIFF ('2024-01-01', hire_date)) / 365.25 < 2 THEN 'New (< 2 years)'
    WHEN (DATEDIFF ('2024-01-01', hire_date)) / 365.25 < 4 THEN 'Mid (2-4 years)'
    ELSE 'Senior (4+ years)'
  END AS tenure_group,
  COUNT(*) AS employee_count, ROUND(AVG(salary), 2) AS avg_salary, MIN(salary) AS min_salary,MAX(salary) AS max_salary
FROM employees
GROUP BY tenure_group
ORDER BY avg_salary DESC;