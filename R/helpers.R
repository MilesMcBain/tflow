contains_rmarkdown <- function(filepath) {

  libs_file_lines <-
    readr::read_lines(filepath)

  any(grepl("^library\\(rmarkdown\\)", libs_file_lines))

}
