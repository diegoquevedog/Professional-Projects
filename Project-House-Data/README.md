# House Data Analysis (Tableau)

## Project Overview
This repository contains a Tableau project for analysing property market data. The packaged workbook (TWBX) includes a Tableau workbook and a data extract. The analysis consolidates price tracking across different price metrics. You can see the dashboard [Here](https://public.tableau.com/views/HouseDataAnalysis_17573686601970/KingCountyHouseSales?:language=es-ES&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

<img width="2343" height="1202" alt="image" src="https://github.com/user-attachments/assets/edd263b8-1a56-4596-a708-709ce38000bf" />

## Purpose of the Project
The primary objectives are:
- Build a reliable, visual source of truth for housing market health and pricing dynamics that non-technical stakeholders can use.
- Transform raw CSV data into curated, trusted metrics using aggregations and data modeling in Tableau.
- Enable rapid exploration of trends by property characteristics (e.g., bedrooms, sqft, property type), location, and time to support pricing, acquisition, and portfolio decisions.
- Standardize KPI definitions (Median Price, Price per Sqft, DOM, Absorption, Inventory, MoM/YoY deltas) so that teams are aligned on performance and risk signals.
- Shorten the cycle time from data ingestion to insights by embedding repeatable pipelines and a single dashboard for daily/weekly use.

## Key Analysis Areas
- Supply and Inventory
  - Active listings, new listings, months of supply, absorption rate by market and segment.
- Pricing and Affordability
  - Median/average price, price per sqft, discount to list, MoM/YoY trends, and affordability bands.
- Demand and Velocity
  - Pending ratio, sold-through rate, Days on Market (DOM) distributions, and time-to-pending.
- Segmentation
  - Breakouts by beds/baths, property type, size cohorts, age of home, and by geography (zip/city/region).
- Quality and Outlier Control
  - Robust handling of outliers (e.g., extreme sqft/price), missing data checks, and consistent date hierarchies.
- Executive Snapshot
  - Single-page dashboard with top KPIs, trend lines, and variance indicators (MoM/YoY) and quick filters for drill-down.

## Business Value
- Pricing Strategy
  - Identify pockets of strength or softness to adjust list prices, incentives, or renovation budgets by submarket.
- Inventory Optimization
  - Right-size listings and acquisition pace using months of supply and absorption trends to reduce carrying costs.
- Revenue and Margin Lift
  - Benchmark price per sqft and discount rates to capture upside and avoid overpricing that drives long DOM.
- Risk and Forecasting
  - Use leading indicators (pending ratio, DOM shift) to forecast demand and flag markets at risk early.
- Operational Efficiency
  - Standardized KPIs and a single dashboard reduce ad-hoc reporting and aligns stakeholders on definitions and targets.

## Future Enhancements
- Automated Data Refresh
  - Parameterized extracts and scheduled refresh to keep dashboards current without manual steps.
- Geospatial Deep Dives
  - Map layers for micro-market patterns, school zones, and proximity features.
- Predictive Modeling
  - Price and DOM prediction using gradient boosting/regularized models exposed via parameter controls in Tableau.
- What-If Analysis
  - Scenario toggles for price changes, rate shifts, and renovation investments to assess impact on velocity and sell-through.
- Data Quality Monitoring
  - Data quality dashboard with completeness checks and anomaly alerts.

**Project Type**: Financial Analytics | **Tools**: Tableau, Excel | **Domain**: Real State & Finance | **Focus**: Price Tracking & Portfolio Analysis

