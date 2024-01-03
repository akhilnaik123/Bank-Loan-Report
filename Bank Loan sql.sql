select*
from financial_loan;

---Total_Loan_Applications
SELECT COUNT(id) Total_Loan_Applications
FROM financial_loan;

---MTD_Loan_Application
SELECT COUNT(id) AS MTD_Loan_Application
FROM financial_loan
WHERE MONTH(issue_date) = (SELECT MONTH(MAX(issue_date)) FROM financial_loan)
      AND
      YEAR(issue_date) = (SELECT YEAR(MAX(issue_date)) FROM financial_loan)

---Previous MTD_Loan_Application
SELECT COUNT(id) AS PMTD_Loan_Application
FROM financial_loan
WHERE MONTH(issue_date) = (SELECT MONTH(MAX(issue_date))-1 FROM financial_loan)
      AND
      YEAR(issue_date) = (SELECT YEAR(MAX(issue_date)) FROM financial_loan) 
	  
---MOM Percentage(with present and previous month)

WITH cte1 as(
SELECT COUNT(id) AS Loan_Application
FROM financial_loan
WHERE MONTH(issue_date) = (SELECT MONTH(MAX(issue_date)) FROM financial_loan)
      AND
      YEAR(issue_date) = (SELECT YEAR(MAX(issue_date)) FROM financial_loan)),
cte2 as(
SELECT COUNT(id) AS PMTD_Loan_Application
FROM financial_loan
WHERE MONTH(issue_date) = (SELECT MONTH(MAX(issue_date))-1 FROM financial_loan)
      AND
      YEAR(issue_date) = (SELECT YEAR(MAX(issue_date)) FROM financial_loan))
SELECT 
  CASE WHEN PMTD_Loan_Application = 0 THEN NULL
	   ELSE (cast (cte1.Loan_Application as decimal) - cte2.PMTD_Loan_Application)/ cte2.PMTD_Loan_Application
	   END AS MOM
	   FROM cte1, cte2;

---Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount
FROM financial_loan

---MTD Total Funded Amount
SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM financial_loan
WHERE MONTH(issue_date)= (SELECT MONTH(MAX(issue_date)) FROM financial_loan)
      AND
	  YEAR(issue_date) =  (SELECT YEAR(MAX(issue_date)) FROM financial_loan)

---PMTD Total Funded Amount

SELECT SUM(loan_amount) as PMTD_Amount
FROM financial_loan
WHERE MONTH(issue_date) = (SELECT MONTH(MAX(issue_date))-1 FROM financial_loan)


---MOM Total Funded Amount

WITH cte1 as(
SELECT COUNT(id) AS MTD_Total_Funded_Amount
FROM financial_loan
WHERE MONTH(issue_date) = (SELECT MONTH(MAX(issue_date)) FROM financial_loan)
      AND
      YEAR(issue_date) = (SELECT YEAR(MAX(issue_date)) FROM financial_loan)),
cte2 as(
SELECT COUNT(id) AS PMTD_Amount
FROM financial_loan
WHERE MONTH(issue_date) = (SELECT MONTH(MAX(issue_date))-1 FROM financial_loan)
      AND
      YEAR(issue_date) = (SELECT YEAR(MAX(issue_date)) FROM financial_loan))
SELECT
      CASE WHEN PMTD_Amount =0 THEN NULL
	  ELSE (CAST (cte1.MTD_Total_Funded_Amount as decimal))-cte2.PMTD_Amount/cte2.PMTD_Amount
	  END AS MOM_LOAN
FROM  cte1,cte2

---Total Funded Amount
SELECT SUM(total_payment) AS Total_Amount_Received
FROM financial_loan

---MTD Total Total Amount Received
SELECT SUM(total_payment) AS MTD_Total_Amount_Received
FROM financial_loan
WHERE MONTH(issue_date)= (SELECT MONTH(MAX(issue_date)) FROM financial_loan)
      AND
	  YEAR(issue_date) =  (SELECT YEAR(MAX(issue_date)) FROM financial_loan)

	  ---PMTD Total Total Amount Received
SELECT SUM(total_payment) AS PMTD_Total_Amount_Received
FROM financial_loan
WHERE MONTH(issue_date)= (SELECT MONTH(MAX(issue_date)) -1 FROM financial_loan)
      AND
	  YEAR(issue_date) =  (SELECT YEAR(MAX(issue_date)) FROM financial_loan)

---MOM

	  WITH cte1 as(
SELECT SUM(total_payment) AS MTD_Total_Amount_Received
FROM financial_loan
WHERE MONTH(issue_date)= (SELECT MONTH(MAX(issue_date)) FROM financial_loan)
      AND
	  YEAR(issue_date) =  (SELECT YEAR(MAX(issue_date)) FROM financial_loan)),
cte2 as(
SELECT SUM(total_payment) AS PMTD_Total_Amount_Received
FROM financial_loan
WHERE MONTH(issue_date)= (SELECT MONTH(MAX(issue_date)) -1 FROM financial_loan)
      AND
	  YEAR(issue_date) =  (SELECT YEAR(MAX(issue_date)) FROM financial_loan))
SELECT
      CASE WHEN PMTD_Total_Amount_Received =0 THEN NULL
	  ELSE (CAST (cte1.MTD_Total_Amount_Received as decimal))-cte2.PMTD_Total_Amount_Received/cte2.PMTD_Total_Amount_Received
	  END AS MOM_Received
FROM  cte1,cte2


---Average interest rate

SELECT ROUND(avg(int_rate),4)*100 as Average_interest_rate
FROM financial_loan

---MTD Average interest rate

SELECT ROUND(avg(int_rate),4)*100 as MTD_Average_interest_rate
FROM financial_loan
WHERE MONTH(issue_date) = (SELECT MONTH(MAX(issue_date)) FROM financial_loan)

---PMTD Average interest rate

SELECT ROUND(avg(int_rate),4)*100 as PMTD_Average_interest_rate
FROM financial_loan
WHERE MONTH(issue_date) = (SELECT MONTH(MAX(issue_date))-1 FROM financial_loan)

---MOM Average interest rate

WITH CTE1 AS(
SELECT ROUND(avg(int_rate),4)*100 as MTD_Average_interest_rate
FROM financial_loan
WHERE MONTH(issue_date) = (SELECT MONTH(MAX(issue_date)) FROM financial_loan)),
CTE2 AS(
SELECT ROUND(avg(int_rate),4)*100 as PMTD_Average_interest_rate
FROM financial_loan
WHERE MONTH(issue_date) = (SELECT MONTH(MAX(issue_date))-1 FROM financial_loan))
SELECT
      CASE WHEN PMTD_Average_interest_rate =0 THEN NULL
	  ELSE (CAST (cte1.MTD_Average_interest_rate as decimal))-cte2.PMTD_Average_interest_rate/cte2.PMTD_Average_interest_rate
	  END AS MOM_Average_interest
FROM  cte1,cte2


---AVERAGE DTI
SELECT ROUND(avg(dti),4)*100 as Average_dti
FROM financial_loan


---MTD Average DTI
SELECT ROUND(avg(dti),4)*100 as mtd_Average_dti
FROM financial_loan
WHERE MONTH(issue_date)= (SELECT MONTH(MAX(issue_date)) FROM financial_loan)

---MTD Average DTI
SELECT ROUND(avg(dti),4)*100 as pmtd_Average_dti
FROM financial_loan
WHERE MONTH(issue_date)= (SELECT MONTH(MAX(issue_date))-1 FROM financial_loan)

---MOM Average DTI
with cte1 as
(SELECT ROUND(avg(dti),4)*100 as mtd_Average_dti
FROM financial_loan
WHERE MONTH(issue_date)= (SELECT MONTH(MAX(issue_date)) FROM financial_loan)),
cte2 as(
SELECT ROUND(avg(dti),4)*100 as pmtd_Average_dti
FROM financial_loan
WHERE MONTH(issue_date)= (SELECT MONTH(MAX(issue_date))-1 FROM financial_loan))
SELECT 
  CASE WHEN cte2.pmtd_Average_dti=0 THEN NULL
  ELSE CAST(cte1.mtd_Average_dti AS decimal)-cte2.pmtd_Average_dti/pmtd_Average_dti
  END AS MOM_DTI
  FROM cte1,cte2




  ---GOOD LOAN

  ---Good Loan Application Percentage
  SELECT
  COUNT(case when loan_status IN ( 'Fully Paid','Current') then id end)*100/count(id) as good_loan_percent
  FROM financial_loan

  ---Good Loan Applications
  SELECT COUNT(id) as Good_Loan_Applications
  FROM financial_loan
  WHERE loan_status IN ( 'Fully Paid','Current')

  ---Good Loan Funded Amount
    SELECT sum(loan_amount) as Good_Loan_Funded_Amount
    FROM financial_loan
    WHERE loan_status IN ( 'Fully Paid','Current')

---4.	Good Loan Total Received Amount

    SELECT sum(total_payment) as Good_Loan_Total_Received_Amount
    FROM financial_loan
    WHERE loan_status IN ( 'Fully Paid','Current')
	

---BAD LOAN

  ---BAD Loan Application Percentage
  SELECT
  COUNT(case when loan_status IN ( 'Charged Off') then id end)*100/count(id) as Bad_loan_percent
  FROM financial_loan

  ---Bad Loan Applications
  SELECT COUNT(id) as Bad_Loan_Applications
  FROM financial_loan
  WHERE loan_status IN ( 'Charged Off')

  ---Bad Loan Funded Amount
    SELECT sum(loan_amount) as Bad_Loan_Funded_Amount
    FROM financial_loan
    WHERE loan_status IN ( 'Charged Off')

---4.	Bad Loan Total Received Amount

    SELECT sum(total_payment) as Bad_Loan_Total_Received_Amount
    FROM financial_loan
    WHERE loan_status IN ( 'Charged Off')


----LOAN STATUS

SELECT loan_status,
       COUNT(id) as Total_Loan_Count,
	   SUM(loan_amount) as Amount_Funded,
	   SUM(total_payment) as Amount_Received,
	   Round(AVG(int_rate),4)*100 as Interest_Rate,
	   ROUND(AVG(dti),4)*100 as DTI
FROM financial_loan
GROUP BY loan_status

---MTD Amount Received and Amount Funded

SELECT loan_status,
       SUM(loan_amount) as MTD_Loan_Funded,
	   SUM(total_payment) as MTD_Loan_Received
FROM financial_loan
WHERE MONTH(issue_date)= (SELECT MONTH(MAX(issue_date)) FROM financial_loan)
GROUP BY loan_status

---

SELECT MONTH(issue_date) as Month_of_issue,
       DATENAME(MONTH, issue_date) as issue_month,
	   COUNT(id) as Total_Loan_Application,
	   SUM(loan_amount) as Amount_Funded,
	   SUM(total_payment) as Amount_Received
FROM financial_loan
GROUP BY MONTH(issue_date) ,
         DATENAME(MONTH, issue_date) 
ORDER BY MONTH(issue_date) 


---wrt states

SELECT address_state,
	   COUNT(id) as Total_Loan_Application,
	   SUM(loan_amount) as Amount_Funded,
	   SUM(total_payment) as Amount_Received
FROM financial_loan
GROUP BY address_state 
ORDER BY address_state 

---wrt term

SELECT term as loan_term,
	   COUNT(id) as Total_Loan_Application,
	   SUM(loan_amount) as Amount_Funded,
	   SUM(total_payment) as Amount_Received
FROM financial_loan
GROUP BY term
ORDER BY term 

---wrt employee experiance

SELECT emp_length as employee_experiance,
	   COUNT(id) as Total_Loan_Application,
	   SUM(loan_amount) as Amount_Funded,
	   SUM(total_payment) as Amount_Received
FROM financial_loan
GROUP BY emp_length
ORDER BY emp_length 


---wrt loan purpose

SELECT purpose as loan_purpose,
	   COUNT(id) as Total_Loan_Application,
	   SUM(loan_amount) as Amount_Funded,
	   SUM(total_payment) as Amount_Received
FROM financial_loan
GROUP BY purpose 
ORDER BY purpose 

---wrt home ownership

SELECT home_ownership as home_owners,
	   COUNT(id) as Total_Loan_Application,
	   SUM(loan_amount) as Amount_Funded,
	   SUM(total_payment) as Amount_Received
FROM financial_loan
GROUP BY home_ownership 
ORDER BY COUNT(id) desc



