-- QUERY 3: GRADE INSIGHTS ANALYSIS

WITH b AS (
  SELECT * 
  FROM `bank-loan-project-472713.bank_loan_proyect.loan` 
  WHERE issue_date IS NOT NULL
),


total_counts AS (
  SELECT COUNT(*) AS total_loans FROM b
),

grade_rates AS (
  SELECT
    grade,
    sub_grade,
    COUNT(*) AS number_loans,
    SUM(COALESCE(loan_amount,0)) AS total_amount,
    SUM(COALESCE(total_payment,0)) AS total_payment,
    ROUND(SUM(COALESCE(installment,0)), 2) AS total_installment,
    ROUND(AVG(COALESCE(int_rate,0)) * 100, 2) AS avg_interest_rate,
    ROUND(AVG(COALESCE(annual_income,0)), 2) AS avg_anual_income,
    ROUND(AVG(COALESCE(dti,0)) * 100, 2) AS avg_dti_rate,
    ROUND(SAFE_DIVIDE(SUM(COALESCE(total_payment, 0) - COALESCE(loan_amount, 0)),SUM(COALESCE(loan_amount, 0)))*100,2) AS roi_rate,
    
    -- Total loan per term
    SUM(CASE WHEN TRIM(UPPER(COALESCE(term, ''))) = '36 MONTHS' THEN 1 ELSE 0 END) AS total_loans_36m,
    SUM(CASE WHEN TRIM(UPPER(COALESCE(term, ''))) = '60 MONTHS' THEN 1 ELSE 0 END) AS total_loans_60m,

    -- Ratios per loan term
    ROUND(SAFE_DIVIDE(SUM(CASE WHEN TRIM(UPPER(COALESCE(term, ''))) = '36 MONTHS' THEN 1 ELSE 0 END),COUNT(*)) * 100, 2) AS total_loans_36m_rate,
    ROUND(SAFE_DIVIDE(SUM(CASE WHEN TRIM(UPPER(COALESCE(term, ''))) = '60 MONTHS' THEN 1 ELSE 0 END),COUNT(*)) * 100, 2) AS total_loans_60m_rate,

    SUM(CASE WHEN TRIM(UPPER(COALESCE(home_ownership, ''))) = 'MORTGAGE' THEN 1 ELSE 0 END) AS total_mortgage_loans,
    SUM(CASE WHEN TRIM(UPPER(COALESCE(home_ownership, ''))) = 'OWN' THEN 1 ELSE 0 END) AS total_own_loans,
    SUM(CASE WHEN TRIM(UPPER(COALESCE(home_ownership, ''))) = 'RENT' THEN 1 ELSE 0 END) AS total_rent_loans,
    SUM(CASE WHEN TRIM(UPPER(COALESCE(home_ownership, ''))) IN ('OTHER','NONE') THEN 1 ELSE 0 END) AS total_other_loans,
    
    -- Good Loan Status
    SUM(CASE WHEN TRIM(UPPER(COALESCE(loan_status, ''))) IN ('FULLY PAID','CURRENT') THEN 1 ELSE 0 END) AS good_loan_applications,
    ROUND(SAFE_DIVIDE(SUM(CASE WHEN TRIM(UPPER(COALESCE(loan_status, ''))) IN ('FULLY PAID','CURRENT') THEN 1 ELSE 0 END),COUNT(*)) * 100, 2) AS good_loan_applications_rate,
    
    -- Bad Loan Status
    SUM(CASE WHEN TRIM(UPPER(COALESCE(loan_status, ''))) = 'CHARGED OFF' THEN 1 ELSE 0 END) AS default_applications,
    ROUND(SAFE_DIVIDE(SUM(CASE WHEN TRIM(UPPER(COALESCE(loan_status, ''))) = 'CHARGED OFF' THEN 1 ELSE 0 END),COUNT(*)) * 100, 2) AS default_rate,
    
    -- Verification status
    SUM(CASE WHEN TRIM(UPPER(COALESCE(verification_status, ''))) IN ('VERIFIED','SOURCE VERIFIED') THEN 1 ELSE 0 END) AS total_verified_loan,
    ROUND(SAFE_DIVIDE(SUM(CASE WHEN TRIM(UPPER(COALESCE(verification_status, ''))) IN ('VERIFIED','SOURCE VERIFIED') THEN 1 ELSE 0 END),COUNT(*)) * 100, 2) AS total_verified_loan_rate,
    SUM(CASE WHEN TRIM(UPPER(COALESCE(verification_status, ''))) = 'NOT VERIFIED' THEN 1 ELSE 0 END) AS total_notverified_loan,
    ROUND(SAFE_DIVIDE(SUM(CASE WHEN TRIM(UPPER(COALESCE(verification_status, ''))) = 'NOT VERIFIED' THEN 1 ELSE 0 END),COUNT(*)) * 100, 2) AS total_notverified_loan_rate,
    
    -- Missing values
    SUM(CASE WHEN loan_amount IS NULL THEN 1 ELSE 0 END) AS missing_loan_amounts,
    SUM(CASE WHEN annual_income IS NULL THEN 1 ELSE 0 END) AS missing_income,
    SUM(CASE WHEN term IS NULL THEN 1 ELSE 0 END) AS missing_terms

  FROM b
  WHERE issue_date IS NOT NULL
  GROUP BY grade, sub_grade
)


SELECT 
  *,
  ROUND(
    SAFE_DIVIDE(default_applications, (SELECT total_loans FROM total_counts)) * 100,
    2
  ) AS contribution_to_total_default_rate,

  -- Running total for labels
  SUM(
    ROUND(
      SAFE_DIVIDE(default_applications, (SELECT total_loans FROM total_counts)) * 100,
      2
    )
  ) OVER (ORDER BY grade, sub_grade ROWS UNBOUNDED PRECEDING) AS running_total_default_rate

FROM grade_rates
ORDER BY grade, sub_grade;




