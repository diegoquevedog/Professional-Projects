-- QUERY 7: CUSTOMER SEGMENTATION INSIGHTS ANALYSIS

WITH b AS (SELECT * FROM `bank-loan-project-472713.bank_loan_proyect.loan` 
WHERE issue_date IS NOT NULL),

cohorts AS(
  SELECT
  DATE_TRUNC(issue_date, MONTH) AS cohort_month,
  loan_status,
  COUNT(*) AS loan_count,
  AVG(total_payment/loan_amount) AS avg_payment_ratio
  FROM b
  GROUP BY cohort_month, loan_status
)

SELECT
cohort_month,
SUM(loan_count) AS total_loans,
SUM(CASE WHEN TRIM(UPPER(COALESCE(loan_status,''))) = 'FULLY PAID' THEN loan_count ELSE 0 END) / SUM(COALESCE(loan_count,0)) AS fully_paid_rate
FROM cohorts
GROUP BY cohort_month
ORDER BY cohort_month;
