# Churn Analysis — Telecom Dataset

Data-driven analysis of customer churn at a telecom company, identifying key risk factors and delivering actionable business recommendations to reduce cancellations.

---

## Objective

Identify the profile of customers most likely to cancel the service, understand what drives churn, and translate those findings into concrete recommendations that a business team could act on.

---

## Dataset

- **Source:** [Telco Customer Churn](https://www.kaggle.com/datasets/blastchar/telco-customer-churn)
- **Size:** 7,043 customers, 21 variables
- **Type:** Real-world inspired telecom dataset

---

## Tools

| Tool | Usage |
|---|---|
| SQL (MySQL) | Data extraction, segmentation and transformation |
| Power BI | Interactive dashboard and storytelling |
| GitHub | Version control and documentation |

---

## Business Questions

1. What is the overall churn rate?
2. How much monthly revenue is at risk?
3. Which contract types have the highest churn?
4. Do newer customers churn more than long-tenured ones?
5. Which payment methods are associated with more churn?
6. Does the lack of tech support or online security drive cancellations?
7. What does the high-risk customer profile look like?

---

## Repository Structure

```
churn-analysis/
│
├── queries_project3.sql   # All SQL queries used in the analysis
├── README.md              # Project documentation
└── dashboard/             # Power BI dashboard screenshots
```

---

## Key Insights

> Fill in with the real numbers found in your analysis

- Overall churn rate: **X%** (~X,XXX customers)
- Monthly revenue at risk from churned customers: **$XX,XXX**
- Month-to-month contracts had a churn rate of **X%** vs X% for 2-year contracts
- Customers with **0–6 months** tenure had the highest churn rate at X%
- Customers paying by **electronic check** churned X% more than average
- Customers with **no tech support and no online security** churned at **X%**
- High-risk profile (month-to-month + high charges + no tech support): **X%** of active customers representing $X,XXX/month at risk

---

## Business Recommendations

Based on the analysis, here are 3 actionable recommendations:

1. **Incentivize longer contracts** — Offer discounts for customers switching from month-to-month to 1 or 2-year contracts, especially in the first 6 months of tenure.
2. **Target high-risk customers proactively** — Create a retention campaign for customers matching the high-risk profile (month-to-month + high charges + no tech support) before they churn.
3. **Bundle tech support and online security** — These services are strongly correlated with lower churn. Consider offering them as a free trial or discounted add-on.

---

## Dashboard — Power BI

**Page 1 — Overview**
- KPI cards: Total Customers, Churned Customers, Churn Rate, Revenue at Risk
- Donut chart: Churned vs retained customers

**Page 2 — Contracts & Tenure**
- Bar chart: Churn rate by contract type
- Bar chart: Churn rate by tenure group

**Page 3 — Services & Payments**
- Bar chart: Churn rate by internet service type
- Bar chart: Churn rate by payment method
- Matrix: Tech support + online security vs churn rate

**Page 4 — Risk Profile & Recommendations**
- KPI: High-risk customers and revenue at risk
- Bar chart: Top churn drivers ranked
- Text cards: 3 business recommendations

---

## How to Reproduce

1. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/blastchar/telco-customer-churn)
2. Import `WA_Fn-UseC_-Telco-Customer-Churn.csv` into MySQL or SQLite as table `telco_churn`
3. Run the queries in `queries_project3.sql` in order
4. Import results into Power BI and build the dashboard

---

## Contact

**Caio Breder Bernardo-de-Lima**
[LinkedIn](https://www.linkedin.com/in/caio-bernardo-de-lima-6a4010240/?skipRedirect=true) | [GitHub](https://github.com/CaioBreder)
