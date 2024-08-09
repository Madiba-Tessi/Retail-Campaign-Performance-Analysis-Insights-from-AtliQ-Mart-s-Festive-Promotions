AtliQ Mart is a retail giant with over 50 supermarkets in the southern region of India. All their 50 stores ran a massive promotion during the Diwali 2023 and Sankranti 2024 (festive time in India) on their AtliQ branded products. Now the sales director wants to understand which promotions did well and which did not so that they can make informed decisions for their next promotional period.
My analysis will answer two major questions which products or discounts have resulted in more sales? And why?

Additionally, the senior executives had important business questions requiring SQL-based report generation.

Part 1 - SQL Report Insights 

1-	Provide a list of products with a base price greater than 500 rupees and that are featured in the promo type of 'BOGOF' (BUY ONE GET ONE FREE)

![sql_request-1](Read_me_images/sql_request-1.png)

This information will help identify high-value products currently being heavily discounted, which can be useful for evaluating item pricing and promotion strategies.

2-	Generate a report that provides an overview of the number of stores in each city.

![sql_request-2](Read_me_images/sql_request-2.png)

The results are sorted in descending order of store counts, allowing us to identify the cities with the highest store presence. The report includes two essential fields: city and store count, which will assist in optimizing the retail operations.

3-	Generate a report that displays each campaign along with the total revenue generated before and after the campaign.

![sql_request-3](Read_me_images/sql_request-3.png)
 
This report should help in evaluating the financial impact of our promotional campaigns

4-	 Produce a report that calculates the Incremental Sold Quantity (ISU%)  for each category during the Diwali Campaign.

![sql_request-4](Read_me_images/sql_request-4.png)

This information will assist in assessing the category-wise success and impact of the Diwali campaign on incremental sales.

5-	Create a report featuring the Top 5 products, ranked by Incremental Revenue Percentage (IR%), across all campaigns.

![sql_request-5](Read_me_images/sql_request-5.png)

This analysis helps identify the most successful products in terms of incremental revenue across our campaigns, assisting in product optimization

Part 2 – Insights to the Sales Team 

*	Full video presentation on my Linkedin and Dashboard on my Tableau
  
2-a Promotion Type Analysis

•	500 Cashback and BOGOF are the top 2 promotion types that resulted in the highest incremental revenue, in fact they are the only ones with positive incremental revenue. 

![IRbyPT](Read_me_images/IR%20by%20PT.png)

•	 25% OFF and 50%OFF discounts are the least performing for increasing sales.

![ISUbyPT](Read_me_images/ISU%20by%20PT.png)

•	All discounts-based promotions are underperforming compared to BOGOF and Cashback, especially in terms of revenue.

•	BOGOF and 500 Cashback are the only promotions that strike the best balance between sold units and maintaining healthy margins.

2-b Product and Category Analysis

The Home Appliances Category saw a 629% lift in sales 

![Product's_performance](Read_me_images/Product's%20performance.png)

13 of the 15 products have seen their sale increase.

2-c The Sales Team want to know if there is a correlation between product category and promotion type effectiveness. 

There is none. 

Promotions are usually run for two goals, one of them is liquidation but most of the time to increase sales in a set time frame. 

So, the promotion effectiveness is measured by his ability to increase sales. 

The performance of a promotion type is not related to the category of product to which it is applied.

![PT_performance_by_Category](Read_me_images/PT%20performance%20by%20Category.png)

From the screenshot of the table, we notice that the 25% OFF produces negative sales results across all the categories it was applied to. Oppositely BOGOF is giving positive results no matter the category.

How do we explain that?

The BOGOF is very effective on incremental revenue because of how it works. Buy One, Get One means the customer pays a product at full price and receives a second free. In the transaction, the store gets 100% of the money. 

*second reason

 products that are listed under this promotion are more affordable, at least compared to the price of products in the Combo1 category. The average price for products listed under BOGOF is 571 rupees. 
 
*last reason but not least: there is a gift for every purchase

Those two last conditions make the products so much more attractive to the customers which generates more units sold. 
More units sold generate more revenue and since the store keeps  100% of the money, that results in a higher incremental revenue percentage.  

The performance of the 500 Cashback promotion is explained by one thing.

The product it was applied to.
 Specifically, the product's price
 
This is the (Atliq_Home_Essential_8) listed at 3000 rupees. With a 500 Cashback, the store keeps 2500 rupees which is a very good margin.  You can now see why this promotion is so effective. It is easier to get a positive increment when you are giving away only 16%.

There is a correlation.  The results would be different if the base price was lower or if the cashback amount was higher. 

One last example to prove my point

the 50% OFF discount is also a good example for demonstration. This is a good deal for customers which explains the positive ISU%.  Even if there are a lot of sold units, it is almost impossible to get a positive incremental revenue when the revenue is cut in half from the start.

