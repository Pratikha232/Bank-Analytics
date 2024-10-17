use bank;
select * from finance_1;
select * from finance_2;

/*KPI-1 Year Wise Loan Amount Stats */
WITH YearlyLoanAmount AS (SELECT year(date_format(str_to_date(issue_d,'%d-%m-%Y'),'%Y-%m-%d')) AS Loan_Year,CONCAT(ROUND(SUM(loan_amnt)/1000000,2)," M") as Total_Loan_Amount 
FROM finance_1 GROUP BY Loan_year),YearlyChange AS (SELECT Loan_Year,Total_Loan_Amount,LAG(Total_Loan_Amount) OVER (ORDER BY Loan_Year) AS Previous_Year_Amount FROM 
YearlyLoanAmount) SELECT Loan_Year,Total_Loan_Amount,CONCAT(ROUND((Total_Loan_Amount-Previous_Year_Amount)/Previous_Year_Amount*100,0),"%") AS YoY_Percent_Change FROM 
YearlyChange

/*KPI-2 Grade and Sub grade wise revol_bal */
select f1.grade,f1.sub_grade,concat(round(sum(f2.revol_bal)/1000000,2)," M") as revolving_bal from finance_1 as f1 inner join finance_2 as f2 on f1.id=f2.ï»¿id group by 1,2
order by 1;
 
/*KPI-3 Total Payment for Verified Status Vs Total Payment for Non Verified Status */
select f1.verification_status,concat(round(sum(f2.total_pymnt)/1000000,2)," M") as total_pymnt from finance_1 as f1 inner join finance_2 as f2 on f1.id=f2.ï»¿id 
where f1.verification_status in ("Verified","Not Verified") group by f1.verification_status;

 /*KPI-4 State wise and month wise loan status */
 select addr_state,Year(date_format(str_to_date(issue_d,'%d-%m-%Y'),'%Y-%m-%d')) as Year,date_format(str_to_date(issue_d,'%d-%m-%Y'),'%b') as Month,loan_status,
 count(loan_status) from finance_1 group by 1,2,3,4 order by 1;
 
/*KPI-5 Home ownership Vs last payment date stats */
SELECT f1.home_ownership,COUNT(f2.last_pymnt_d) FROM finance_1 AS f1 INNER JOIN finance_2 AS f2 ON f1.id = f2.ï»¿id WHERE f2.last_pymnt_d IS NOT NULL AND 
f2.last_pymnt_d != '' GROUP BY 1 ORDER BY 2 desc;


