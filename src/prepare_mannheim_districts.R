prepare_mannheim_districts <- function(utmcrs = NA) {
    #' @title Preparation of city districts of Mannheim
    #' 
    #' @description This function prepares the city districts of Mannheim. The
    #' information was provided by the Wuppertal Institute.
    #' 
    #' @param utmcrs UTM (32632) projection
    #' 
    #' @return Spatial Dataframe with city districts
    #' @author Patrick Thiel
    
    #----------------------------------------------
    # read data

    mannheim_districts <- sf::st_read(
        file.path(
            paths()[["data_path"]],
            "raw_data",
            "provided_geo_info",
            "Stadtteile",
            "Stadtteile_Mannheim.shp"
        ),
        quiet = TRUE
    )

    #----------------------------------------------
    # clean data

    mannheim_districts <- mannheim_districts |>
        dplyr::select(
            city_district = name,
            city_district_id = id,
            geometry
        ) |>
        sf::st_transform(crs = utmcrs)

    #----------------------------------------------
    # export

    qs::qsave(
        mannheim_districts,
        file.path(
            paths()[["data_path"]],
            "processed_data",
            "geo_information",
            "mannheim_city_districts.qs"
        )
    )

    #----------------------------------------------
    # return

    return(mannheim_districts)
}