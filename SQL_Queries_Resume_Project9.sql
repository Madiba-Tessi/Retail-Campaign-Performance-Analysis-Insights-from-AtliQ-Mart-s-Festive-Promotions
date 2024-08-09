#GET TO KNOW THE DATABASE 
SELECT * FROM fact_events;
SELECT * FROM dim_campaigns;
SELECT * FROM dim_stores;
SELECT * FROM dim_products; 

# Business requirement 1
# Provide a list of products with a base price greater than 500 and that are featured in promo type of 'BOGOF' (BUY ONE GET ONE FREE). This information will help us identify high-value products that are currently being heavily discounted, which can be useful for evaluating our pricing and promotion strategies

SELECT DISTINCT f.product_code, product_name, base_price, promo_type
FROM fact_events f
JOIN dim_products dp
ON f.product_code = dp.product_code
WHERE base_price > 500 AND promo_type = "BOGOF";

#Business requirement 2
# Generate a report that provides an overview of the number of stores in each city, The results will be sorted in descending order of store counts, allowing us to identify the cities with the highest store presence. The report includes two essential fields: city and store count, which will assist in optimizing our retail operations
SELECT city, 
COUNT(store_id) AS store_counts
FROM dim_stores
GROUP BY city
ORDER BY store_counts DESC;

#Business requirement 3
# Generate a report that displays each campaign along with the total revenue generated before and after the campaign. This report should help in evaluating the financial impact of our promotional campaigns.
#Let's use a CTE to create two new columns: total_revenue_before_promo and total_revenue_after_promo
With fact_events_updated AS (
SELECT event_id,
store_id,
campaign_id,
product_code,
base_price,
promo_type,
`quantity_sold(before_promo)`,
`quantity_sold(after_promo)`,
ROUND(SUM(base_price * (`quantity_sold(before_promo)`)),0) AS total_revenue_before_promotion,
ROUND(SUM(CASE 
	WHEN promo_type = "25% OFF" THEN ((base_price) * (1 - 0.25)) * (`quantity_sold(after_promo)`)
	WHEN promo_type = "33% OFF" THEN ((base_price) * (1 - 0.33)) * (`quantity_sold(after_promo)`)
	WHEN promo_type = "50% OFF" THEN ((base_price) / 2) * (`quantity_sold(after_promo)`)
	WHEN promo_type = "500 Cashback" THEN ((base_price) - 500) * (`quantity_sold(after_promo)`)
	WHEN promo_type = "BOGOF" THEN (base_price) * (`quantity_sold(after_promo)`) ELSE 0 
    
    ## In the last line of the CASE statement, no modification has been applied to the base_price column here because of the type of promotion. For Buy One Get One Free, There is no discount applied to the product price. The consumer pay full price and get a second article for free. 
    #No modification has been applied to the quantity_sold_after_promo either because the products have been given away and don't count as sold. Alternatively we can also divide the base_price by 0.5 and multiply the quantity_sold(after_promo) by 2 to get an accurate revenue.
    
	END),0) AS total_revenue_after_promotion
FROM fact_events
GROUP BY  event_id,
store_id,
campaign_id,
product_code,
base_price,
promo_type,
`quantity_sold(before_promo)` ,
`quantity_sold(after_promo)` )

#Run the following line to see the results of the CTE 
#SELECT * FROM fact_events_updated;

SELECT dc.campaign_name,
SUM(fu.total_revenue_before_promotion) AS revenue_before_promotion,
SUM(fu.total_revenue_after_promotion) AS revenue_after_promotion
FROM fact_events_updated fu
INNER JOIN dim_campaigns dc
ON dc.campaign_id = fu.campaign_id
GROUP BY campaign_name; #To run query, select from line 27 to 67

#Business requirement 4 Incremental quantity sold by Category
#Produce a report that calculates the Incremental Sold Quantity (ISU%)  for each category during the Diwali Campaign. Additionally, provide rankings for the categories based on their ISU%. The report will include three key fields: category, isu%, and rank order. This information will assist in assessing the category-wise success and impact of the Diwali campaign on incremental sales.
With fact_events_updated2 AS (
SELECT 
campaign_id,
product_code,
promo_type,
`quantity_sold(before_promo)` ,
`quantity_sold(after_promo)`,
CASE WHEN promo_type = "BOGOF" THEN  `quantity_sold(after_promo)`*2
ELSE `quantity_sold(after_promo)` END AS quantity_sold_and_offered #The case statement provide the total quantity of items sold and the ones offered due to the BOGOF discount.
FROM fact_events),

#Now that we have the total of items sold after promotion, we can calculate the difference between quantity sold after and before promotion

fact_events_updated3 AS(
SELECT 
campaign_id,
product_code,
`quantity_sold(before_promo)` ,
quantity_sold_and_offered,
quantity_sold_and_offered - `quantity_sold(before_promo)` AS quantity_sold_diff
FROM fact_events_updated2)

SELECT dp.Category,
CONCAT(ROUND(
              (SUM(quantity_sold_diff) / SUM(`quantity_sold(before_promo)`))*100
,1),"%") AS "ISU%",
RANK() OVER (ORDER BY 
ROUND((SUM(quantity_sold_diff) / SUM(`quantity_sold(before_promo)`))*100,1)
DESC) AS ranking
FROM dim_products dp JOIN fact_events_updated3 fu3
USING(product_code)
JOIN dim_campaigns dc
USING (campaign_id)
WHERE campaign_id = "CAMP_DIW_01"
GROUP BY Category ; #To run the query, select line 71 to 105

# The Top 5 Most successful products accross campaigns
# Create a report featuring the Top 5 products, ranked by Incremental Revenue Percentage (IR%), across all campaigns. The report will provide essential information including product name and category and ir%. This analysis helps identify the most successful products in terms of incremental revenue across our campaigns, assisting in product optimization
With fact_events_updated AS (
SELECT event_id,
store_id,
campaign_id,
product_code,
base_price,
promo_type,
`quantity_sold(before_promo)`,
`quantity_sold(after_promo)`,
ROUND(SUM(base_price * (`quantity_sold(before_promo)`)),0) AS total_revenue_before_promotion,
ROUND(SUM(CASE 
	WHEN promo_type = "25% OFF" THEN ((base_price) * (1 - 0.25)) * (`quantity_sold(after_promo)`)
	WHEN promo_type = "33% OFF" THEN ((base_price) * (1 - 0.33)) * (`quantity_sold(after_promo)`)
	WHEN promo_type = "50% OFF" THEN ((base_price) / 2) * (`quantity_sold(after_promo)`)
	WHEN promo_type = "500 Cashback" THEN ((base_price) - 500) * (`quantity_sold(after_promo)`)
	WHEN promo_type = "BOGOF" THEN (base_price) * (`quantity_sold(after_promo)`) ELSE 0 
	END),0) AS total_revenue_after_promotion
FROM fact_events
GROUP BY  event_id,
store_id,
campaign_id,
product_code,
base_price,
promo_type,
`quantity_sold(before_promo)` ,
`quantity_sold(after_promo)` ) #i am reusing CTE from the third question

SELECT Category, product_name,
CONCAT(ROUND(
      (SUM(total_revenue_after_promotion - total_revenue_before_promotion) / SUM(total_revenue_before_promotion)) * 100
      ,1),"%") AS IR_percentage
FROM dim_products dp JOIN fact_events_updated fu
USING (product_code)
GROUP BY product_name, Category
ORDER BY 3 DESC   
LIMIT 5 #To run the query select from line 109 to line 144
