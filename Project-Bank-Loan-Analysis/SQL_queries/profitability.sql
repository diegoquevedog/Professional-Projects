-- QUERY 5: PROFITABILITY INSIGHTS ANALYSIS

WITH b AS (SELECT * FROM `bank-loan-project-472713.bank_loan_proyect.loan` 
WHERE issue_date IS NOT NULL),

profitability AS (
  SELECT 
  grade,
  term,
  COUNT(*) AS total_loans,
  SUM(COALESCE(total_payment, 0)) AS total_payment,
  SUM(COALESCE(loan_amount, 0)) AS total_loan,
  SUM(COALESCE(total_payment, 0) - COALESCE(loan_amount, 0)) AS net_profit,
  CONCAT(ROUND((SUM(COALESCE(total_payment, 0) - COALESCE(loan_amount, 0)) / SUM(COALESCE(loan_amount, 0)))*100,2),'%') AS roi_rate,
  AVG(CASE WHEN TRIM(UPPER(COALESCE(loan_status, ''))) = 'CHARGED OFF' THEN loan_amount-total_payment ELSE 0 END)  AS avg_losses_per_default
  FROM b
  GROUP BY grade, term
  ORDER BY grade, term
)

SELECT * FROM profitability