contains_rmarkdown <- function(filepath) {

  libs_file_lines <-
    readr::read_lines(filepath)

  any(grepl("^library\\(rmarkdown\\)", libs_file_lines))

}

contains_quarto <- function(filepath) {

  libs_file_lines <-
    readr::read_lines(filepath)

  any(grepl("^library\\(quarto\\)", libs_file_lines))

}

current_plan_yaml_entry <- function() {
  yaml_file <- parse_targets_yaml()
  current_file <- rstudioapi::getActiveDocumentContext()$path

  yaml_entry <-
    yaml_file[fs::path_real(yaml_file$script) == fs::path_real(current_file), ]

  if (nrow(yaml_entry) == 0) stop("{tflow} could't find an entry for current active source file in _targets.yaml")
  if (nrow(yaml_entry) > 1) stop("{tflow} found more than one entry in _targets.yaml matching the current active source file")

  yaml_entry
}

parse_targets_yaml <- function() {
  project_yaml <- yaml::read_yaml("./_targets.yaml")
  do.call(rbind,
    lapply(project_yaml, function(x) data.frame(script = x$script, store = x$store)))
}

cat_command <- function(command) cat(trimws(format(command)), "\n", sep = "")
