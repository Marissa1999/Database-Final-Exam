
--Part I:


--Question 1:

SELECT *
FROM TRANSACTION
WHERE CUSTID = '5555666';





--Question 2:

SELECT *
FROM TRANSACTION
WHERE LOCID = 'BR007';





--Question 3:

SELECT *
FROM TRANSACTION
WHERE TXNDATE >= TO_DATE('09-10-09', 'YY-MM-DD') AND TXNDATE <= TO_DATE('09-10-16', 'YY-MM-DD');





--Question 4:

SELECT *
FROM TRANSACTION
WHERE CUSTID = '1234321' AND ACCOUNTID = '007-2312'
ORDER BY TXNDATE DESC;





--Question 5:

SELECT ACCOUNTID
FROM TRANSACTION
WHERE AMTWITH <> 0
GROUP BY ACCOUNTID;





--Question 6:

SELECT TXNID, (TXNDATE + 5) AS "TRANSACTION DATE"
FROM TRANSACTION
WHERE CHARGE = 2.5;










--Part II:



--Question 1:

SELECT TXNID
FROM TRANSACTION
WHERE AMTDEP <> 0;





--Question 2:


SELECT TXNID
FROM TRANSACTION
WHERE AMTDEP = 0;





--Question 3:

SELECT MAX(AMTWITH) AS "MAXIMUM WITHDRAWAL", MAX(AMTDEP) AS "MAXIMUM DEPOSIT"
FROM TRANSACTION
WHERE LOCID = 'BR007';





--Question 4:

SELECT AVG(AMTWITH) AS "AVERAGE WITHDRAWAL"
FROM TRANSACTION;





--Question 5:

SELECT COUNT(*) AS "TRANSACTIONS ON OCTOBER 1ST"
FROM TRANSACTION
WHERE TXNDATE = TO_DATE('09-10-01', 'YY-MM-DD');




--Question 6:

SELECT COUNT(*) AS "NON-BRANCH TRANSACTIONS"
FROM TRANSACTION
WHERE LOCID NOT LIKE 'BR%';





--Question 7:

SELECT ACCOUNTID, (AMTDEP - AMTWITH) AS "ACCOUNT BALANCE WITHOUT CHARGE"
FROM TRANSACTION;










--Part III:



--Question 1:

SELECT ACCOUNTID, (AMTDEP - AMTWITH - NVL(CHARGE, 0)) AS "ACCOUNT BALANCE WITH CHARGE"
FROM TRANSACTION;




--Question 2:

SELECT ACCOUNTID, ADD_MONTHS(TXNDATE, 1) AS "NOVEMBER TRANSACTIONS", AMTDEP, AMTWITH, CHARGE
FROM TRANSACTION
WHERE CUSTID = '5555666';




--Question 3:

SELECT SUM(AMTDEP - AMTWITH - NVL(CHARGE,0)) AS "TOTAL TRANSACTION CHANGE"
FROM TRANSACTION
WHERE ACCOUNTID = '007-2312';










--Part IV:



--Question 1:


--Sub-Query:

SELECT FIRST_NAME, LAST_NAME
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
					   FROM DEPARTMENTS
					   WHERE DEPARTMENT_NAME = 'Accounting')
ORDER BY LAST_NAME;




--Explicit Join:

SELECT FIRST_NAME, LAST_NAME
FROM EMPLOYEES INNER JOIN DEPARTMENTS USING(DEPARTMENT_ID)
WHERE DEPARTMENT_NAME = 'Accounting'
ORDER BY LAST_NAME;










--Question 2: 


--Sub-Query:

SELECT FIRST_NAME, LAST_NAME, TRUNC(((SYSDATE - HIRE_DATE) / 365.25), 0) AS "SENIORITY"
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
					   FROM DEPARTMENTS
					   WHERE DEPARTMENT_NAME = 'Accounting')
ORDER BY LAST_NAME;




--Implicit Join:

SELECT E.FIRST_NAME, E.LAST_NAME, TRUNC(((SYSDATE - HIRE_DATE) / 365.25), 0) AS "SENIORITY"
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID AND DEPARTMENT_NAME = 'Accounting'
ORDER BY LAST_NAME;









--Question 3:


--Implicit Join:

SELECT D.DEPARTMENT_NAME, COUNT(*) AS "EMPLOYEES NUMBER"
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME;



--Explicit Join:

SELECT DEPARTMENT_NAME, COUNT(*) AS "EMPLOYEES NUMBER"
FROM EMPLOYEES 
INNER JOIN DEPARTMENTS 
USING (DEPARTMENT_ID)
GROUP BY DEPARTMENT_NAME;








--Question 4:


--Implicit Join:

SELECT DEPARTMENT_NAME
FROM (SELECT D.DEPARTMENT_NAME
      FROM EMPLOYEES E, DEPARTMENTS D
	  WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
	  ORDER BY E.SALARY DESC)
WHERE ROWNUM = 1;               



--Explicit Join:

SELECT DEPARTMENT_NAME
FROM (SELECT DEPARTMENT_NAME
      FROM EMPLOYEES 
	  INNER JOIN DEPARTMENTS 
	  USING(DEPARTMENT_ID)
	  ORDER BY SALARY DESC)
WHERE ROWNUM = 1;               


				


				
					   
					   

--Question 5:


--Sub-Query:

SELECT FIRST_NAME, LAST_NAME
FROM (SELECT FIRST_NAME, LAST_NAME
	  FROM EMPLOYEES
	  WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
							 FROM DEPARTMENTS
							 WHERE DEPARTMENT_NAME = 'Finance')
	  ORDER BY SALARY ASC)
WHERE ROWNUM = 1;




--Explicit Join:

SELECT FIRST_NAME, LAST_NAME
FROM (SELECT FIRST_NAME, LAST_NAME
	  FROM EMPLOYEES 
	  INNER JOIN DEPARTMENTS
	  USING (DEPARTMENT_ID)
      WHERE DEPARTMENT_NAME = 'Finance'
	  ORDER BY SALARY ASC)
WHERE ROWNUM = 1;



 

 
 
--Question 6:


--Sub-Query

SELECT FIRST_NAME, LAST_NAME
FROM EMPLOYEES 
WHERE MANAGER_ID = (SELECT MANAGER_ID
					FROM EMPLOYEES
					WHERE LAST_NAME = 'Himuro');


					

--Implicit Join:

SELECT E.FIRST_NAME, E.LAST_NAME
FROM EMPLOYEES E, EMPLOYEES M
WHERE E.MANAGER_ID = M.MANAGER_ID AND M.LAST_NAME = 'Himuro';











--I: Application Using Education Database System


--a)

COLUMN S_LAST FORMAT A10;
COLUMN S_FIRST FORMAT A10;

SELECT S_ID, S_LAST, S_FIRST, F_ID
FROM STUDENT
WHERE F_ID IN (SELECT F_ID
                   FROM FACULTY
				   WHERE F_LAST = 'Robertson');
				   
				   
				   
--b)

SELECT S_ID, S_LAST, S_FIRST, BIRTHDAY
FROM STUDENT
WHERE BIRTHDAY < (SELECT BIRTHDAY
                   FROM STUDENT
				   WHERE S_LAST = 'White');
				   
				   

--c)

SELECT S_ID, S_LAST, S_FIRST, F_ID
FROM STUDENT
WHERE F_ID IN (SELECT F_ID
                   FROM FACULTY
				   WHERE F_LAST <> 'Robertson');



				   

--d)

SELECT S.S_ID, S.S_LAST, S.S_FIRST, S.F_ID, F.F_LAST
FROM STUDENT S, FACULTY F
WHERE S.F_ID = F.F_ID AND F.F_ID IN (SELECT F_ID
                                     FROM FACULTY
				                     WHERE F_LAST <> 'Robertson');




--e)

SELECT S_ID, COURSE_NO, GRADE
FROM ENROLLMENT
WHERE S_ID = (SELECT S_ID
              FROM STUDENT
			  WHERE F_ID = (SELECT F_ID
			                FROM FACULTY
							WHERE F_LAST = 'Fillipo'));




							

--f)

COLUMN F_LAST FORMAT A10;
COLUMN F_FIRST FORMAT A10;

CREATE TABLE TEMP
AS
SELECT F.F_ID, F.F_LAST, F.F_FIRST, F.BIRTHDAY, F.DEPTID, D.DEPTNAME, D.LOCATION
FROM FACULTY F, DEPARTMENT D
WHERE F.BIRTHDAY >= TO_DATE('01-01-1950', 'DD-MM-YYYY') AND F.BIRTHDAY <= TO_DATE('01-01-1972', 'DD-MM-YYYY')
AND F.DEPTID = D.DEPTID AND D.DEPTID IN (SELECT DEPTID
                                         FROM DEPARTMENT
				                         WHERE DEPTNAME = 'Telecommunication' OR DEPTNAME = 'Computer Science');



SELECT * FROM TEMP;






--g)

INSERT INTO TEMP (F_ID, F_LAST, F_FIRST, BIRTHDAY, DEPTID, DEPTNAME, LOCATION)
SELECT F.F_ID, F.F_LAST, F.F_FIRST, F.BIRTHDAY, F.DEPTID, D.DEPTNAME, D.LOCATION
FROM FACULTY F, DEPARTMENT D
WHERE F.DEPTID = D.DEPTID AND F.SOC_INS LIKE '___-___-789';


SELECT * FROM TEMP;




--h)

UPDATE STUDENT
SET S_CLASS = 'JR'
WHERE F_ID = (SELECT F_ID
              FROM FACULTY
              WHERE F_LAST = 'Smith');


SELECT * FROM STUDENT;





--i)

SELECT S_ID, S_LAST, S_FIRST, S_CLASS, F_ID, BIRTHDAY, SOC_INS
FROM STUDENT
WHERE F_ID IN (SELECT F_ID
               FROM FACULTY
			   WHERE DEPTID = (SELECT DEPTID
							   FROM DEPARTMENT 
							   WHERE DEPTNAME = 'Accounting'));





--j)

SELECT S_ID, COURSE_NO, GRADE
FROM ENROLLMENT
WHERE S_ID IN (SELECT S_ID
              FROM STUDENT
			  WHERE F_ID IN (SELECT F_ID
			                FROM FACULTY
							WHERE F_LAST = 'Arlec'));




--k)

SELECT S_ID, S_LAST, S_FIRST, F_ID
FROM STUDENT
WHERE F_ID IN (SELECT F_ID
               FROM FACULTY 
			   WHERE F_LAST <> 'Robertson' OR F_LAST <> 'Arlec');



			   


--l)

SELECT S_ID, COURSE_NO, GRADE
FROM ENROLLMENT
WHERE S_ID IN (SELECT S_ID 
               FROM STUDENT
			   WHERE F_ID IN (SELECT F_ID 
			                  FROM FACULTY
			                  WHERE F_LAST <> 'Smith'));

							  
							  
		


		
--II: Application Using Edition Database System


--a)

SELECT B_TITLE, B_PRICE
FROM BOOK
UNION
SELECT C_TITLE, C_PRICE
FROM CHAPTER;





--b)

SELECT B_ID, B_AUTHOR, B_TITLE, B_PRICE, B_TYPE
FROM BOOK
WHERE B_ID IN (SELECT B_ID
               FROM BOOK
			   GROUP BY B_ID
			   HAVING AVG(B_PRICE) < (SELECT AVG(B_PRICE)
								      FROM BOOK));


SELECT AVG(B_PRICE)
FROM BOOK;







--c)

SELECT B_ID, B_AUTHOR, B_TITLE, B_PRICE, B_TYPE, P_ID
FROM BOOK
WHERE P_ID IN (SELECT P_ID
               FROM PUBLISHER
			   WHERE P_NAME = 'Harvard Publishing' OR P_NAME = 'Course Technology');







--d)

SELECT ROWNUM, B_ID, B_AUTHOR, B_TITLE, B_PRICE, B_TYPE
FROM (SELECT B_ID, B_AUTHOR, B_TITLE, B_PRICE, B_TYPE
      FROM BOOK
      ORDER BY B_PRICE DESC)
WHERE ROWNUM <= 3;





--e)

SELECT ROWNUM, B_ID, B_AUTHOR, B_TITLE, B_PRICE, B_TYPE
FROM (SELECT B_ID, B_AUTHOR, B_TITLE, B_PRICE, B_TYPE
      FROM BOOK
      ORDER BY B_PRICE)
WHERE ROWNUM <= 3;






--f)

SELECT ROWNUM, S_ID, COURSE_NO, GRADE, S_LAST, S_FIRST
FROM(SELECT E.S_ID, E.COURSE_NO, E.GRADE, S.S_LAST, S.S_FIRST
           FROM ENROLLMENT E, STUDENT S
		   WHERE E.S_ID = S.S_ID
           ORDER BY E.GRADE)
WHERE ROWNUM <= 5;






--g)

SELECT ROWNUM, S_ID, COURSE_NO, GRADE, S_LAST, S_FIRST
FROM(SELECT E.S_ID, E.COURSE_NO, E.GRADE, S.S_LAST, S.S_FIRST
           FROM ENROLLMENT E, STUDENT S
		   WHERE E.S_ID = S.S_ID
           ORDER BY E.GRADE DESC)
WHERE ROWNUM <= 5;





--h)

SELECT B_TITLE "Title", B_PRICE "Price"
FROM BOOK
WHERE B_TYPE = (SELECT B_TYPE
                FROM BOOK
				WHERE B_TITLE LIKE '%p%');





--i)

SELECT B_ID, B_AUTHOR, B_TITLE, B_ISBN, P_NAME
FROM BOOK, PUBLISHER
WHERE BOOK.P_ID = PUBLISHER.P_ID
AND B_TYPE IN (SELECT B_TYPE 
               FROM BOOK
			   WHERE B_TITLE LIKE '%in%');




			   
			   
--j)

CREATE TABLE BOOKMONTREALSHOP
AS
SELECT B_ID, B_AUTHOR, B_TITLE, B_PRICE, B_TYPE
FROM BOOK
WHERE B_TYPE IN (SELECT B_TYPE
                  FROM BOOK
				  WHERE B_TYPE = 'EX')
ORDER BY B_ID;


				  
SELECT * FROM BOOKMONTREALSHOP;






CREATE TABLE BOOKNEWYORKSHOP
AS
SELECT B_ID, B_AUTHOR, B_TITLE, B_PRICE, B_TYPE
FROM BOOK
WHERE B_TYPE IN (SELECT B_TYPE
                  FROM BOOK
				  WHERE B_TYPE = 'EX' OR B_TYPE = 'BG')
ORDER BY B_ID;
			
				
			
SELECT * FROM BOOKNEWYORKSHOP;






CREATE TABLE BOOKVANCOUVERSHOP
AS
SELECT B_ID, B_AUTHOR, B_TITLE, B_PRICE, B_TYPE
FROM BOOK
WHERE B_TYPE IN (SELECT B_TYPE
                  FROM BOOK
				  WHERE B_TYPE = 'EX' OR B_TYPE = 'MD')
ORDER BY B_ID;
			
				
			
SELECT * FROM BOOKVANCOUVERSHOP;





--k)

SELECT * FROM BOOKMONTREALSHOP
INTERSECT
SELECT * FROM BOOKNEWYORKSHOP
INTERSECT
SELECT * FROM BOOKVANCOUVERSHOP;





--l)

SELECT * FROM BOOKNEWYORKSHOP
MINUS
SELECT * FROM BOOKMONTREALSHOP
MINUS
SELECT * FROM BOOKVANCOUVERSHOP;





--m)

SELECT * FROM BOOKVANCOUVERSHOP
MINUS
SELECT * FROM BOOKMONTREALSHOP;










--I: Single-Row Sub-Queries


--Query 1:

COLUMN s_last FORMAT A10;
COLUMN s_first FORMAT A10;

SELECT s_id, s_last, s_first, f_id
FROM student
WHERE f_id = (
               SELECT f_id 
               FROM faculty
			   WHERE f_last = 'Arlec'
			  );




		
		
--Query 2:

COLUMN s.s_last FORMAT A10;
COLUMN s.s_first FORMAT A10;
COLUMN facultyName FORMAT A20 HEADING "Faculty Name";

SELECT s.s_id, s.s_last, s.s_first, s.f_id, f.f_last || ' ' || f.f_first facultyName
FROM student s, faculty f
WHERE s.f_id = f.f_id AND f.f_last = 'Arlec';
			                      




		
		

--Query 3:

SELECT s_id, s_last, s_first, birthday
FROM student
WHERE birthday >=  (
                     SELECT birthday
                     FROM student
					 WHERE s_last = 'Sanchez'
					);


SELECT * FROM student;







--Query 4:

SELECT s_id, s_last, s_first, birthday
FROM student
WHERE birthday >=  (
                     SELECT birthday
                     FROM student
					 WHERE s_last = 'White'
					);





					


--Query 5:

COLUMN s_last FORMAT A10;
COLUMN s_first FORMAT A10;

SELECT s_id, s_last, s_first, f_id
FROM student
WHERE f_id != (
               SELECT f_id 
               FROM faculty
			   WHERE f_last = 'Arlec'
			  );


			  

			  
			  
			  
			  
--Query 6:

SELECT s_id, course_no, grade
FROM enrollment
WHERE s_id = (
                SELECT s_id
				FROM student
				WHERE f_id = (
				                SELECT f_id
								FROM faculty
								WHERE f_last = 'Smith'
				              )
             );



			 
			 


--Query 7:

SELECT s.s_id, s.s_last, s.s_first, e.course_no, e.grade, f.f_last
FROM student s, enrollment e, faculty f
WHERE s.s_id = e.s_id AND s.f_id = f.f_id AND f.f_last = 'Smith';







--Query 8:

CREATE TABLE temp
AS
SELECT s_id, s_last, s_first, s_class
FROM student
WHERE s_class = 'JR';


DESCRIBE temp;

SELECT * FROM temp;





--Query 9:

INSERT INTO temp(s_id, s_first, s_last)
SELECT s_id, s_first, s_last
FROM student
WHERE s_class = 'SR';

SELECT * FROM temp;






--Query 10:

UPDATE student SET s_class = 'EX'
WHERE f_id = (
                SELECT f_id
			    FROM faculty
			    WHERE f_last = 'Robertson'
             );


SELECT * FROM student;







--Query 11:

DELETE FROM student
WHERE f_id = (
                SELECT f_id
			    FROM faculty
			    WHERE f_last = 'Silcoff'
             );

			 
SELECT * FROM student;



			 


--Query 12:

SELECT course_no, course_name, max_enrl
FROM course
WHERE max_enrl < (
                    SELECT AVG(SUM(max_enrl))
					FROM course
					GROUP BY max_enrl
                 );







--II: Multiple-Row Sub-Queries




--Query 13:

COLUMN s_last FORMAT A10;
COLUMN s_first FORMAT A10;

SELECT s_id, s_last, s_first, birthday, f_id
FROM student
WHERE f_id IN (
                SELECT f_id
			    FROM faculty
			    WHERE f_id > 2
              );



			 
			 
			 

--Query 14:

SELECT *
FROM course
WHERE course_no IN  (
                       SELECT course_no
			           FROM enrollment
			           WHERE grade = 'A+'
                    );





					


--Query 15:

COLUMN s.s_last FORMAT A10;
COLUMN s.s_first FORMAT A10;

SELECT s.s_id, s.s_last, s.s_first, s.s_class
FROM student s, enrollment e
WHERE s.s_id = e.s_id AND e.grade = 'A+'
ORDER BY s.s_id;









--Query 16:

SELECT ROWNUM, course_no, course_name, max_enrl
FROM (SELECT course_no, course_name, max_enrl
      FROM course
	  ORDER BY max_enrl DESC)
WHERE ROWNUM <= 3;


SELECT * FROM course;






--Query 17:

SELECT ROWNUM, course_no, course_name, max_enrl
FROM (SELECT course_no, course_name, max_enrl
      FROM course
	  ORDER BY max_enrl)
WHERE ROWNUM <= 3;













--Question 2:


--a)

SELECT student.s_id, student.s_last, student.s_class, faculty.f_last, faculty.f_first
FROM student, faculty
WHERE student.f_id = faculty.f_id;




--b)

SELECT student.s_id, student.s_last, student.s_class, faculty.f_last, faculty.f_first
FROM student, faculty
WHERE student.f_id = faculty.f_id;





--c)

SELECT student.s_last, student.s_first, faculty.f_last, faculty.f_first
FROM student, faculty;




--d)

SELECT s.s_id, s.s_last, s.s_class, f.f_last, f.f_first
FROM student s, faculty f
WHERE s.f_id = f.f_id;





--e)

SELECT s.s_id, s.s_last, s.s_class, f.f_last, f.f_first
FROM student s, faculty f
WHERE s.f_id = f.f_id AND s.s_class = 'EX';






--Question 3:

--a)

SELECT s.s_id, e.course_no, e.grade, s.s_last, s.s_first
FROM student s, enrollment e
WHERE s.s_id = e.s_id;





--b)

SELECT s.s_id, s.s_last, s.s_first, e.course_no, c.course_name, e.grade
FROM student s, enrollment e, course c
WHERE s.s_id = e.s_id AND e.course_no = c.course_no
ORDER BY s.s_id;




--c)

SELECT s.s_id, s.s_last, s.s_first, e.course_no, c.course_name, e.grade
FROM student s, enrollment e, course c
WHERE s.s_id = e.s_id AND e.course_no = c.course_no AND c.course_no = 'MIS 551';




--d)

SELECT s.s_id, s.s_last, s.s_first, e.course_no, c.course_name, e.grade
FROM student s, enrollment e, course c
WHERE s.s_id = e.s_id AND e.course_no = c.course_no AND (e.grade = 'A+' OR e.grade = 'A-')
ORDER BY s.s_id;




--e)

SELECT s.s_id, s.s_last, s.s_first, e.course_no, c.course_name, e.grade
FROM student s, enrollment e, course c
WHERE s.s_id = e.s_id AND e.course_no = c.course_no AND c.course_name LIKE '%Systems%'
ORDER BY s.s_id;





--f)

SELECT s.s_id, s.s_last, s.s_first, e.course_no, c.course_name, e.grade, f.f_last
FROM student s, enrollment e, course c, faculty f
WHERE s.s_id = e.s_id AND e.course_no = c.course_no AND s.f_id = f.f_id AND (e.grade = 'C+' OR e.grade = 'B-')
ORDER BY s.s_id;





--g)

SELECT s.s_id, s.s_last, s.s_first, e.course_no, c.course_name, e.grade, f.f_last
FROM student s, enrollment e, course c, faculty f
WHERE s.s_id = e.s_id AND e.course_no = c.course_no AND s.f_id = f.f_id AND (e.grade = 'A+' OR e.grade = 'A-') AND c.course_name LIKE '%Systems%'
ORDER BY s.s_id;





--h)

SELECT s.s_id, s.s_last, s.s_first, e.course_no, c.course_name, e.grade, f.f_last
FROM student s, enrollment e, course c, faculty f
WHERE s.s_id = e.s_id AND e.course_no = c.course_no AND s.f_id = f.f_id AND (e.grade = 'B+' OR e.grade = 'B-') AND s.s_last = 'White' AND s.s_first = 'Peter'
ORDER BY s.s_id;





--i)

SELECT s.s_id, s.s_last, s.s_first, e.course_no, c.course_name, e.grade, f.f_last
FROM student s, enrollment e, course c, faculty f
WHERE s.s_id = e.s_id AND e.course_no = c.course_no AND s.f_id = f.f_id AND (e.grade = 'A+' OR e.grade = 'B-') AND f.f_last = 'Arlec' AND f.f_first = 'Lisa'
ORDER BY s.s_id;






--j)

SELECT s.s_id, s.s_last, s.s_first, e.course_no, c.course_name, e.grade, f.f_last
FROM student s, enrollment e, course c, faculty f
WHERE s.s_id = e.s_id AND e.course_no = c.course_no AND s.f_id = f.f_id AND s.s_class = 'JR' 
ORDER BY s.s_id;






--k)

SELECT s.s_id, s.s_last, s.s_first, e.course_no, c.course_name, e.grade, f.f_last, f.f_first, s.s_class
FROM student s, enrollment e, course c, faculty f
WHERE s.s_id = e.s_id AND e.course_no = c.course_no AND s.f_id = f.f_id AND (s.s_class = 'EX' OR s.s_class = 'SR') AND (f.f_last = 'Arlec' OR f.f_last = 'Smith') 
ORDER BY s.s_id, c.course_name;












--Question 2:

SELECT student.s_id, student.s_last, student.s_class, faculty.f_last, faculty.f_first
FROM student, faculty
WHERE student.f_id = faculty.f_id;



--Question 3:

SELECT student.f_id "Student_f_id", student.s_last, student.s_first, faculty.f_last, faculty.f_first,
faculty.f_id "Faculty_f_id"
FROM student, faculty;




--Question 4:

INSERT INTO STUDENT VALUES (7, 'Daniel', 'Criag', 'JR', null, null);




--Question 5:

INSERT INTO STUDENT VALUES (8, 'Celine', 'Dion', 'JR', null, null);




--Question 6:

SELECT * FROM student;





--Question 7:

SELECT * FROM faculty;





--Question 8:

SELECT s.s_id, s.s_last, s.s_class, f.f_last, f.f_first
FROM student s, faculty f
WHERE s.f_id = f.f_id;





--Question 9:

SELECT s.s_id, s.s_last, s.s_class, f.f_last, f.f_first
FROM student s, faculty f
WHERE s.f_id = f.f_id AND s.s_class = 'EX';






--Question 10:

SELECT s.s_id, s.s_last, s.s_class, f.f_last, f.f_first
FROM student s, faculty f
WHERE s.f_id = f.f_id AND (s.s_class = 'EX' OR s.s_class = 'SR');





--Question 11:

SELECT * FROM levelclass;






--Question 12:

SELECT c.course_no, c.course_name, c.credits, c.max_enrl, l.lc_type, l.lc_desc
FROM course c, levelclass l
WHERE c.max_enrl BETWEEN l.lc_min AND l.lc_max;





--Question 13:

SELECT student.s_id, student.s_last, student.s_class, faculty.f_last, faculty.f_first
FROM student, faculty
WHERE student.f_id = faculty.f_id;






--Question 14:

SELECT student.s_id, student.s_last, student.s_class, faculty.f_last, faculty.f_first
FROM student, faculty
WHERE student.f_id (+) = faculty.f_id
ORDER BY student.s_id;





--Question 15:

SELECT student.s_id, student.s_last, student.s_class, faculty.f_last, faculty.f_first
FROM student, faculty
WHERE student.f_id = faculty.f_id (+);





--Question 16:

SELECT student.s_id, student.s_last, student.s_class, faculty.f_last, faculty.f_first
FROM student, faculty
WHERE student.f_id = faculty.f_id (+)
ORDER BY student.s_id;






--Question 17:

SELECT student.s_id, student.s_last, student.s_class, faculty.f_last, faculty.f_first
FROM student, faculty
WHERE student.f_id (+) = faculty.f_id (+);






--Question 18:

SELECT c.course_no, c.course_name, c.credits, c.max_enrl, c.prereq
FROM course c, course r
WHERE c.course_no = r.prereq;





--Question 19:

SELECT c.course_no ||', '|| c.course_name "Course", c.course_no ||', '|| r.course_name "Pre-Requiste Course"
FROM course c, course r
WHERE c.prereq = r.course_no;






--Question 20:

SELECT c.course_no ||', '|| c.course_name "Course", c.course_no ||', '|| r.course_name "Pre-Requiste Course"
FROM course c, course r
WHERE c.prereq = r.course_no (+);






--Question 21:

SELECT s_id, s_last, s_first FROM student
UNION
SELECT w_id, w_last, w_first FROM worker;





--Question 22:

SELECT s_id, s_last, s_first FROM student
UNION ALL
SELECT w_id, w_last, w_first FROM worker;





--Question 23:

SELECT s_id, s_last, s_first FROM student
INTERSECT
SELECT w_id, w_last, w_first FROM worker;





--Question 24:

SELECT s_id, s_last, s_first FROM student
MINUS
SELECT w_id, w_last, w_first FROM worker;











--Activity 3:



--1:

SELECT POWER(2, 10)
FROM DUAL;



--2:

SELECT Lname, Fname, NVL(Commission, 0)
FROM EMPLOYEE
ORDER BY NVL(Commission, 0) DESC;




--3:

COLUMN SalaryFormat FORMAT $999,999
SELECT Lname||', '||Fname, Salary AS SalaryFormat
FROM EMPLOYEE
ORDER BY Salary DESC;




--4:

SELECT Lname, Fname, 
CASE  WHEN commission IS NULL THEN salary
      ELSE salary+commission
END "Salary/Commission"
FROM EMPLOYEE;





--5:

SELECT Lname, Fname, TO_CHAR(HireDate, 'YYYY')
FROM EMPLOYEE
ORDER BY TO_CHAR(HireDate, 'YYYY') ASC;





--6:

--a)

SELECT AVG(Commission)
FROM EMPLOYEE
WHERE Commission IS NOT NULL;


--b)

SELECT AVG(NVL(Commission, 0))
FROM EMPLOYEE;




--7:

COLUMN Years FORMAT 999
SELECT EmployeeId, Lname, Fname, FLOOR((SYSDATE - HireDate)/ 365) AS Years
FROM EMPLOYEE;




--8:

SELECT EmployeeId, COUNT(EmployeeId)
FROM DEPENDENT
GROUP BY EmployeeId
HAVING COUNT(EmployeeId) >= 2;




--9:

SELECT DeptId, AVG(Salary)
FROM EMPLOYEE
GROUP BY DeptId
HAVING AVG(Salary) >= 75000;




--10:

SELECT Lname, Fname, 
CASE  WHEN salary > 100000 THEN 'HIGH'
      WHEN salary >= 50000 AND salary <= 100000 THEN 'MEDIUM'
      WHEN salary < 50000 THEN 'LOW'
END "Salary Level"
FROM EMPLOYEE;











--Question 2:


--a)

ALTER TABLE book
ADD PublishDate DATE;



--b)

UPDATE book
SET PublishDate = TO_DATE ('13-07-1997', 'DD-MM-YY')
WHERE b_id = 1;

UPDATE book
SET PublishDate = TO_DATE ('06-01-2005', 'DD-MM-YY')
WHERE b_id = 2;

UPDATE book
SET PublishDate = TO_DATE ('31-05-2010', 'DD-MM-YY')
WHERE b_id = 3;

UPDATE book
SET PublishDate = TO_DATE ('16-10-2011', 'DD-MM-YY')
WHERE b_id = 4;

UPDATE book
SET PublishDate = TO_DATE ('17-07-1997', 'DD-MM-YY')
WHERE b_id = 5;

UPDATE book
SET PublishDate = TO_DATE ('24-09-2007', 'DD-MM-YY')
WHERE b_id = 6;


SELECT * FROM book;



--Question 3:



--a)

UPDATE book SET b_type = '&b_type'
WHERE b_id = &b_id;




--b)

UPDATE book SET b_isbn = '123-456'
WHERE b_id = &b_id;




--c)

UPDATE book SET b_price =
(CASE  WHEN b_type='BG' THEN b_price*1.1
      WHEN  b_type='MD' THEN b_price*1.2
      WHEN  b_type='EX' THEN b_price*1.3
      ELSE  b_price
END);


SELECT * FROM book;





--d)

SELECT b_id, UPPER(b_author), LOWER(b_title), INITCAP(b_title) 
FROM book;





--e)

SELECT p_name, p_address, p_id, LENGTH(p_name) AS "Length of Pub Name"
FROM publisher
ORDER BY LENGTH(p_name);




--f)

SELECT p_name, INSTR(p_name, ' ') AS "The Blank Position of P_Name", p_address, p_id	
FROM publisher
ORDER BY p_name;




--g)

COLUMN FirstNameFormat HEADING "Pub_N_Part1" FORMAT A20
COLUMN LastNameFormat HEADING "Pub_N_Part2" FORMAT A20
SELECT p_name, SUBSTR(p_name, 1, INSTR(p_name, ' ') - 1) AS FirstNameFormat, SUBSTR(p_name, INSTR(p_name, ' ') + 1) AS LastNameFormat, p_id
FROM publisher;




--h)

SELECT b_id, UPPER(b_author), INITCAP(b_title), CEIL(b_price)
FROM book
ORDER BY CEIL(b_price) DESC;





--i)

COLUMN FirstNameFormat HEADING "Author F_name" FORMAT A20
COLUMN LastNameFormat HEADING "Author L_name" FORMAT A20
SELECT b_id, SUBSTR(b_author, 1, INSTR(b_author, ' ') - 1) AS FirstNameFormat, SUBSTR(b_author, INSTR(b_author, ' ') + 1) AS LastNameFormat, b_type,
DECODE (b_type, 'BG', 'Book for Beginners',
        'EX', 'Book for Expert',
        'MD', 'Book for Intermediate') "Book Level"
FROM book;






--j)

COLUMN PriceFormat HEADING "bPFormat" FORMAT $999.999
SELECT b_id, b_author, b_title, b_price AS PriceFormat
FROM book;






--k)

COLUMN PriceFormat HEADING "New Price" FORMAT $999.999
SELECT b_id, b_author, b_title,
CASE  WHEN b_type='BG' THEN b_price - (b_price * 0.15)
      WHEN  b_type='MD' THEN b_price - (b_price * 0.25)
      WHEN  b_type='EX' THEN b_price - (b_price * 0.35)
      ELSE  b_price
END PriceFormat
FROM book;





--l)

COLUMN AveragePrice HEADING "Average BOOK Price" FORMAT 999.999999
SELECT MAX(b_price) AS "Maximum BOOK Price", MIN(b_price) AS "Minimum BOOK Price", AVG(b_price) AS AveragePrice
FROM book;






--m)

SELECT b_id AS "BookID", c_no AS "Nb. Chapters", SUM(c_price) AS "Sum of Price", SUM(c_price) * 1.05 AS "Sum of Price * 1.05"
FROM chapter
GROUP BY b_id, c_no
HAVING c_no >= 3
ORDER BY b_id DESC;





--n)

COLUMN DateFormat HEADING "Publishing Date Format" FORMAT A37
SELECT b_id, UPPER(b_author) AS "Author's Name", LOWER(b_title) AS "Title in Lower Case", TO_CHAR(PublishDate, 'DY, MONTH DD, YYYY HH:MI:SS A.M.') AS DateFormat
FROM book;






--o)

COLUMN DateFormat HEADING "Publishing Date Format" FORMAT A38
COLUMN PriceFormat HEADING "bPFormat" FORMAT $999.999
SELECT b_id, UPPER(b_author), INITCAP(b_title), b_price AS PriceFormat, TO_CHAR(PublishDate, 'DY, MONTH DD, YYYY HH:MI:SS A.M.') AS DateFormat
FROM book;












--Question 2:


--a)

SELECT f_id, UPPER(f_last), LOWER(f_first),
INITCAP (f_last || ' ' || f_first)
FROM faculty;



SELECT f_last, f_first, f_id
FROM faculty
ORDER BY LENGTH(f_last);



SELECT course_no, INSTR(course_no, 'S') "The Position of S in Course_No", course_name
FROM course;







--b)

SELECT ROUND(28.7654, 2)
FROM dual;



SELECT POWER(2, 4)
FROM dual;



SELECT CEIL(28.7654)
FROM dual;



SELECT TRUNC(28.7654, 2)
FROM dual;








--c)

SELECT SYSDATE
FROM dual;


SELECT ADD_MONTHS('10-MAY-03', 3)
FROM dual;









--d)

SELECT TO_CHAR(SYSDATE, 'DY, MONTH DD, YYYY HH:MI:SS P.M.')
FROM dual;







--e)

SELECT course_no, course_name, max_enrl,
DECODE (max_enrl, 140, 'Extra Large Class',
        90, 'Large Class',
		30, 'Medium Class',
		35, 'Unique Class',
		'Small') "Class Desc"
FROM course;







--f)

SELECT SUM(max_enrl), AVG(max_enrl), MAX(max_enrl), MIN(max_enrl)
FROM course;






--Question 3




--a)

SELECT *
FROM faculty
WHERE f_last LIKE '&NAME';






--b)

SELECT *
FROM faculty
WHERE f_last LIKE '&&NAME';






--c)

DEFINE Last = Smith

SELECT * 
FROM faculty
WHERE f_last = '&Last';








--d)

UPDATE course 
SET max_enrl = CASE
WHEN course_no = 'MIS 101' THEN max_enrl * 2
WHEN course_no = 'MIS 301' THEN max_enrl * 1.5
WHEN course_no = 'MIS 441' THEN max_enrl * 3
ELSE max_enrl
END;

SELECT * FROM course;










--Question 1:

SELECT f.Name
FROM faculty f, department d
WHERE f.DeptId = d.DeptId AND f.DeptId = 3;






--Question 2:

SELECT Name 
FROM faculty
WHERE DeptId = 3 AND DeptId IN (SELECT DeptId
                                FROM department);




				 

--Question 3:

SELECT s.Last, s.First, t.TermDesc
FROM student s, term t
WHERE s.StartTerm = t.TermId;






--Question 4:

SELECT c.CourseId, c.Title, c.PreReq, t.Title 
FROM course c LEFT JOIN course t
ON t.CourseId = c.PreReq; 






--Question 5:

SELECT SUM(Capacity)
FROM location
WHERE RoomType IN (SELECT RoomType
                   FROM room
				   WHERE RoomDesc = 'Classroom');







--Question 6:

SELECT SUM(Capacity)
FROM location l, room r
WHERE l.RoomType = r.RoomType AND r.RoomDesc = 'Classroom';






--Question 7:

SELECT Building, RoomNo
FROM location
WHERE RoomId = (SELECT RoomId
                FROM faculty
				WHERE Name = 'Jones');






--Question 8:

SELECT l.Building, l.RoomNo
FROM location l, faculty f
WHERE l.RoomId = f.RoomId AND f.Name = 'Jones';






--Question 9:

SELECT Title
FROM course
WHERE CourseId = (SELECT CourseId
                  FROM crssection
				  WHERE CsId = (SELECT CsId
				                FROM registration
								WHERE MidTerm = 'F' AND StudentId = (SELECT StudentId
																     FROM student
																	 WHERE First = 'Deborah')));
				                        







--Question 10:

SELECT c.Title
FROM student s, registration r, crssection cr, course c
WHERE cr.CourseId = c.CourseId AND r.StudentId = s.StudentId 
AND cr.CsId = r.CsId AND s.First = 'Deborah' AND r.MidTerm = 'F';







--Question 11:

SELECT e.LName, e.FName, q.QualDesc
FROM employee e LEFT JOIN qualification q
USING (QualId)
ORDER BY e.LName;







--Question 12:

SELECT s.Last, s.FIRST
FROM student s, term t
WHERE s.StartTerm = t.TermId AND t.TermId = 'WN03';







--Question 13:

SELECT Last, First
FROM student
WHERE StartTerm IN (SELECT TermId
                   FROM term
				   WHERE TermId = 'WN03');










--Question 14:

SELECT c.CourseId, c.Section, f.Name
FROM crssection c LEFT JOIN faculty f
USING (FacultyId)
ORDER BY Name;







--Question 15:

SELECT Name
FROM faculty
WHERE RoomId IN (SELECT RoomId
                FROM location
				WHERE Building = 'Gandhi');







--Question 16:

SELECT Name
FROM faculty
WHERE RoomId IN (SELECT RoomId
                FROM location
				WHERE Building = 'Gandhi' AND RoomId = 17)
				AND Name <> 'Collins';







--Question 17:

SELECT First, Last
FROM student
WHERE FacultyId = (SELECT FacultyId
                   FROM department
				   WHERE DeptName = 'Accounting');
				   
				   
				   
				   
				   
				   
				   
				   
				   

--Question 1:

SELECT DeptName
FROM dept
WHERE DeptId = (SELECT DeptId
                FROM employee
				WHERE FName = 'Jinku' AND LName = 'Shaw');


				
SELECT DeptName
FROM dept d, employee e
WHERE d.DeptId = e.DeptId AND e.FName = 'Jinku' AND e.LName = 'Shaw';
				

				
				
				
				
--Question 2:

SELECT FName, LName
FROM employee
WHERE EmployeeId = (SELECT Supervisor
                    FROM employee
					WHERE EmployeeId = 433);


					
SELECT FNAME, LNAME
FROM EMPLOYEE E, EMPLOYEE S
WHERE E.EMPLOYEEID = S.SUPERVISOR AND E.EMPLOYEEID = 433;

					
					

					
--Question 3:

SELECT FName, LName
FROM employee
WHERE QualId = (SELECT QualId
                FROM employee
				WHERE FName = 'John' AND LName = 'Smith')
				AND FName <> 'John' AND LName <> 'Smith';




				

--Question 4:

SELECT FName, LName
FROM employee
WHERE PositionId = (SELECT PositionId
                    FROM employee
					WHERE FName = 'Larry' AND LName = 'Houston')
                    AND FName <> 'Larry' AND LName <> 'Houston';





--Question 5:

SELECT DeptName
FROM dept
WHERE DeptId = (SELECT DeptId
                FROM employee 
				GROUP BY DeptId
				HAVING COUNT(*) > (SELECT COUNT(*)
								   FROM employee
								   WHERE DeptId = 20));


											

--Question 6:

SELECT FName, LName
FROM employee
WHERE HireDate < (SELECT HireDate
                  FROM employee
				  WHERE FName = 'Larry' AND LName = 'Houston');






--Question 7:

SELECT FName, LName
FROM employee
WHERE DeptId = (SELECT DeptId
                FROM dept
				WHERE DeptName = 'Sales');







--Question 8:

SELECT EmployeeId, DependentId, DepDOB, Relation
FROM dependent
WHERE EmployeeId IN (SELECT EmployeeId
                     FROM employee
				     WHERE DeptId = (SELECT DeptId
                                     FROM dept
				                     WHERE DeptName = 'Finance'));


								
								
SELECT EmployeeId, DependentId, DepDOB, Relation
FROM dependent d, employee e, dept de
WHERE d.EmployeeId = e.EmployeeId AND e.DeptId = de.DeptId AND de.DeptName = 'Finance';






--Question 9:

SELECT Name, Phone
FROM faculty
WHERE FacultyId = (SELECT FacultyId
                   FROM student
				   WHERE Last = 'Diaz');







--Question 10:

SELECT * 
FROM location
WHERE RoomType = (SELECT RoomType
                  FROM room
				  WHERE RoomDesc = 'Classroom');


				  
				  
				  
				  
				  
				  
				  
				  

				  

--Question 1:

SELECT * FROM LOCATION;




--Question 2:

SELECT COUNT(roomid)
FROM LOCATION;





--Question 3:

SELECT * FROM EMPLOYEE;





--Question 4:

SELECT AVG(TRUNC((SYSDATE - HireDate) / 365.25)), MAX(TRUNC((SYSDATE - HireDate) / 365.25)), MIN(TRUNC((SYSDATE - HireDate) / 365.25))
FROM EMPLOYEE;





--Question 5:

SELECT * FROM DEPENDENT;





--Question 6:

SELECT EmployeeId, COUNT(EmployeeId)
FROM DEPENDENT
GROUP BY EmployeeId
HAVING COUNT(EmployeeId) >= 2;





--Question 7:


--a)

SELECT AVG(Commission)
FROM EMPLOYEE
WHERE Commission IS NOT NULL;


--b)

SELECT AVG(NVL(Commission, 0))
FROM EMPLOYEE;






--Question 8:

SELECT * FROM CRSSECTION;






--Question 9:

SELECT TermId, CourseId, SUM(MaxCount)
FROM CRSSECTION
GROUP BY TermId, CourseId;






--Question 10:

SELECT * FROM FACULTY;






--Question 11:

SELECT DeptId, COUNT(FacultyId)
FROM FACULTY
GROUP BY DeptId;





--Question 12:

SELECT DeptId, AVG(Salary)
FROM EMPLOYEE
GROUP BY DeptId;






--Question 13:

SELECT DeptId, AVG(Salary)
FROM EMPLOYEE
GROUP BY DeptId
HAVING AVG(Salary) >= 75000;






--Question 14:

COLUMN SalaryFormat FORMAT $999,999.99
SELECT EmployeeId, UPPER(Lname||' '||Fname), Salary SalaryFormat, Salary/100
FROM EMPLOYEE
ORDER BY Salary DESC;





--Question 15:

SELECT Lname, Fname, TO_CHAR(HireDate, 'DD-MON-YYYY')
FROM EMPLOYEE
ORDER BY Lname ASC;






--Question 16:

SELECT Lname, Fname, TO_CHAR(HireDate, 'YYYY')
FROM EMPLOYEE
ORDER BY Lname ASC;





--Question 17:

SELECT '####'||POWER(2, 10)
FROM DUAL;






--Question 18:

COLUMN Years FORMAT 999
SELECT EmployeeId, Lname, Fname, FLOOR((SYSDATE - HireDate)/ 365) Years
FROM EMPLOYEE;





--Question 19:

COLUMN Years FORMAT 999
SELECT EmployeeId, Lname, Fname, FLOOR((SYSDATE - HireDate)/ 365) Years
FROM EMPLOYEE
WHERE FLOOR((SYSDATE - HireDate)/ 365) >= 20;






--Question 20:

SELECT Fname, Lname, TO_CHAR(HireDate, 'MON')
FROM EMPLOYEE
WHERE TO_CHAR(HireDate, 'MON') = 'MAY';













--A: Character: Upper, Lower, InitCap



--Question 1:

SELECT UPPER(last_name), LOWER(first_name), INITCAP(first_name||' '||last_name) 
FROM employees;





--Question 2:

SELECT *
FROM departments
ORDER BY department_name;





--Question 3:

SELECT *
FROM departments
ORDER BY LENGTH(department_name);





--Question 4:

SELECT department_name
FROM departments
HAVING LENGTH(department_name) = MAX(LENGTH(department_name))
GROUP BY department_name;





--Question 5:

SELECT last_name, first_name, LPAD(salary, 7, '$')
FROM employees;





--Question 6:

SELECT last_name, first_name, LPAD(salary, 7, '*')
FROM employees;










--B: Numeric Functions


--Question 7:

SELECT ROUND(5.55, 1), TRUNC(5.55), POWER(2,3), FLOOR(5.5), CEIL(5.5)
FROM dual;


DESCRIBE dual
SELECT * FROM dual;









--C: Dates


--Question 8:

SELECT SYSDATE
FROM dual;


SELECT TO_CHAR(SYSDATE, 'DY, MONTH DD, YYYY HH:MI:SS P.M.')
FROM dual;


SELECT TO_CHAR(SYSDATE, 'Day, MONTH DD, YYYY HH:MI:SS A.M.')
FROM dual;






--Question 9:

SELECT SYSDATE + 32
FROM dual;






--Question 10:

SELECT TO_DATE('8-NOV-15', 'DD-MON-YY') - SYSDATE
FROM dual;





--Question 11:

SELECT SYSDATE - TO_DATE('20-AUG-15', 'DD-MON-YY')
FROM dual;





--Question 12:

SELECT last_name, first_name, TRUNC((SYSDATE - hire_date) / 365.24) AS "Seniority"
FROM employees;









--D: Handling Null Values


--Question 13:

SELECT employee_id, salary, commission_pct,
salary * (1 + commission_pct / 100) AS "Total Compensation"
FROM employees;


SELECT employee_id, salary, commission_pct,
salary * (1 + NVL(commission_pct, 0) / 100) AS "Total Compensation"
FROM employees;





--Question 14:

SELECT employee_id, last_name, first_name,
NVL2(commission_pct, 'earns commission', 'no commission')
FROM employees;








--E: Conversion Functions




--Question 15:

SELECT employee_id, TO_CHAR(salary / 31, '$999,999.99') AS "Daily Salary"
FROM employees;





--Question 16:

SELECT last_name, first_name, TO_CHAR(hire_date, 'Month DD, YYYY') AS "Hire Date"
FROM employees;






--Question 17:

SELECT last_name, first_name, TO_CHAR(hire_date, 'DD Mon YYYY') AS "HireDate"
FROM employees;









