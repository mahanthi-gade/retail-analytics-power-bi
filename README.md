# Retail Analytics Power BI Dashboard

Interactive Power BI dashboard analyzing retail revenue, order performance, customer behavior, sales channels, product categories, and regional performance.

## Project Overview

This project is an end-to-end retail analytics solution that transforms raw transactional CSV data into actionable business insights using PostgreSQL, SQL, Power Query, Power BI, DAX, and GitHub.

The workflow covers data ingestion, relational querying, data-quality validation, analytical SQL, semantic modeling, KPI development, interactive dashboard design, and business analysis.

The dashboard is designed as a two-page business intelligence solution:

- **Executive Overview** — high-level KPIs and performance trends
- **Customer & Order Analysis** — customer behavior, order frequency, channel usage, and segment performance

## End-to-End Analytics Workflow

The project follows this analytical workflow:

**Raw CSV Data → PostgreSQL → SQL Analysis & Validation → Power Query → Power BI Semantic Model → DAX Measures → Interactive Dashboard → Business Insights → GitHub Documentation**

### 1. Source Data
Five CSV datasets were used:

- `customers.csv`
- `orders.csv`
- `order_items.csv`
- `products.csv`
- `regions.csv`

### 2. PostgreSQL & SQL Analysis
The source tables were loaded into PostgreSQL and analyzed using SQL to:

- Calculate revenue, orders, Average Order Value, units sold, and customer KPIs
- Analyze product categories, regions, sales channels, and customer segments
- Perform customer-level and repeat-purchase analysis
- Compare 2024 and 2025 performance
- Calculate YoY changes using CTEs and window functions
- Perform conditional aggregation using `CASE`
- Analyze discount behavior and order-status distribution
- Validate duplicates, null values, invalid values, and referential integrity

### 3. Power BI Data Model
The cleaned analytical data was modeled in Power BI using relationships between customers, orders, order items, products, regions, and a dedicated Date dimension.

### 4. DAX & KPI Development
Reusable DAX measures were created for revenue, order performance, customer behavior, completion/cancellation rates, Average Order Value, discounts, and year-over-year analysis.

### 5. Dashboard & Business Analysis
Two interactive Power BI report pages were developed:

- **Executive Overview**
- **Customer & Order Analysis**

The dashboards support year-based filtering, cross-filtering, trend analysis, and drill-down across product, customer, channel, and regional performance.## Business Questions

This dashboard was developed to answer key retail performance questions:

- How much completed revenue is the business generating?
- How are order volume and completion rates performing?
- How is completed revenue changing over time?
- Which product categories contribute the most completed revenue?
- Which regions generate the strongest revenue performance?
- Which customer segments contribute the most revenue and completed orders?
- Which sales channels generate the highest order volume?
- How frequently are customers placing and successfully completing orders?

## Dashboard Pages

### 1. Executive Overview

Provides a high-level view of overall retail performance for executive decision-making.

Key KPIs include:

- Average Order Value
- Revenue YoY Growth %
- Completion Rate
- Total Orders
- Completed Revenue

Analysis includes:

- Completed Revenue by Category
- Monthly Completed Revenue Trend
- Completed Revenue by Region
- Year-based filtering

![Executive Overview](screenshots/executive-overview.png)

### 2. Customer & Order Analysis

Provides a detailed view of customer purchasing behavior, order completion, and sales channel performance.

Key KPIs include:

- Total Customers
- Orders per Customer
- Completed Orders per Customer
- Average Order Value
- Cancellation Rate

Analysis includes:

- Completed Revenue by Customer Segment
- Completed Orders by Channel
- Completed Orders by Customer Segment
- Year-based filtering

![Customer & Order Analysis](screenshots/customer-order-analysis.png)


## Data Model

The Power BI semantic model uses a relational structure connecting six core tables:

- **customers** — customer and segment information
- **orders** — order transactions, status, channel, and order dates
- **order_items** — line-level quantities, pricing, and discounts
- **products** — product and category information
- **regions** — geographic attributes used for regional analysis
- **Date** — calendar dimension supporting time-based filtering and year-over-year analysis

Relationships between these tables allow filters to propagate across customers, orders, products, regions, and time while supporting reusable DAX measures throughout the report.

- customers
- orders
- order_items
- products
- regions
- Date

The Date table supports time-based filtering and year-over-year analysis.

## DAX Measures

Custom DAX measures were developed to calculate revenue, order performance, customer behavior, and time-based KPIs, including:

- Total Revenue
- Completed Revenue
- Average Order Value
- Revenue YoY Growth %
- Total Orders
- Completed Orders
- Completion Rate
- Cancellation Rate
- Return Rate
- Units per Order
- Total Customers
- Orders per Customer
- Completed Orders per Customer
- Average Discount

Detailed DAX formulas are documented in the [`dax`](dax/) folder.

## Key Insights

- Consumer customers are the strongest customer segment, generating the largest share of completed revenue and completed orders.
- Online is the highest-volume sales channel, followed by the Mobile App, Marketplace, and Store channels.
- Electronics generates the highest completed revenue among product categories.
- Regional revenue is relatively balanced, with the Southwest generating the highest completed revenue.
- Revenue YoY analysis enables comparison of current-year performance against the previous year, while year-based filtering allows users to investigate changes across reporting periods.

## Tools & Skills Demonstrated

- **PostgreSQL** — relational database used for storing and analyzing retail transaction data
- **SQL** — joins, aggregations, CTEs, window functions, CASE expressions, time-series analysis, KPI calculations, and data-quality validation
- **Power BI** — interactive dashboard development and report design
- **DAX** — custom measures and KPI calculations
- **Data Modeling** — relational semantic model and table relationships
- **Time Intelligence** — year-over-year revenue analysis and date-based filtering
- **KPI Development** — revenue, orders, completion, cancellation, and customer metrics
- **Data Visualization** — business-focused charts, KPI cards, and trend analysis
- **Customer Segmentation** — analysis of Consumer, Small Business, and Corporate segments
- **Business Intelligence** — translating retail data into actionable performance insights

## Repository Structure

```text
retail-analytics-power-bi/
│
├── README.md
├── dashboard/
│   └── Retail Analytics Dashboard.pbix
├── data/
│   ├── customers.csv
│   ├── orders.csv
│   ├── order_items.csv
│   ├── products.csv
│   ├── regions.csv
│   └── README.md
├── sql/
│   ├── retail_analytics_queries.sql
│   └── README.md
├── dax/
│   └── README.md
└── screenshots/
    ├── executive-overview.png
    └── customer-order-analysis.png
```

## Author

Mahanthi Gade
