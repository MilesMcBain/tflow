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
