-- QUERY 8: KPIS INSIGHTS ANALYSIS

WITH b AS (SELECT * FROM `bank-loan-project-472713.bank_loan_proyect.loan` 
WHERE issue_date IS NOT NULL),

kpis AS(
  SELECT
  SUM(loan_amount) AS total_loan,
  SUM(total_payment) AS total_payment,
  AVG(annual_income) AS avg_annual_income,
  AVG(loan_amount) AS avg_loan,
  AVG(total_payment) AS avg_payment,
  AVG(int_rate) AS avg_interest_rate,
  AVG(dti) AS avg_dti_rate,
  ROUND(SUM(CASE WHEN TRIM(UPPER(COALESCE(loan_status,''))) = 'CHARGED OFF' THEN 1 ELSE 0 END)/ COUNT(*),2) AS avg_default_rate,
  COUNT(*) AS number_loan,

  FROM b
)

SELECT
*
FROM kpis;
