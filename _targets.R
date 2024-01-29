#----------------------------------------------
# load libraries

suppressPackageStartupMessages({
    library(targets)
    library(tarchetypes)
    library(here)
    library(sf)
    library(qs)
    library(docstring)
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

utmcrs = 32632

#----------------------------------------------
# processing steps

targets_preparation <- rlang::list2(
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
    )
)


#----------------------------------------------
# combine all

rlang::list2(
    targets_preparation
)