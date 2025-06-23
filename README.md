#   SQL Analysis - Contoso_100k

## Overview
This is a sales based analysis of the Contoso_100k data set looking at three specific parameters: Customer Value, Cohort Revenue, and Customer Retention.

Each section will lead in from the query to an overview of the data, key findings, and visualizations.

## Business Questions
### 1. Customer Value Analysis
What is the customer value distribution of the revenue base?
### 2. Cohort Analysis - Purchase Year 
 How are customers groups generating revenue? 

### 3. Customer Retention Examination
What is the outlook and scope of customer retention?

## Analysis Approach
View: [0_create_view_cohort_analysis.sql](/0_create_view_cohort_analysis.sql)

### 1. Customer Value Analysis
Query: [1_customer_ltv_categories.sql](/1_customer_ltv_categories.sql)

- Total lifetime value (LTV) based customers divisions
- Customers broken down into High, Mid, and Low-value groups by Q3, Median, and Q1 based LTV
- Total revenue calculated by division

**Visualization:**
![alt text](/images/customer_value.png)
**Key Findings:**
- High-value customers (25%) account for 66% of overall revenue ($135.4M)
- Mid-value customers (50%) drive 32% of all revenue ($66.6M)
- Low-value customers (25%) make up the remaining 2% of revenue (4.3M)

### 2. Cohort Analysis
Query: [2_1_cohort_analysis.sql](/2_1_cohort_analysis.sql)
- Examined revenue and unique customer counts by cohort
- Cohorts were group based upon year of first purchase
- Cohort groupings allowed examination of customer retention patterns

**Visualizations**

More Customers Less Spending![alt text](/images/unique_customers_and_monthly_revenue.png)

![alt text](/images/revenue_per_customer.png)

Drop In Online Revenue In The US Market![alt text](/images/online_order_revenue_by_country.png)

Drop Mirrored In Physical US Locations ![alt text](/images/store_revenue_by_country.png)

US Seniors Grouped By Year of First Purchase With Substantial Drop
![alt text](/images/customer_volume_by_year_US_seniors_year_first_purchase.png)

**Key Findings**
- Customers are spending less.
- Revenue increased overall from inception because of an expansion in the customer base, but there is a gap between the amount of customers and what they are spending.
- Most recently, there was a significant drop in both revenue and customer volume from 2022 to 2023.
- The largest change appears to be in the US market, particularly seniors (65+), with a notable downturn in both customers and revenue for both online and in-store purchases.


### 3. Customer Retention
Query: [3_1_retention_analysis](/3_1_retention_analysis.sql)
- Identified relative customer churn rates
- Screened for 2024 data for customers not at the 6 month inactive threshold
- Calculated metrics for the High LTV customer cohorts

**Visualizations**

Customer Retention By Cohorts
![alt text](/images/customer_status_cohort_year_of_first_purchase.png)

High LTV Customer Retention
![alt text](/images/high_ltv_customer_retention_by_cohort_year_of_first_purchase.png)

**Key Findings**
- Cohort churn oscillates ~90% likely suggesting a baseline retention pattern
- The data suggests retention issues with retention rates remaining consistently low (8-10%) across all cohorts
- Overall, the most recent cohorts (2022-2023) demonstrate a similar churn pattern, suggesting that without intervention future cohorts will follow a similar 90% fall off.
- The High LTV customers show a relatively higher rate of retention. Notably, despite a high drop of overall customers, the 2022 Cohort demonstrated the highest retention percentage at ~21%.

## Technical Details
- **Database:** PostgreSQL
- **Analysis Tools:** PostgreSQL
- **Visualizations:** Excel
