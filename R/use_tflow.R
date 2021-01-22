##' Setup a tflow project
##'
##' Creates files and directories according to the tflow template.
##'
##' @title use_tflow
##' @return Nothing. Modifies your workspace.
##' @export
use_tflow <- function(){
  usethis::use_directory("R")
  usethis::use_template("packages.R", package = "tflow")
  usethis::use_template("_targets.R", package = "tflow")
  usethis::use_template(".env", package = "tflow")
}

##' Generate a target for an R markdown file
##'
##' @title rmd_target
##' @param target_name of a target to generate rmd target for.
##' @return target text to the console.
##' @author Miles McBain
rmd_target <- function(target_name) {

  report_dir <- getOption('tflow.report_dir') %||% "doc"

  glue::glue("Add this target to your tar_plan():\n",
             "\n",
             "tar_render({target_name}, \"{file.path(report_dir, paste(target_name, 'Rmd', sep = '.'))}\")\n"
  )
}

##' Create an RMarkdown file and generate target definition code.
##'
##' The generated document defaults to the "./doc" folder. This can be overridden
##' with option 'tflow.report_dir'.
##'
##' @title use_rmd
##' @param target_name a name for target and the generated R markdown document.
##' @return the path of the file created. (invisibly)
##' @export
##' @author Miles McBain
use_rmd <- function(target_name) {

  target_file <- paste0(target_name, ".Rmd")

  report_dir <- getOption('tflow.report_dir') %||% "doc"
  file_path <- file.path(report_dir, target_file)

  if (file.exists(file_path)) {
    message(file_path, " already exists and was not overwritten.")
    message(rmd_target(file_path))
    return(invisible(file_path))
  }

  if (!dir.exists(report_dir)) usethis::use_directory(report_dir)

  usethis::use_template("blank.Rmd",
                        save_as = file_path,
                        package = "tflow")

  message(rmd_target(target_name))

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
##' ignores for targets and capsule (renv).
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
                          package = "tflow",
                          save_as = ".gitignore")

}


`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
