##' Setup a dflow project
##'
##' Creates files and directories according to the dflow template.
##'
##' @title use_dflow
##' @return Nothing. Modifies your workspace.
##' @export
use_dflow <- function(){
  usethis::use_directory("R")
  usethis::use_template("packages.R", package = "dflow")
  usethis::use_template("_drake.R", package = "dflow")
  usethis::use_template("plan.R", save_as = "/R/plan.R", package = "dflow")
}

##' Generate a target for an R markdown file
##'
##' Due to the way RMarkdown and Knitr use relative paths to the source document
##' it can be messy to properly tag the input and output documents for an Rmd target. This
##' function will generate a multi-expression target using `drake::target()`
##' that uses a clean and simple way to mark these up for drake.
##'
##' The contents of the `file_out()` call my need to be modified depending on
##' the output file extension and path configured in the Rmd and call to `render()`.
##'
##' @title use_rmd_target
##' @param target_file 
##' @return target text to the console.
##' @author Miles McBain
use_rmd_target <- function(target_file = NULL) {

  if (is.null(target_file)) {

    rmd_files <- list.files(path = ".",
                            pattern="rmd$",
                            recursive = TRUE,
                            ignore.case = TRUE,
                            include.dirs = TRUE)

    choice <- menu(title = "Select an rmd file to make a target", choices = rmd_files)
    target_file <- rmd_files[choice]
  }

  target_file_prefix <- gsub(pattern = "\\.[rmd]{3}$",
                             replacement = "",
                             x = target_file,
                             ignore.case = TRUE)

  glue::glue("Add this target to your drake plan:\n",
             "\n",
             "target_name = target(rmarkdown::render(knitr_in(\"{target_file}\")),\n",
             "                     file_out(\"{target_file_prefix}.html\")\n",
             "\n",
             "(change output extension as appropriate if output is not html)")
}


