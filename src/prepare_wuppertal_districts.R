prepare_wuppertal_districts <- function(utmcrs = NA) {
    #' @title Preparation of city districts of Wuppertal
    #' 
    #' @param utmcrs UTM (32632) projection
    #' 
    #' @return Spatial Dataframe with city districts
    #' @author Patrick Thiel
    
    #----------------------------------------------
    # read data

    wuppertal_districts <- sf::st_read(
        file.path(
            paths()[["data_path"]],
            "raw_data",
            "provided_geo_info",
            "Quartiere_Mirke_Oelberg",
            "Quartiere_Mirke_Oelberg.shp"
        ),
        quiet = TRUE
    )

    #----------------------------------------------
    # clean data

    wuppertal_districts <- wuppertal_districts |>
        dplyr::select(
            city_district = NAME,
            city_district_id = QUARTIER,
            geometry
        ) |>
        sf::st_transform(crs = utmcrs)

    #----------------------------------------------
    # export

    qs::qsave(
        wuppertal_districts,
        file.path(
            paths()[["data_path"]],
            "processed_data",
            "geo_information",
            "wuppertal_city_districts.qs"
        )
    )

    #----------------------------------------------
    # return

    return(wuppertal_districts)
}