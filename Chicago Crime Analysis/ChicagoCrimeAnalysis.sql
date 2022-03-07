#Total number of crimes recorded in the CRIME table.
SELECT COUNT(CASE_NUMBER) as "Total number of Crimes"
FROM chicagodata.chicago_crime_data

#List community areas with per capita income less than 11000
SELECT COMMUNITY_AREA_NAME, PER_CAPITA_INCOME
FROM chicagodata.chicago_census_data
WHERE PER_CAPITA_INCOME<11000

#List all case numbers for crimes involving minors
SELECT CASE_NUMBER, DESCRIPTION
FROM chicagodata.chicago_crime_data
WHERE LCASE(DESCRIPTION) LIKE "%minor%";

# List all kidnapping crimes involving a child?(children are not considered minors for the purposes of crime analysis)
SELECT CASE_NUMBER, PRIMARY_TYPE, DESCRIPTION
FROM chicagodata.chicago_crime_data
WHERE lcase(PRIMARY_TYPE) LIKE "%kidnap%" AND lcase(DESCRIPTION) LIKE "%child%"

#What kind of crimes were recorded at schools?
SELECT PRIMARY_TYPE 
FROM chicagodata.chicago_crime_data
WHERE lcase(LOCATION_DESCRIPTION) LIKE "%school%"

#List the average safety score for all types of schools.
SELECT AVG(SAFETY_SCORE) as "Average Safety Score"
FROM chicagodata.chicago_public_schools

#List 5 community areas with highest % of households below poverty line.
SELECT community_area_name, percent_households_below_poverty
FROM chicagodata.chicago_census_data
ORDER BY percent_households_below_poverty DESC
LIMIT 5

#Which community area(number) is most crime prone?
SELECT COMMUNITY_AREA_NAME, count(CASE_NUMBER)
FROM chicagodata.chicago_census_data CD, chicagodata.chicago_crime_data CCD
WHERE CD.COMMUNITY_AREA_NUMBER=CCD.COMMUNITY_AREA_NUMBER 
GROUP BY CD.COMMUNITY_AREA_NAME
ORDER BY count(CASE_NUMBER) DESC
LIMIT 1

#Name of the community area with highest hardship index (SUBQUERY)
SELECT COMMUNITY_AREA_NAME, HARDSHIP_INDEX
FROM chicagodata.chicago_census_data
WHERE HARDSHIP_INDEX=(SELECT MAX(HARDSHIP_INDEX) FROM chicagodata.chicago_census_data)

#Community Area Name with most number of crimes
SELECT COMMUNITY_AREA_NAME
FROM chicagodata.chicago_census_data
WHERE COMMUNITY_AREA_NUMBER = 
(SELECT COMMUNITY_AREA_NUMBER FROM chicagodata.chicago_crime_data 
GROUP BY COMMUNITY_AREA_NUMBER 
ORDER BY COUNT(CASE_NUMBER) DESC LIMIT 1)


#List of Schools that made adequate yearly progress
SELECT NAME_OF_SCHOOL, COMMUNITY_AREA_NAME FROM chicagodata.chicago_public_schools
WHERE Adequate_Yearly_Progress_Made_="Yes"

#Community area where most number of schools made adequate yearly progress
SELECT COMMUNITY_AREA_NAME,COUNT(COMMUNITY_AREA_NAME) as "Number of Schools that made Adequate Progress"
FROM chicagodata.chicago_public_schools
WHERE Adequate_Yearly_Progress_Made_="Yes"
GROUP BY COMMUNITY_AREA_NAME 
ORDER BY COUNT(COMMUNITY_AREA_NAME) DESC
LIMIT 1