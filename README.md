# Customer.Segmentation.RFM.Analysis
SQL Project that helped me understand more about the logic of SQL, as well as an introductory to the data visualization platform called Tableau.

Tableau link:

https://public.tableau.com/views/SampleSalesWork_16786804777130/SalesDashboard2?:language=en-US&:display_count=n&:origin=viz_share_link

## Objective

In this project, I wanted to learn more about how to do SQL. Here is a rundown of what I've done:
1. Getting the data
3. Compliling various queries that showcase what are we looking at. Along with creating tables to save on Tableau to do data analysis.
4. I later created some tables that I defined in order to find out which customers are the most loyal.

## Dataset

I've used a dataset that I've found in Kaggle. I was unable to extract the JSON file from the Pokemon.apk website, nor do data mining from a wiki page or another website containing all Pokemon. 

More info about the dataset can be found here:
- Website: https://www.kaggle.com/datasets/abcsds/pokemon?datasetId=121&sortBy=dateCreated

## Discovery

Here is a small conclusion that I've found based on my findings:
- Pokemon with one type from generation 5-7 has experienced a big nose dive in representation. We can also see Pokemon with two types did also suffer from not having a lot of representation as well.
- Overall, the population between one-type and two-type Pokemon does seem similar until the mentioned nose dive from generation 5-6, where two-type Pokemon have more representation in Pokemon games.
- When conducting a T-test, I found that Pokemon with two-type and one-type are statistically significant from one another. This means that Pokemon with two types, on average, had usually higher stats than Pokemon with one type.
- Water types have a big representation at a whopping 10.63%, followed by Normal-types at 9.40%. But when it comes to legendary Pokemon, Psychic, and Dragon-types become the most potent (16.84% and 11.05% respectively).
- Shockingly Fire types are not even the top 5 most frequent types despite being the main 3 types to be selected at the beginning of the game as a starter Pokemon. As well as not being a potent type when it comes to legendary Pokemon.
- Every 'Total' stat, on average (per generation/region), for non-legendary-pokemon has been very consistent.
- Same goes for legendary but generation 7th (Alola) has experienced an average total stat of 561 (a huge 10% decrease of the total average of all legendaries)
- Thanks to ANOVA, we now know that a lot of types do contain stats that are statistically significant from one another.
- The Attack stat/attribute for all Pokemon was statistically significant, based on regions/generations. (I assume it is because of the outliers of the different regions/generations)
- We can also see that HP and Defense were the ones that were most statistically significant across different regions(based individually per type).
- Ghost-types have a random distribution of stats than other typings. This means that there may be no way of predicting where what stat/attribute will be more prominent in the next set of generations.


## Dataset

This dataset contains X rows and Y columns for the variables listed below. The following contains stats in Pokemon: A Pokemon has a unique set of stats that contribute to the Pokemon's identity. 

Variable  |Description |
-----|-----|
Total|The accumulation of all the stats below|
HP|Also known as "Hit Points": The Health of the Pokemon |
Attack|The physical attack strength of the Pokemon |
Special Attack|The non-physical attack moves from the Pokemon |
Defense|How much can a Pokemon withstand physical attacks
SpecialDefense|How much can a Pokemon withstand non-physical attacks
Speed|This dictates which Pokemon can attack first
Generation|Where the Pokemon is from. Generation and Region will be used interchangeably.
Type 1 and Type 2 |This is the attribute of the Pokemon. There are 18 types in the world of Pokemon. A Pokemon can have just one typing or two. 
Legendary|This is a True/False statement that says if a Pokemon is a legendary Pokemon or not. 
