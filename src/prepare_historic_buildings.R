prepare_historic_buildings <- function(utmcrs = NA) {
    #' @title Preparation of historic buildings in Wuppertal
    #' 
    #' @description This function prepares the historic buildings in Wuppertal.
    #' The information was provided by the Wuppertal Institute.
    #' 
    #' @param utmcrs UTM (32632) projection
    #' 
    #' @return Spatial Dataframe with city districts
    #' @author Patrick Thiel
    
    #----------------------------------------------
    # load data

    historic_buildings <- sf::st_read(
        file.path(
            paths()[["data_path"]],
            "raw_data",
            "protected_buildings",
            "Objekte_denkmalschutz_Wuppertal.gpkg"
        ),
        quiet = TRUE
    )

    #----------------------------------------------
    # clean data

    # set geometry columns
    sf::st_geometry(historic_buildings) <- "geometry"

    # select only ID and geometry
    historic_buildings <- historic_buildings |>
        dplyr::mutate(
            url_nr = stringr::str_extract(X_impURL, "\\d+"),
            historic_building_id = paste0(UUID, url_nr, X_impBEZEIC, X_impSTRASS, X_impUMFANG),
            historic_building_id = stringr::str_replace_all(historic_building_id, " ", ""),
            historic_building_id = stringr::str_replace_all(historic_building_id, "\\.", ""),
            historic_building_id = stringr::str_replace_all(historic_building_id, "-", ""),
            historic_building_id = stringi::stri_trans_general(historic_building_id, "DE-ASCII; Latin-ASCII"),
        ) |>
        sf::st_transform(crs = utmcrs)
    
    #----------------------------------------------
    # export

    sf::st_write(
        historic_buildings,
        file.path(
            paths()[["data_path"]],
            "processed_data",
            "geo_information",
            "wuppertal_historic_buildings.gpkg"
        ),
        quiet = TRUE,
        append = FALSE
    )

    #----------------------------------------------
    # keep only ID and geometry for further processing

    historic_buildings <- historic_buildings |>
        dplyr::select(
            historic_building_id,
            geometry
        )

    #----------------------------------------------
    # return

    return(historic_buildings)
}