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
| city_name | Indicator for the cities in the sample (Mannheim, Wuppertal). |
| city_district | Name of the corresponding city district.<br>Refers to "Stadtteile" in the case of Mannheim (original variable labelled as "name") and "Quartiere" in the case of Wuppertal (original variable labelled as "NAME"). |
| city_district_id | Identifier for the corresponding city district.<br>Original variable is labelled as "id" for Mannheim and as "QUARTIER" for Wuppertal. |
| historic_building_id | Identifier for historic buildings in Wuppertal.<br>The variable is a combination of the following original variables: UUID, url_nr, X_impBEZEIC, X_impSTRASS, X_impUMFANG where "url_nr" is the numeric part of the reference URL. |
| missing_geo | No geographic information given. |

## Additional information

- [General information on RWI-GEO-RED](https://www.rwi-essen.de/forschung-beratung/weitere/forschungsdatenzentrum-ruhr/datenangebot/rwi-geo-red-real-estate-data)
- [Data report RWI-GEO-RED v9](https://www.rwi-essen.de/fileadmin/user_upload/RWI/FDZ/Datenbeschreibung-REDv9.pdf)

<!--
## DOI

Placeholder:
[![DOI:<your number>](http://img.shields.io/badge/DOI-<your number>-048BC0.svg)](<doi link>)

-->

## Disclaimer

All rights reserved to RWI Essen and to the author of the code, Patrick Thiel.