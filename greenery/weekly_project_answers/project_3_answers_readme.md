## (Part 1) Create new models to answer the first two questions
We were approached by the marketing team to answer some questions about Greenery’s users! Use your staging models you created in Week 1 to answer their questions:

1. **What is our overall conversion rate?** 

Our overall conversion rate is: 62.46%

SQL: 
```
SELECT 
    *
FROM dbt_storm_h.fact_site_conversion_rate
```

2. **What is our conversion rate by product?** 

| **PRODUCT**         	| **CONVERSION RATE** 	|
|---------------------	|---------------------	|
| alocasia polly      	| 0.4117647059        	|
| aloe vera           	| 0.4923076923        	|
| angel wings begonia 	| 0.393442623         	|
| arrow head          	| 0.5555555556        	|
| bamboo              	| 0.5373134328        	|
| bird of paradise    	| 0.45                	|
| birds nest fern     	| 0.4230769231        	|
| boston fern         	| 0.4126984127        	|
| cactus              	| 0.5454545455        	|
| calathea makoyana   	| 0.5094339623        	|
| devil's ivy         	| 0.4888888889        	|
| dragon tree         	| 0.4677419355        	|
| ficus               	| 0.4264705882        	|
| fiddle leaf fig     	| 0.5                 	|
| jade plant          	| 0.4782608696        	|
| majesty palm        	| 0.4925373134        	|
| money tree          	| 0.4642857143        	|
| monstera            	| 0.5102040816        	|
| orchid              	| 0.4533333333        	|
| peace lily          	| 0.4090909091        	|
| philodendron        	| 0.4838709677        	|
| pilea peperomioides 	| 0.4745762712        	|
| pink anthurium      	| 0.4189189189        	|
| ponytail palm       	| 0.4                 	|
| pothos              	| 0.3442622951        	|
| rubber plant        	| 0.5185185185        	|
| snake plant         	| 0.397260274         	|
| spider plant        	| 0.4745762712        	|
| string of pearls    	| 0.609375            	|
| zz plant            	| 0.5396825397        	|

SQL: 
```
SELECT 
    *
FROM dbt_storm_h.fact_site_conversion_rate_by_product
```

## (Part 2 & 4) MACROS + PACKAGES


1. **What macros did you add?** I added a macros for: testing for valid email addresses, testing for valid phone numbers, averaging and rounding values to the nearest 2 decimal places. I also utilized jinja (+ dbt_utils) across some intermediate tables to get at the # of sessions, orders, etc. per event_type, shipping service, etc.
2.**What package did you add?** dbt_utils for enabling looping through dictionaries/pulling values for loops via sql.