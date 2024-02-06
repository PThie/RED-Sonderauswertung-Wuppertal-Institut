# RWI-GEO-RED Sonderauswertung für Wuppertal Institut für Klima, Umwelt und Energie

- Author: Patrick Thiel
- Start date: 29/01/2024

## Task:

### Regional restriction
- Restriction to the areas of Wuppertal and Mannheim for all four data sources (sales and rents)

### Additional spatial information
- Adding spatial information on building block and city district ("Quartierebene")

### Protected historic building
- Adding information on whether the building is protected due to historical reasons
- Note: The data sets on sales already include such a variable. However, the data sets on rents do not have such a variable.
    - Add the information to the sales data set as well and see how good both metrics compare.
- This analysis is only required for the city of Wuppertal.

## Description for the new variables

| Variable  | Description                         |
| --------- | ----------------------------------- |
| city_name | Indicator for the cities in the sample (Mannheim, Wuppertal) |
| city_district | Name of the corresponding city district<br>Refers to "Stadtteile" in the case of Mannheim (original variable labelled as "name") and "Quartiere" in the case of Wuppertal (original variable labelled as "NAME") |
| city_district_id | 

## Disclaimer

All rights reserved to RWI Essen and to the author of the code, Patrick Thiel.