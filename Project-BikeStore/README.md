# BikeStore Sales Analysis

A comprehensive end-to-end analysis of a bicycle retailer using a Tableau workbook extract, with Python-based KPIs and visual insights. This README is ready for direct use on GitHub.

## Highlights
- Total revenue: 7,689,046.0
- Total units sold: 7,078
- Number of orders: 1,615
- Average order value (AOV): 4,761.02
- Unique customers: 1,444
- Top brand by revenue: Trek
- Top category by revenue: Mountain Bikes
- Top state by revenue: NY


## Data Source
This project reads the embedded Tableau Hyper extract from the provided Tableau workbook (TWBX). The dataset includes order-level transactions with customer, product, store, and revenue details.

### Key Columns
- order_id: Unique order identifier
- customers_name: Customer full name
- city: Customer or store city
- state: State or province code
- order_date: Order date
- sales_units: Units sold for the line
- total_revenues: Revenue for the line
- product_name: Product display name
- category_name: Product category
- store_name: Store name
- sales_rep: Sales representative
- brand_name: Product brand

## Methods
- Extract data from the Tableau Hyper file using tableauhyperapi
- Clean and normalize types for dates and numerics
- Compute KPIs: revenue, units, orders, AOV, unique customers
- Aggregate analyses: revenue by month, brand, category, and state
- Visualize insights and export to PNGs in assets/

## Visual Insights
Below images are generated directly from the data:

![Revenue by Month](assets/revenue_by_month.png)

![Top Brands by Revenue](assets/top_brands.png)

![Top Categories by Revenue](assets/top_categories.png)

![Top States by Revenue](assets/revenue_by_state.png)

## How to Reproduce
1. Clone this repository
2. Ensure Python 3.9+ and install dependencies:
   - pip install tableauhyperapi pandas seaborn matplotlib
3. Place BikeStore Analysis.twbx in the repo root (or update paths as needed)
4. Run the provided notebook or script to regenerate KPIs and charts

## Business Questions Answered
- What is the total revenue and order volume over time?
- Which brands and categories drive the most sales?
- Which states are top-performing regions?
- What is the average order value and customer base size?

## Notes and Assumptions
- Revenue and units are aggregated at the order line level
- Missing dates are coerced to NaT and excluded from time series plots
- Currency is assumed to be USD unless otherwise noted

## License
Add your chosen license here (e.g., MIT, Apache 2.0).

## Acknowledgments
Data visualization powered by Tableau and Python. Analysis authored for portfolio demonstration.

---

**Project Type**: Financial Analytics | **Tools**: Tableau, SQL, Excel, CSV | **Domain**: Retail & Finance | **Focus**: Sell Management & Portfolio Analysis
