-- ============================================================
-- PROJECT 3: Churn Analysis — Telecom Dataset
-- Dataset: https://www.kaggle.com/datasets/blastchar/telco-customer-churn
-- Tool: MySQL / PostgreSQL / SQLite
-- Author: Caio Breder Bernardo-de-Lima
-- ============================================================


-- ------------------------------------------------------------
-- 1. OVERVIEW: total customers, churn count and churn rate
-- ------------------------------------------------------------
SELECT
    COUNT(*)                                                        AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)                 AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2)                                    AS churn_rate_pct
FROM telco_churn;


-- ------------------------------------------------------------
-- 2. REVENUE AT RISK from churned customers
-- ------------------------------------------------------------
SELECT
    Churn,
    COUNT(*)                                                        AS total_customers,
    ROUND(SUM(MonthlyCharges), 2)                                   AS total_monthly_revenue,
    ROUND(AVG(MonthlyCharges), 2)                                   AS avg_monthly_charge,
    ROUND(SUM(TotalCharges), 2)                                     AS total_lifetime_revenue
FROM telco_churn
GROUP BY Churn;


-- ------------------------------------------------------------
-- 3. CHURN BY CONTRACT TYPE
-- ------------------------------------------------------------
SELECT
    Contract,
    COUNT(*)                                                        AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)                 AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2)                                    AS churn_rate_pct
FROM telco_churn
GROUP BY Contract
ORDER BY churn_rate_pct DESC;


-- ------------------------------------------------------------
-- 4. CHURN BY TENURE GROUP
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN tenure <= 6   THEN '0 - 6 months'
        WHEN tenure <= 12  THEN '7 - 12 months'
        WHEN tenure <= 24  THEN '13 - 24 months'
        WHEN tenure <= 48  THEN '25 - 48 months'
        ELSE 'Over 48 months'
    END                                                             AS tenure_group,
    COUNT(*)                                                        AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)                 AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2)                                    AS churn_rate_pct
FROM telco_churn
GROUP BY tenure_group
ORDER BY churn_rate_pct DESC;


-- ------------------------------------------------------------
-- 5. CHURN BY PAYMENT METHOD
-- ------------------------------------------------------------
SELECT
    PaymentMethod,
    COUNT(*)                                                        AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)                 AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2)                                    AS churn_rate_pct
FROM telco_churn
GROUP BY PaymentMethod
ORDER BY churn_rate_pct DESC;


-- ------------------------------------------------------------
-- 6. CHURN BY INTERNET SERVICE TYPE
-- ------------------------------------------------------------
SELECT
    InternetService,
    COUNT(*)                                                        AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)                 AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2)                                    AS churn_rate_pct
FROM telco_churn
GROUP BY InternetService
ORDER BY churn_rate_pct DESC;


-- ------------------------------------------------------------
-- 7. CHURN BY MONTHLY CHARGE RANGE
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN MonthlyCharges < 30  THEN 'Under $30'
        WHEN MonthlyCharges < 60  THEN '$30 - $59'
        WHEN MonthlyCharges < 90  THEN '$60 - $89'
        ELSE '$90 and above'
    END                                                             AS charge_range,
    COUNT(*)                                                        AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)                 AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2)                                    AS churn_rate_pct
FROM telco_churn
GROUP BY charge_range
ORDER BY churn_rate_pct DESC;


-- ------------------------------------------------------------
-- 8. CHURN BY TECH SUPPORT & ONLINE SECURITY
-- ------------------------------------------------------------
SELECT
    TechSupport,
    OnlineSecurity,
    COUNT(*)                                                        AS total_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2)                                    AS churn_rate_pct
FROM telco_churn
WHERE TechSupport != 'No internet service'
GROUP BY TechSupport, OnlineSecurity
ORDER BY churn_rate_pct DESC;


-- ------------------------------------------------------------
-- 9. HIGH-RISK CUSTOMER PROFILE
--    Month-to-month contract + high charges + no tech support
-- ------------------------------------------------------------
SELECT
    COUNT(*)                                                        AS high_risk_customers,
    ROUND(COUNT(*) * 100.0 /
          (SELECT COUNT(*) FROM telco_churn), 2)                    AS pct_of_customers,
    ROUND(SUM(MonthlyCharges), 2)                                   AS monthly_revenue_at_risk
FROM telco_churn
WHERE Contract = 'Month-to-month'
  AND TechSupport = 'No'
  AND MonthlyCharges > (SELECT AVG(MonthlyCharges) FROM telco_churn)
  AND Churn = 'No';


-- ------------------------------------------------------------
-- 10. SUMMARY: key churn drivers ranked
-- ------------------------------------------------------------
SELECT 'No Tech Support'     AS factor, ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS churn_rate FROM telco_churn WHERE TechSupport='No'
UNION ALL
SELECT 'Month-to-Month',     ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) FROM telco_churn WHERE Contract='Month-to-month'
UNION ALL
SELECT 'No Online Security', ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) FROM telco_churn WHERE OnlineSecurity='No'
UNION ALL
SELECT 'Fiber Optic',        ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) FROM telco_churn WHERE InternetService='Fiber optic'
UNION ALL
SELECT 'Electronic Check',   ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) FROM telco_churn WHERE PaymentMethod='Electronic check'
ORDER BY churn_rate DESC;
