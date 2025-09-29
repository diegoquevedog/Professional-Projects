-- QUERY 6: CUSTOMER SEGMENTATION INSIGHTS ANALYSIS

WITH b AS (SELECT * FROM `bank-loan-project-472713.bank_loan_proyect.loan` 
WHERE issue_date IS NOT NULL),

income_segments AS (
  SELECT
  *,
  CASE WHEN annual_income < 40000 THEN 'Low Income'
        WHEN annual_income < 75000 THEN 'Meddle Income'
        WHEN annual_income < 1200000 THEN 'Hight Income'
        ELSE 'Very Hight Income'
        END income_segment

  FROM b
)

SELECT
income_segment,
COUNT(*) AS total_loans,
ROUND(AVG(COALESCE(loan_amount,0)),2) AS avg_loan_amount,
AVG(COALESCE(int_rate,0)) AS avg_interest_rate,
ROUND((SUM(CASE WHEN TRIM(UPPER(COALESCE(loan_status, ''))) = 'CHARGED OFF' THEN 1 ELSE 0 END) / COUNT(*))*100,2) AS default_rate,
AVG(COALESCE(dti,0)) AS avg_dti_rate,


FROM income_segments
GROUP BY income_segment
ORDER BY 
  CASE income_segment 
      WHEN 'Low Income' THEN 1
      WHEN 'Middle Income' THEN 2
      WHEN 'High Income' THEN 3
      WHEN 'Very High Income' THEN 4
    END;