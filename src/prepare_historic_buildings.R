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
            "Baudenkmaeler_EPSG3857_SHAPE",
            "Baudenkmaeler_EPSG3857_SHAPE.shp"
        ),
        quiet = TRUE
    )

    #----------------------------------------------
    # clean data

    historic_buildings <- historic_buildings |>
        dplyr::select(
            historic_building_id = NR_DENKMAL,
            geometry
        ) |>
        sf::st_transform(crs = utmcrs)

    #----------------------------------------------
    # export

    qs::qsave(
        historic_buildings,
        file.path(
            paths()[["data_path"]],
            "processed_data",
            "geo_information",
            "wuppertal_historic_buildings.qs"
        )
    )

    #----------------------------------------------
    # return

    return(historic_buildings)
}