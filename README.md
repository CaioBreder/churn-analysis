# Churn Analysis — Telecom Dataset

Data-driven analysis of customer churn at a telecom company, identifying key risk factors and delivering actionable business recommendations to reduce cancellations.

**Tools:** SQL (MySQL) · Power BI · GitHub  
**Dataset:** [Telco Customer Churn](https://www.kaggle.com/datasets/blastchar/telco-customer-churn) — 7,043 customers · 21 variables

---

## Business Questions

1. What is the overall churn rate?
2. How much monthly revenue is at risk?
3. Which contract types have the highest churn?
4. Do newer customers churn more than long-tenured ones?
5. Which payment methods are associated with more churn?
6. Does the lack of tech support drive cancellations?
7. What does the high-risk customer profile look like?

---

## Query 1 — Overview

```sql
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM telco_churn;
```

**Result:**

| total_customers | churned_customers | churn_rate_pct |
|---|---|---|
| 7,043 | 1,869 | 26.54% |

> More than **1 in 4 customers** cancelled their service.

---

## Query 2 — Revenue at Risk

```sql
SELECT
    Churn,
    COUNT(*) AS total_customers,
    ROUND(SUM(MonthlyCharges), 2) AS total_monthly_revenue,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge,
    ROUND(SUM(TotalCharges), 2) AS total_lifetime_revenue
FROM telco_churn GROUP BY Churn;
```

**Result:**

| Churn | total_customers | total_monthly_revenue | avg_monthly_charge | total_lifetime_revenue |
|---|---|---|---|---|
| No | 5,174 | $283,794.50 | $54.85 | $4,861,074.20 |
| Yes | 1,869 | $139,130.40 | $74.44 | $1,531,864.10 |

> Churned customers paid **$19.59 more per month** on average — the highest-value customers are leaving the most.

---

## Query 3 — Churn by Contract Type

```sql
SELECT
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM telco_churn
GROUP BY Contract ORDER BY churn_rate_pct DESC;
```

**Result:**

| Contract | total_customers | churned | churn_rate_pct |
|---|---|---|---|
| Month-to-month | 3,875 | 1,655 | 42.71% |
| One year | 1,473 | 166 | 11.27% |
| Two year | 1,695 | 48 | 2.83% |

> **Month-to-month customers churn 15x more** than two-year contract customers. Contract type is the strongest churn predictor.

---

## Query 4 — Churn by Tenure Group

```sql
SELECT
    CASE
        WHEN tenure <= 6   THEN '0 - 6 months'
        WHEN tenure <= 12  THEN '7 - 12 months'
        WHEN tenure <= 24  THEN '13 - 24 months'
        WHEN tenure <= 48  THEN '25 - 48 months'
        ELSE 'Over 48 months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM telco_churn
GROUP BY tenure_group ORDER BY churn_rate_pct DESC;
```

**Result:**

| tenure_group | total_customers | churned | churn_rate_pct |
|---|---|---|---|
| 0 - 6 months | 1,037 | 579 | 55.83% |
| 7 - 12 months | 762 | 312 | 40.94% |
| 13 - 24 months | 1,140 | 362 | 31.75% |
| 25 - 48 months | 1,421 | 318 | 22.38% |
| Over 48 months | 2,683 | 298 | 11.11% |

> **More than half of new customers** (0–6 months) cancel. The first 6 months are the most critical window for retention.

---

## Query 5 — Churn by Payment Method

```sql
SELECT
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM telco_churn
GROUP BY PaymentMethod ORDER BY churn_rate_pct DESC;
```

**Result:**

| PaymentMethod | total_customers | churned | churn_rate_pct |
|---|---|---|---|
| Electronic check | 2,365 | 1,071 | 45.29% |
| Mailed check | 1,612 | 308 | 19.10% |
| Bank transfer (auto) | 1,544 | 249 | 16.13% |
| Credit card (auto) | 1,522 | 241 | 15.83% |

> Customers paying by **electronic check churn at 45%** — nearly 3x more than those on automatic payments.

---

## Query 6 — Tech Support & Online Security vs Churn

```sql
SELECT
    TechSupport,
    OnlineSecurity,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM telco_churn
WHERE TechSupport != 'No internet service'
GROUP BY TechSupport, OnlineSecurity ORDER BY churn_rate_pct DESC;
```

**Result:**

| TechSupport | OnlineSecurity | total_customers | churn_rate_pct |
|---|---|---|---|
| No | No | 1,742 | 41.82% |
| No | Yes | 1,008 | 30.14% |
| Yes | No | 1,019 | 15.21% |
| Yes | Yes | 823 | 7.44% |

> Customers with **neither tech support nor online security** churn at 41.82%. Adding both services drops churn to just 7.44%.

---

## Query 7 — High-Risk Customer Profile

```sql
SELECT
    COUNT(*) AS high_risk_customers,
    ROUND(COUNT(*) * 100.0 /
          (SELECT COUNT(*) FROM telco_churn), 2) AS pct_of_customers,
    ROUND(SUM(MonthlyCharges), 2) AS monthly_revenue_at_risk
FROM telco_churn
WHERE Contract = 'Month-to-month'
  AND TechSupport = 'No'
  AND MonthlyCharges > (SELECT AVG(MonthlyCharges) FROM telco_churn)
  AND Churn = 'No';
```

**Result:**

| high_risk_customers | pct_of_customers | monthly_revenue_at_risk |
|---|---|---|
| 812 | 11.53% | $71,284.30 |

> **812 active customers** match the high-risk profile, representing **$71,284/month** in revenue that could be lost if no action is taken.

---

## Query 8 — Top Churn Drivers Ranked

```sql
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
```

**Result:**

| factor | churn_rate |
|---|---|
| Month-to-Month | 42.71% |
| Electronic Check | 45.29% |
| No Online Security | 41.77% |
| No Tech Support | 41.64% |
| Fiber Optic | 41.89% |

---

## Business Recommendations

Based on the analysis, here are 3 actionable recommendations:

**1. Incentivize longer contracts**
Month-to-month customers churn at 42.71% vs 2.83% for two-year contracts. Offering a discount for upgrading to a 1 or 2-year plan — especially in the first 6 months — could dramatically reduce churn.

**2. Switch customers to automatic payments**
Electronic check users churn at 45.29% vs ~16% for automatic payment methods. A simple campaign encouraging customers to switch to auto-pay could reduce churn by up to 29 percentage points in this segment.

**3. Bundle tech support and online security**
Customers with both services churn at only 7.44% vs 41.82% for those with neither. Offering these as a free trial or discounted bundle to high-risk customers is a high-ROI retention strategy.

---

## Key Takeaways

- Overall churn rate is **26.54%** — more than 1 in 4 customers
- Churned customers paid **$19.59/month more** than retained ones — high-value customers are most at risk
- **Month-to-month contracts** drive the most churn at 42.71%
- **55.83% of customers in their first 6 months** cancel — early engagement is critical
- **Electronic check** users churn 3x more than auto-pay users
- **812 active customers** are at high risk, representing $71,284/month in potential lost revenue

---

## Contact

**Caio Breder Bernardo-de-Lima**  
[LinkedIn](https://www.linkedin.com/in/caio-bernardo-de-lima-6a4010240/?skipRedirect=true) | [GitHub](https://github.com/CaioBreder)
