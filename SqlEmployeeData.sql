SELECT *
FROM PortfolioProject..employee_data$

--Creating a new column for Full name from FirstName and LastName columns
ALTER TABLE dbo.employee_data$
ADD FullName AS (FirstName + ' ' + LastName)

--Know how many employees quitted from ExitDate column
SELECT COUNT(ExitDate)
FROM PortfolioProject..employee_data$
WHERE ExitDate is NOT NULL

--Know the top 3 departments with the most employees
SELECT DepartmentType, COUNT(*) AS DeptCount
FROM PortfolioProject..employee_data$
GROUP BY DepartmentType
ORDER BY DeptCount DESC
LIMIT 3

--Retrieve employees who worked for more than 3 years and have performance rating greater or equal 4
WITH cte AS (
	SELECT FullName, 
		DATEDIFF(YEAR, StartDate, GETDATE()) AS YearsWorked, 
		CurrentEmployeeRating
	FROM PortfolioProject..employee_data$
	WHERE CurrentEmployeeRating >= 4
)
SELECT *
FROM cte
WHERE YearsWorked >= 4


--Retrieve the avg employee rating for each departmnt, num of employees in dept and average years worked using subquery
SELECT DepartmentType, 
	AVG(CurrentEmployeeRating) AS AvgRating,
	COUNT(*) AS EmployeesCount,
	(SELECT AVG(DATEDIFF(YEAR, d2.StartDate, GETDATE()))
	FROM PortfolioProject..employee_data$ d2
	WHERE d2.DepartmentType = d1.DepartmentType
	GROUP BY d2.DepartmentType) AS AvgExperience
FROM PortfolioProject..employee_data$ d1
GROUP BY DepartmentType

