prepare_housing_data <- function(
    utmcrs = NA,
    housing_file = NA,
    red_version = NA,
    prepared_mannheim_districts = NA,
    prepared_wuppertal_districts = NA,
    prepared_historic_buildings = NA
) {
    #' @title Prepare housing data
    #' 
    #' @description This function prepares the housing data for the analysis with
    #' the focus on Mannheim and Wuppertal.
    #' 
    #' @param utmcrs UTM (32632).
    #' @param housing_file Name of the housing data file.
    #' @param red_version Version of the housing data.
    #' @param prepared_mannheim_districts Prepared Mannheim districts.
    #' @param prepared_wuppertal_districts Prepared Wuppertal districts.
    #' 
    #' @return Prepared housing data.
    #' @author Patrick Thiel

    #----------------------------------------------
    # read data

    housing_data <- haven::read_dta(
        file.path(
            paths()[["org_data_path"]],
            "On-site",
            red_version,
            paste0(housing_file, ".dta")
        )
    )

    #----------------------------------------------
    # subset for Mannheim and Wuppertal

    mannheim_ags <- 8222000
    wuppertal_ags <- 5124000

    housing_data_prep <- housing_data |>
        dplyr::filter(
            gid2019 %in% c(mannheim_ags, wuppertal_ags)
        ) |>
        # add city name
        dplyr::mutate(
            city_name = dplyr::case_when(
                gid2019 == mannheim_ags ~ "Mannheim",
                gid2019 == wuppertal_ags ~ "Wuppertal"
            )
        )

    #----------------------------------------------
    # add additional regional information

    join_data <- function(city = NA, join_data = NA) {
        # filter for city housing data
        city_data <- housing_data_prep |>
            dplyr::filter(
                city_name == city
            )

        # transform to sf object
        city_data_sf <- sf::st_as_sf(
            city_data,
            coords = c("lon_gps", "lat_gps"),
            crs = 4326
        ) |>
        sf::st_transform(crs = utmcrs)

        # join data
        joint_data <- suppressWarnings(sf::st_join(
            city_data_sf,
            join_data,
            left = TRUE,
            largest = TRUE
        ))

        # return
        return(joint_data)
    }

    # apply function
    mannheim_data <- join_data(
        city = "Mannheim",
        join_data = prepared_mannheim_districts
    )

    wuppertal_data <- join_data(
        city = "Wuppertal",
        join_data = prepared_wuppertal_districts
    )

    #----------------------------------------------
    # add historic buildings by nearest neighbor

    wuppertal_data <- sf::st_join(
        wuppertal_data,
        prepared_historic_buildings,
        left = TRUE
    )

    # add historic ID to mannheim data as well
    mannheim_data <- mannheim_data |>
        dplyr::mutate(
            historic_building_id = NA_character_
        )

    #----------------------------------------------
    # combine data again

    combined_data <- dplyr::bind_rows(
        mannheim_data,
        wuppertal_data
    )

    # add indicator for missing geo coordinate
    combined_data <- combined_data |>
        dplyr::mutate(
            missing_geo = dplyr::case_when(
                lon_utm == -9 | lat_utm == -9 ~ 1,
                TRUE ~ 0
            )
        )

    # drop geometry
    combined_data <- sf::st_drop_geometry(combined_data)

    #----------------------------------------------
    # remove spatial information at individual level
    # replace Umlaute

    combined_data <- combined_data |>
        dplyr::select(
            -c(
                "ergg_1km",
                "lon_utm",
                "lat_utm",
                "geox",
                "geoy",
                "strasse",
                "ort",
                "hausnr",
                "koid",
                "laid",
                "skid_id",
                "sc_id",
                "ident",
                "merge_gid",
                "is24_stadt_kreis"
            )
        ) |>
        dplyr::mutate(
            city_district = stringi::stri_trans_general(city_district, "de-ASCII; Latin-ASCII")
        )
    
    #----------------------------------------------
    # export

    data.table::fwrite(
        combined_data,
        file.path(
            paths()[["data_path"]],
            "processed_data",
            "housing_data",
            paste0(substring(housing_file, 1, 2), "_prepared.csv")
        ),
        na = NA,
        sep = ";"
    )

    #----------------------------------------------
    # return

    return(combined_data)
}
