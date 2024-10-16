# Description: Support file because dupID is missing in delivered data
# Author: Patrick Thiel

for (TYPE in c("HK", "WK", "WM", "HM")) {
    housing_file <- paste0(TYPE, "_SUF_ohneText")

    housing_data <- haven::read_dta(
        file.path(
            paths()[["org_data_path"]],
            "SUF",
            red_version,
            paste0(housing_file, ".dta")
        )
    )

    housing_data_prep <- housing_data |>
        dplyr::select(obid, spell, amonat, ajahr, emonat, ejahr, dupID_gen)

    data.table::fwrite(
        housing_data_prep,
        file.path(
            paths()[["data_path"]],
            "processed_data",
            "housing_data",
            paste0(TYPE, "_dup.csv")
        )
    )
}
