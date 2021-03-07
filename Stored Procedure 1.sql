use employees; 

/*
1) Create a stored procedure named getTitle. getTitle is used to return 
the title of an employee when the first name and last name are given. 
*/


DELIMITER //
create procedure getTitle(
	-- IN empLastName varchar(255), empFirstName varchar(255), 
    -- OUT title varchar(50)
    IN employeeID int 
   -- OUT empTitle varchar(50)
    )
    BEGIN
	  -- select cancact(e.first_name, e.last_name） AS Name 
      -- select e.first_name, e.last_name, t.title from employees e
      select e.first_name, e.last_name, emp_no from employees e 
      inner join titles t using (emp_no)
      -- where e.first_name = empFirstName and e.last_name = empLastName;
      where t.title = empTitle;
	END//
    

DELIMITER ; //
call getTitle("Senior Engineer");


/*
2) Create a stored procedure that can get the average salary 
*/

DELIMITER //
create procedure getAveSalary()
	BEGIN 
		SELECT avg(salary) AS "Avg.Salary"
        FROM salaries; 
	END//
    


DELIMITER ; //
call getAveSalary();


/* 
3) Create a stored procedure to calculate years in service
*/
Delimiter //
create procedure years_in_job (
	IN employeeNum int, 
	OUT years_in_job int
)

BEGIN
	DECLARE start_year int; 
	DECLARE end_year int; 
	
	SELECT year (de.from_date), year(de.to_date)
	INTO start_year, end_year 
	FROM dept_emp de
	WHERE de.emp_no = employeeNum
	LIMIT 1; 
	
	IF end_year = 9999 THEN 
		SET end_year = year(now()); 
	END IF; 

	SELECT end_year - start_year INTO years_in_job; 
END//

DELIMITER ; //
call years_in_job (10001, @years); 
select @years; 

/*
4) create a procedure named empType that can categorize types of employees by years in job.
*/ 

Delimiter //
Create procedure empType (
	IN employeeNum int
)

BEGIN
	Declare employeeType varchar(25); 
	
	Call years_in_job(employeeNum, @years); 

	IF @years <5 THEN
		SET employeeType = 'New';
	ELSEIF @years <15 THEN 
		SET employeeType = 'Well Trained'; 
	ELSE		
		SET employeeType = 'Experienced';
	END IF; 

	SELECT @years AS years_in_job,employeeType, d.dept_name, e.first_name, e.last_name
	FROM departments d
	INNER JOIN dept_emp de ON de.dept_no = d.dept_no 
	INNER JOIN employees e ON de.emp_no = e.emp_no
	WHERE de.emp_no = employeeNum; 
END//

DELIMITER ; //
call empType (10036); 

/*5) Create procedure called getMaxSalaryPerTitle.
 It can return the max salary of the input title. 
 */


DELIMITER //
create procedure getMaxSalaryPerTitle (
	IN employeeTitle varchar(50), 
    -- OUT maxSalary int(11)
    OUT maxSalary INT
    )
BEGIN
		-- select t.title, s.slary from titles t
        -- select e.first_name, e.last_name, t.title, max(s.salary)
        select max(s.salary)
        into maxSalary
        from employees e
        -- inner join salaries using (emp_no) 
        inner join titles t using (emp_no)
        inner join salaries s using (emp_no) 
        where t.title = employeeTitle; 
       --  where employeeTitle = 'title' and MaxSalary = Max(s.salary);
	END//
    
    DELIMITER ; //

   call getMaxSalaryPerTitle("Senior Engineer", @maxSalary); 

    
    