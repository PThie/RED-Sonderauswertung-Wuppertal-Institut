#----------------------------------------------
# load libraries

suppressPackageStartupMessages({
    library(targets)
    library(here)
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
# processing steps


#----------------------------------------------
# combine all

rlang::list2(

)