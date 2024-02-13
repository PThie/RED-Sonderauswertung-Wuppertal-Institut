#----------------------------------------------
# description

# This file is main file that orchestrates the other coding files. It controls
# the data pipeline and defines global settings.

#----------------------------------------------
# load libraries

suppressPackageStartupMessages({
    library(renv)
    library(targets)
    library(tarchetypes)
    library(here)
    library(sf)
    library(qs)
    library(data.table)
    library(stringi)
    library(stringr)
    library(docstring)
    library(rlang)
    library(dplyr)
})

#----------------------------------------------
# set working directory

setwd(here())

#----------------------------------------------
# load configurations

source(
    file.path(
        here(),
        "src",
        "helpers",
        "config.R"
    )
)

#----------------------------------------------
# load R scripts

lapply(
    list.files(
        paths()[["code_path"]],
        pattern = "\\.R$",
        full.names = TRUE,
        ignore.case = TRUE
    ),
    source
)

#----------------------------------------------
# define globals

utmcrs <- 32632 # refers to WGS 84 / UTM zone 32N (https://epsg.io/32632)
red_version <- "v9"

#----------------------------------------------
# data frame for loop through the housing data

housing_data_info <- data.frame(
    cbind(
        housing_type = c("HM", "HK", "WM", "WK")
    )
) |>
    dplyr::mutate(
        housing_type_file_name = paste0(housing_type, "_allVersions_ohneText")
    )

#----------------------------------------------
# processing steps

# Preparation of the provided geographical data
targets_preparation_geo <- rlang::list2(
    #----------------------------------------------
    tar_qs(
        prepared_mannheim_districts,
        prepare_mannheim_districts(
            utmcrs = utmcrs
        )
    ),
    tar_qs(
        prepared_wuppertal_districts,
        prepare_wuppertal_districts(
            utmcrs = utmcrs
        )
    ),
    tar_qs(
        prepared_historic_buildings,
        prepare_historic_buildings(
            utmcrs = utmcrs
        )
    )
)

# Preparation of the housing data
targets_preparation_housing <- tar_map(
    tar_qs(
        housing_data,
        prepare_housing_data(
            utmcrs = utmcrs,
            housing_file = housing_type_file_name,
            red_version = red_version,
            prepared_mannheim_districts = prepared_mannheim_districts,
            prepared_wuppertal_districts = prepared_wuppertal_districts,
            prepared_historic_buildings = prepared_historic_buildings
        )
    ),
    values = housing_data_info,
    names = housing_type
)

#----------------------------------------------
# combine all

rlang::list2(
    targets_preparation_geo,
    targets_preparation_housing
)