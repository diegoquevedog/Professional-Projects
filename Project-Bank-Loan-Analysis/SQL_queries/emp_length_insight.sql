-- QUERY 2: EMPLOYEE LENGTH INSIGHTS ANALYSIS


WITH b AS (SELECT * FROM `bank-loan-project-472713.bank_loan_proyect.loan` 
WHERE issue_date IS NOT NULL),

emp_length_insight AS (
  SELECT 
    emp_length,
    COUNT(*) AS number_loans,
    SUM(COALESCE(loan_amount,0)) AS total_amount,
    SUM(COALESCE(total_payment,0)) AS total_payment,
    ROUND(SUM(COALESCE(installment,0)), 2) AS total_installment,
    ROUND(AVG(COALESCE(int_rate,0)) * 100, 2) AS avg_interest_rate,
    ROUND(AVG(COALESCE(annual_income,0)), 2) AS avg_anual_income,
    ROUND(AVG(COALESCE(dti,0)) * 100, 2) AS avg_dti_rate,

    -- Total loan per term
    SUM(CASE WHEN TRIM(UPPER(COALESCE(term, ''))) = '36 MONTHS' THEN 1 ELSE 0 END) AS total_loans_36m,
    SUM(CASE WHEN TRIM(UPPER(COALESCE(term, ''))) = '60 MONTHS' THEN 1 ELSE 0 END) AS total_loans_60m,

    -- Ratios per loan term
    ROUND((SUM(CASE WHEN TRIM(UPPER(COALESCE(term, ''))) = '36 MONTHS' THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0)) * 100, 2) AS total_loans_36m_ratio,
    ROUND((SUM(CASE WHEN TRIM(UPPER(COALESCE(term, ''))) = '60 MONTHS' THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0)) * 100, 2) AS total_loans_60m_ratio,

    SUM(CASE WHEN TRIM(UPPER(COALESCE(home_ownership, ''))) = 'MORTGAGE' THEN 1 ELSE 0 END) AS total_mortgage_loans,
    SUM(CASE WHEN TRIM(UPPER(COALESCE(home_ownership, ''))) = 'OWN' THEN 1 ELSE 0 END) AS total_own_loans,
    SUM(CASE WHEN TRIM(UPPER(COALESCE(home_ownership, ''))) = 'RENT' THEN 1 ELSE 0 END) AS total_rent_loans,
    SUM(CASE WHEN TRIM(UPPER(COALESCE(home_ownership, ''))) IN ('OTHER','NONE') THEN 1 ELSE 0 END) AS total_other_loans,
    -- Ratio Good Loan Status and amount
    SUM(CASE WHEN TRIM(UPPER(COALESCE(loan_status, ''))) IN ('FULLY PAID','CURRENT') THEN 1 ELSE 0 END) AS good_loan_applications,
    ROUND((SUM(CASE WHEN TRIM(UPPER(COALESCE(loan_status, ''))) IN ('FULLY PAID','CURRENT') THEN 1 ELSE 0 END)/NULLIF(COUNT(*),0)) * 100, 2) AS good_loan_applications_ratio,
    -- Ratio Bad Loan Status and amount
    SUM(CASE WHEN TRIM(UPPER(COALESCE(loan_status, ''))) = 'CHARGED OFF' THEN 1 ELSE 0 END) AS bad_loan_applications,
    ROUND((SUM(CASE WHEN TRIM(UPPER(COALESCE(loan_status, ''))) = 'CHARGED OFF' THEN 1 ELSE 0 END)/NULLIF(COUNT(*),0)) * 100, 2) AS bad_loan_applications_ratio,
    -- Ratio Verification and amount
    SUM(CASE WHEN TRIM(UPPER(COALESCE(verification_status, ''))) IN ('VERIFIED','SOURCE VERIFIED') THEN 1 ELSE 0 END) AS total_verified_loan,
    ROUND((SUM(CASE WHEN TRIM(UPPER(COALESCE(verification_status, ''))) IN ('VERIFIED','SOURCE VERIFIED') THEN 1 ELSE 0 END)/NULLIF(COUNT(*),0)) * 100, 2) AS total_verified_loan_ratio,
    -- Ratio Verification and amount
    SUM(CASE WHEN TRIM(UPPER(COALESCE(verification_status, ''))) = 'NOT VERIFIED' THEN 1 ELSE 0 END) AS total_notverified_loan,
    ROUND((SUM(CASE WHEN TRIM(UPPER(COALESCE(verification_status, ''))) = 'NOT VERIFIED' THEN 1 ELSE 0 END)/NULLIF(COUNT(*),0)) * 100, 2) AS total_notverified_loan_ratio,
    -- Monitor missing values
    SUM(CASE WHEN loan_amount IS NULL THEN 1 ELSE 0 END) AS missing_loan_amounts,
    SUM(CASE WHEN annual_income IS NULL THEN 1 ELSE 0 END) AS missing_income,
    SUM(CASE WHEN term IS NULL THEN 1 ELSE 0 END) AS missing_terms



  FROM b
  WHERE issue_date IS NOT NULL
 GROUP BY emp_length
 
 
)

SELECT * FROM emp_length_insight
ORDER BY
 CASE WHEN TRIM(emp_length) = '< 1 year' THEN 0
      WHEN TRIM(emp_length) = '1 year' THEN 1
      WHEN TRIM(emp_length) = '2 year' THEN 2
      WHEN TRIM(emp_length) = '3 year' THEN 3
      WHEN TRIM(emp_length) = '4 year' THEN 4
      WHEN TRIM(emp_length) = '5 year' THEN 5
      WHEN TRIM(emp_length) = '6 year' THEN 6
      WHEN TRIM(emp_length) = '7 year' THEN 7
      WHEN TRIM(emp_length) = '8 year' THEN 8
      WHEN TRIM(emp_length) = '9 year' THEN 9
      WHEN TRIM(emp_length) = '10+ year' THEN 10
      ELSE 11
      END;