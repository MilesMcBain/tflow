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
  usethis::use_template(".env", package = "dflow")
}

##' Generate a target for an R markdown file
##'
##' @title use_rmd_target
##' @param file_path a file to generate target text for.
##' @return target text to the console.
##' @author Miles McBain
rmd_target <- function(file_path) {

  target_file <- file_path
  target_file_prefix <- gsub(pattern = "\\.[rmd]{3}$",
                             replacement = "",
                             x = file_path,
                             ignore.case = TRUE)

  glue::glue("Add this target to your drake plan:\n",
             "\n",
             "target_name = target(\n",
             "  command = {{\n",
             "    rmarkdown::render(knitr_in(\"{target_file}\"))\n",
             "    file_out(\"{target_file_prefix}.html\")\n",
             "  }}\n",
             ")\n",
             "\n",
             "(change output extension as appropriate if output is not html)")
}

##' Create an RMarkdown file and generate target definition code.
##'
##' The generated document defaults to the "./doc" folder. This can be overridden
##' with option 'dflow.report_dir'.
##'
##' Due to the way RMarkdown and Knitr use relative paths to the source document
##' it can be messy to properly tag the input and output documents for an Rmd target. This
##' function will generate a multi-expression target using `drake::target()`
##' that uses a clean and simple way to mark these up for drake.
##'
##' The contents of the `file_out()` call my need to be modified depending on
##' the output file extension and path configured in the Rmd and call to `render()`.
##'
##' @title use_rmd
##' @param target_file a filename for the generated R markdown document.
##' @return the path of the file created. (invisibly)
##' @export
##' @author Miles McBain
use_rmd <- function(target_file) {

  ## add an .Rmd extension if it was not specified
  if (!grepl("\\.Rmd$",
             target_file,
             ignore.case = FALSE)) {
    target_file <- paste0(target_file, ".Rmd")
  }

  report_dir <- getOption('dflow.report_dir') %||% "doc"
  file_path <- file.path(report_dir, target_file)

  if (file.exists(file_path)) {
    message(file_path, " already exists and was not overwritten.")
    message(rmd_target(file_path))
    return(invisible(file_path))
  }

  if (!dir.exists(report_dir)) usethis::use_directory(report_dir)

  usethis::use_template("blank.Rmd",
                        save_as = file_path,
                        package = "dflow")

  message(rmd_target(file_path))

  if (file.exists("./packages.R") && !contains_rmarkdown("./packages.R")) {
    packages <- readr::read_lines("./packages.R")
    packages <- c(packages, "library(rmarkdown)")
    readr::write_lines(packages, "./packages.R")
    message(cli::symbol$tick," Writing 'library(rmarkdown)' to './packages.R'")
  }

 invisible(file_path)

}

##' Use a starter .gitignore
##'
##' Drop a starter .gitignore in the current working directory, including
##' ignores for drake and capsule (renv).
##'
##' @title use_gitignore
##' @return nothing, creates a file.
##' @author Miles McBain
##' @export
use_gitignore <- function() {

  if (file.exists("./.gitignore")) {
    message("./.gitignore file already exists and was not overwritten.")
    invisible(return(NULL))
  }

    usethis::use_template(template = "_gitignore",
                          package = "dflow",
                          save_as = ".gitignore")

}


`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
