# Instacart_Analysis

**Overview:**

The Instacart Market Basket Analysis project aims to explore and analyze customer shopping behavior using transactional data from the Instacart platform. This dataset provides a rich source of information that can be used to derive valuable insights for optimizing operations and enhancing customer experiences.
Problems to solve
•	How can we increase customer retention?
•	How can we improve customer segmentation and targeting?
•	How can we reduce customer churn?
•	How can we identify and promote product associations?

# Data Analyst Report: Grocery Store Analysis

In this analysis, I explored the grocery store data in-depth to derive meaningful insights. Below, I present the findings and insights from our data analysis.

**Data Cleaning and Exploration**

Missing Values
I began by checking for missing values in the ORDERS table, specifically in the 'days_since_prior_order' column. I'm pleased to report that all values were found in this column.

Data Integrity
To ensure data integrity, I undertook the task of removing duplicate rows from the PRODUCT table. I identified duplicates based on product names and retained only one entry with the minimum 'product_id.' This data cleaning process ensures the data is accessible from redundancy and maintains consistency.

Additionally, I replaced empty values in the 'days_since_prior_order' column with NULL, ensuring the data remains accurate and consistent.

# Projects Analysis

**Market Basket Analysis**

Top 10 Product Pairs Frequently Purchased Together

I conducted a market basket analysis to uncover the top 10 product pairs customers most frequently purchase together. This information is vital for optimizing inventory management and fine-tuning our marketing strategies. The analysis involved joining the order_product_prior data to identify product pairs and their frequencies. To make the insights more actionable, I included product names.

Top 5 Products Commonly Added to Cart First
I also explored which products are most commonly added to the cart first. This insight is crucial for understanding customer preferences and planning promotional activities.

Unique Products per Order
Another aspect of our analysis involved examining the number of unique products typically included in a single order. This insight provides a deeper understanding of customer preferences and choices.

 **Customer Segmentation**
 
Categorization by Spending
To gain insights into customer spending behavior, I categorized customers into three groups: 'High Spenders,' 'Medium Spenders,' and 'Low Spenders' based on their total order count.

Customer Segmentation by Purchase Frequency
I also conducted customer segmentation based on purchase frequency, classifying them as 'Frequent Buyers,' 'Regular Buyers,' or 'Occasional Buyers.' This segmentation can guide targeted marketing efforts.

**Seasonal Trends Analysis**

I analyzed the distribution of orders placed on different days of the week to identify trends in customer behavior.

**Customer Churn Prediction**

Inactive Customers
One of the critical metrics in our analysis was calculating the number of customers who have yet to place an order in the last 30 days. This information is invaluable for identifying inactive customers and potentially re-engaging them.

Customer Churn Rate
To gauge customer churn, I calculated the customer churn rate. This metric represents the percentage of inactive customers relative to the total customer base.


**Product Association Rules**
I explored the top 5 product combinations that are most frequently purchased together. Understanding these associations can support strategic product bundling and cross-selling.

Weekend vs. Weekday Product Association
I compared product associations on weekends and weekdays to determine if buying patterns varied between these two time periods.

**Product Affinity**
I analyzed the top-performing categories to gain insights into product sales by department and aisle. This information is crucial for inventory management and marketing decisions.

**Conclusion**
This comprehensive data analysis has provided valuable insights into customer behavior, product associations, and seasonal trends. These insights can guide marketing strategies, inventory management, and efforts to re-engage inactive customers. Understanding product associations can help maximize cross-selling opportunities.

## Recommendations for Business Improvement

1. Cross-Promotion of Frequently Purchased Products: Utilize the insights from frequently purchased product pairs to strategically place complementary items together on store shelves or in online product recommendations. This will boost sales by encouraging customers to buy related products.

2. Personalized Marketing for Customer Segments: Leverage customer segmentation based on spending behavior and purchase frequency to tailor marketing campaigns. High-spenders might benefit from loyalty programs, while occasional shoppers could be enticed with promotions to increase their engagement.

3. Seasonal Campaigns: Capitalize on seasonal trends by launching targeted marketing campaigns during peak months. For example, the holiday season in December can be optimized with exclusive offers and promotions.

4. Churn Prevention Strategies: Identify and engage with customers who last purchased in the last 30 days. Send personalized offers or reminders to re-engage them with your products and services.

5. Product Bundling and Special Offers: Based on product association rules, consider creating bundles or special offers for product combinations that are frequently purchased together. This can increase the average order value.

6. Data-Driven Inventory Management: Use insights on product popularity to optimize inventory levels. Ensure that high-demand items are well-stocked while low-demand items are managed more efficiently.

By implementing these data-driven suggestions, we can enhance our store layout, marketing strategies, and customer engagement efforts. This approach will not only improve customer satisfaction but also contribute to increased sales and profitability, setting our business on a path to long-term success.

In conclusion, this data analysis gives us the insights to make informed decisions and enhance the grocery store's overall performance.

Power BI Dasboard : 
https://app.powerbi.com/reportEmbed?reportId=9bbcdb85-797b-4a57-8e83-a7af99aaaabd&autoAuth=true&ctid=4fa41538-2dc5-488e-a219-791ad7707929
