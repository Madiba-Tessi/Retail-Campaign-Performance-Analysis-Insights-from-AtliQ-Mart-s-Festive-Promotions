#1 a list of high values products that are currently being heavily discounted
SELECT DISTINCT f.product_code, product_name, base_price, promo_type
FROM fact_events f
JOIN dim_products dp
ON f.product_code = dp.product_code
WHERE base_price > 500 AND promo_type = "BOGOF"

#2 number of stores by City
SELECT city, COUNT(store_id) AS store_counts
FROM dim_stores
GROUP BY city
ORDER BY store_counts DESC

#3 the financial impact of promotionnal campaigns
SELECT campaign_name,
CONCAT(ROUND(
             SUM((base_price) * (`quantity_sold(before_promo)`))
,1),"M") AS total_revenue_before_promotion, 
CONCAT(ROUND(
             SUM(CASE 
                  WHEN promo_type = "25% OFF" THEN ((base_price) * (1 - 0.25)) * (`quantity_sold(after_promo)`)
	              WHEN promo_type = "33% OFF" THEN ((base_price) * (1 - 0.33)) * (`quantity_sold(after_promo)`)
				  WHEN promo_type = "50% OFF" THEN ((base_price) / 2) * (`quantity_sold(after_promo)`)
	              WHEN promo_type = "500 Cashback" THEN ((base_price) - 500) * (`quantity_sold(after_promo)`)
	              WHEN promo_type = "BOGOF" THEN (base_price) * (`quantity_sold(after_promo)`) ELSE 0 
                  END )
,1),"M") AS total_revenue_after_promotion 
FROM dim_campaigns dc JOIN fact_events f
ON dc.campaign_id = f.campaign_id
GROUP BY campaign_name;

##New Columns
ALTER TABLE fact_events 
ADD COLUMN quantity_sold_AP_updated INT

UPDATE fact_events
SET 
quantity_sold_AP_updated = CASE 
                  WHEN promo_type = "BOGOF" THEN  `quantity_sold(after_promo)`*2
                  ELSE base_price END


#4 Incremental quantity sold by Category
SELECT Category,
CONCAT(ROUND(
      (
      SUM(quantity_sold_AP_updated - `quantity_sold(before_promo)`) / SUM(quantity_sold_AP_updated)
      )*100
,1),"%") AS ISU,
RANK() OVER (ORDER BY 
ROUND((SUM(quantity_sold_AP_updated - `quantity_sold(before_promo)`) / SUM(quantity_sold_AP_updated))*100,1)
DESC) AS ranking
FROM dim_products dp JOIN fact_events f
ON dp.product_code = f.product_code
WHERE campaign_id = "CAMP_DIW_01"
GROUP BY Category


## New columns
ALTER TABLE fact_events 
ADD COLUMN total_revenue_after_promotion INT,
ADD COLUMN total_revenue_before_promotion INT;

UPDATE fact_events
SET 
total_revenue_after_promotion = CASE 
                  WHEN promo_type = "25% OFF" THEN ((base_price) * (1 - 0.25)) * (`quantity_sold(after_promo)`)
	              WHEN promo_type = "33% OFF" THEN ((base_price) * (1 - 0.33)) * (`quantity_sold(after_promo)`)
				  WHEN promo_type = "50% OFF" THEN ((base_price) / 2) * (`quantity_sold(after_promo)`)
	              WHEN promo_type = "500 Cashback" THEN ((base_price) - 500) * (`quantity_sold(after_promo)`)
	              WHEN promo_type = "BOGOF" THEN (base_price) * (`quantity_sold(after_promo)`) ELSE 0 
                  END,
total_revenue_before_promotion = (base_price) * (`quantity_sold(before_promo)`)


#5 Most successful products accross campaigns
SELECT Category, product_name,
ROUND(
      (SUM(total_revenue_after_promotion - total_revenue_before_promotion) / SUM(total_revenue_after_promotion)) * 100
      ,1) AS IR_percentage
FROM dim_products dp JOIN fact_events f
ON dp.product_code = f.product_code
GROUP BY product_name, Category
ORDER BY IR_percentage DESC   
LIMIT 5






