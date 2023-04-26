/* 1. Create a visualization that provides a breakdown between the male and female employees working in the company each year, starting from 1990.   */

select year(de.from_date) as calendar_year, e.gender , count(de.emp_no) as num_of_employees from t_employees e join t_dept_emp de on e.emp_no = de.emp_no 
where year(de.from_date) >= 1990
group by calendar_year , e.gender
order by calendar_year ;

/* 2. Compare the number of male managers to the number of female managers from different departments for each year, starting from 1990.   */


select d.dept_name, ee.gender, dm.emp_no , dm.from_date , dm.to_date , e.calendar_year ,
case when year(dm.from_date) <= e.calendar_year and e.calendar_year <= year(dm.to_date) then 1 else 0 end as active
from (select year(hire_date) as calendar_year from t_employees group by calendar_year order by calendar_year) e 
cross join t_dept_manager dm 
join 
t_employees ee on dm.emp_no = ee.emp_no 
join 
t_departments d on d.dept_no = dm.dept_no
order by dm.emp_no, e.calendar_year ;
  
/* 3. Compare the average salary of female versus male employees in the entire company until year 2002,
 and add a filter allowing you to see that per each department. */
 
 select e.gender , d.dept_name, avg(s.salary) as average_salary, year(s.from_date) as Year 
 from t_employees e join t_salaries s on e.emp_no = s.emp_no
 join t_dept_emp de on e.emp_no = de.emp_no
 join t_departments d on d.dept_no = de.dept_no 
 group by d.dept_name, e.gender , Year  
 having year <= 2002
 order by dept_name, Year ;
 
 
 /* 4. Create an SQL stored procedure that will allow you to obtain the average male and female salary per department within a certain salary range. 
 Let this range be defined by two values the user can insert when calling the procedure.
Finally, visualize the obtained result-set in Tableau as a double bar chart.  */

drop procedure if exists average_salary_per_gender;

Delimiter $$

create procedure average_salary_per_gender ( in start_range int(10), in end_range int(10) )
begin
select d.dept_name, e.gender , avg(s.salary) 
from t_salaries s join t_employees e on s.emp_no = e.emp_no
join t_dept_emp de on de.emp_no = s.emp_no
join t_departments d on de.dept_no = d.dept_no 
where  s.salary between start_range and  end_range
group by e.gender, d.dept_name 

order by d.dept_name , avg(s.salary) ;
end $$
delimiter ;

call average_salary_per_gender(50000,100000);

 
 