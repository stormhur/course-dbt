## (Part 1) Marts
We were approached by the marketing team to answer some questions about Greenery’s users! Use your staging models you created in Week 1 to answer their questions:

1. **What is our user repeat rate?** _Repeat Rate = Users who purchased 2 or more times / users who purchased_

Our repeat user rate is: 

1. **What are good indicators of a user who will likely purchase again?** What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

_Good indicators_:
- frequency of session occurrences 
- session duration without purchase
- repeat product views
- estimated delivery time 
- there is an active promotion 
- breadth and depth of product portfolio explored
- frequency of purchase
- abandoned cart (good for ad retargeting)
- frequency of past deliveres that were delivered on-time or early relative to estimation

_Anti-indicators_:
- bounce rates (sessions under 1 minute)
- frequency of bounced sessions
- estimated delivery time
- frequency of past deliveres that were delivered late relative to estimation

_More data ideas_:
- referrer url
- campaign_id exposure
- experimentation allocation + exposure
  - includes treatment name, etc.
- shipping options available
- past product review scores
- customer success engagement data

1. **Explain the marts models you added. Why did you organize the models in the way you did?**

In general, my structure today is `staging` -> `marts.core` -> `marts.core.marketing` or `marts.core.product`. 

This may seem a bit confusing, but the idea here is that core is the layer for source of truth that is business-level. Our marketing subfolder is currently empty, but will be built out as we get our attribution data into our warehouse instance (think: referrer data, campaign_id referral information, etc.)


- `dim_active_promos`: added to ensure clear source of truth on which promotions are active at a given point in time.
- `dim_order_products`: a given `order_id` can be associated with several `product_id` values. This mart empowers us to see a unique level view of a given order_id for cleaner joining to our order event data. This will enable analysts to, down the line, more easily search for orders of a certain basket size, with certain products, etc.
- `dim_users`: a user could, over time, have many addresses stored in record. This mart empowers us to see a unique level view of a given user and their associated addresses. This will enable cleaner joining to event-level data.
- `fact_user_orders`: this fact table is in many ways the big source of truth for the core of our business. This is likely also going to be a core table that is used by Marketing for their work.
- `fact_user_content_pageviews`: our event data stores content views, order page views, and user triggered events. This fact table specifically pulls out our content pageviews and adds context on what the user is viewing and the associated products in that url. We've included whether we're at risk of the product being out-of-inventory to help provide additional color and context to our internal analytics team.
- `fact_user_order_pageviews`: our event data stores content views, order page views, and user triggered events. This fact table stores all pageviews associated with orders (shipping, checkout screens) for analysis of order level content views.
- `fact_user_sesssions`: this table enables us to get a higher level sense of engagement, by user, for each of their sessions. We envision analysts in eCommerce Product will want to rely on this type of data to explore correlations between session duration and activity to business outcomes.



## (Part 2) Tests 


1. **What assumptions are you making about each model?** (i.e. why are you adding each test?)
- stg_addresses: All join keys in table must be not null and unique to ensure consistent joining. Zip codes cannot be negative in any country. 
- stg_events: All join keys in table must be not null and unique to ensure consistent joining.
- stg_order_items: All join keys in table must be not null and unique to ensure consistent joining. All order item values should be positive, as returns do not populate into the order items source. 
- stg_products: All join keys in table must be not null and unique to ensure consistent joining. All products should be a positive value in price given we do not give away free products. 
- stg_promos: All join keys in table must be not null and unique to ensure consistent joining. Our price discount must be positive, as we would never require users to pay more given a discount. Also, if a discount == 0, then we should throw an error so that we can ensure there are not manual entry issues from our RevOps team.
- stg_users: All join keys in table must be not null and unique to ensure consistent joining. All emails include "@" symbol. All phone numbers will be force formatted to ###-###-####. We should revisit this as we expand internationally. 
- fact_user_content_pageviews: Price must be a positive value since we do not give away free products. We always know the product inventory for a given product (i.e., not null.)
- fact_user_order_pageviews: each pageview event is unique at the user level. This means that a distinct count of a concatenated pageview event identifier and user identifier value should get us a true count of the total views. A pageview event cannot be before our user created event. 
- fact_user_sessions: each session identifier should only show up once per user. Session lengths cannot be negative values and, if a user has a session, then they must have > 0 events triggered (pageviews or otherwise.)

2. **Did you find any “bad” data** as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?

All were discovered last week. 

3. Your stakeholders at Greenery want to understand the state of the data each day. **Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.**

My recommendation would be that we build our tests into our overall workflow for job automation. We should:
- ensure we have some tests that are alerts, but not errors. This means that the DAG can complete if there are alerts (i.e., we're out of inventory for a given item) but not if there are errors (i.e., we stop the DAG and error out so that an AE on our team needs to resolve the issue before we make data ready for users each day.)
- all alerts and errors should be piped into a Slack channel for easy viewing. 
- if there are errors, meaning our job did not complete, we will ensure team leads across Data are alerted via the channel to help build trust.
- quarterly, AE managers should meet with primary stakeholders across the business to ensure there are no changes that we need to make to our error/alerts set-up in the testing phase. We will also empower stakeholders to submit a Jira ticket via a Slack workflow to request new or altered changes. These changes will be triaged by the on-call AE and their manager.