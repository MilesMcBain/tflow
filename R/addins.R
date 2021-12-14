get_current_editor_symbols <- function() {
  document_content <-
    paste0(
      rstudioapi::getActiveDocumentContext()$contents,
      collapse = "\n"
    )
  document_tokens <-
    sourcetools::tokenize_string(document_content)
  document_tokens[document_tokens$type == "symbol", "value"]
}


#' @export
#' @noRd
rs_load_current_editor_targets <- function() {
  load_env <- parent.frame()
  local_symbols <- get_current_editor_symbols()
  project_targets <- targets::tar_meta(targets_only = TRUE)$name
  local_targets <- intersect(local_symbols, project_targets)
  load_targets <-
    lapply(
      local_targets,
      function(x) bquote(targets::tar_load(.(as.symbol(x)), envir = load_env))
    )
  loaded_targets <-
    lapply(load_targets, function(x) {
      eval(x)
      format(x)
    })
  cat(paste0(unlist(loaded_targets), collapse = "\n"), "\n")
}

#' @export
#' @noRd
tflow_load_all <- function() {
  message("\nLoading `packages.R` and `R/*.R`")
  if (file.exists("packages.R")) {
    suppressPackageStartupMessages(source("packages.R"))
  } else {
    message("No `packages.R` found")
  }
  if (dir.exists("R") && length(list.files("R", pattern = "\\.[Rr]$"))) {
    lapply(list.files("R", pattern = "\\.[Rr]$", full.names = TRUE), function(f) {
      tryCatch(
        source(f, verbose = FALSE),
        error = function(e) {
          e$message <- paste0("Error in ", f, ": ", e$message)
          message(e)
        }
      )
    })
  } else {
    message("No R source files found in R/ directory")
  }
  invisible()
}

#' @noRd
#'
#' @export
rs_make_target_at_cursor <- function(shortcut = FALSE) {
  word_or_selection <- atcursor::get_word_or_selection()
  command <- bquote(targets::tar_make(.(as.symbol(word_or_selection)), shortcut = shortcut))
  cat_command(command)
  eval(command)
}

#' @noRd
#' @export
rs_tar_make_current_plan <- function() {

  if (!file.exists("_targets.yaml")) {
    cat_command(quote(targets::tar_make()))
    targets::tar_make()
    return()
  }

  yaml_file <- parse_targets_yaml()
  current_file <- fs::path_file(rstudioapi::getActiveDocumentContext()$path)

  yaml_entry <-
    yaml_file[yaml_file$script == current_file, ]

  if (nrow(yaml_entry) == 0) stop("{tflow} could't find an entry for current active source file in _targets.yaml")
  if (nrow(yaml_entry) > 1) stop("{tflow} found more than one entry in _targets.yaml matching the current active source file")

  make_command <- bquote(targets::tar_make(script = .(yaml_entry$script), store = .(yaml_entry$store)))
  cat_command(make_command)
  eval(make_command)
}

#' @export
#' @noRd 
rs_load_target_at_cursor_from_any_plan <- function() {
  if (!file.exists("_targets.yaml")) {
    return(targets:::tar_rstudio_addin_load())
  }
  selected_target <- atcursor::get_word_or_selection()
  yaml_file <- parse_targets_yaml()
  eval_env <- parent.frame()
  for (row in seq(nrow(yaml_file))) {
    yaml_entry <- yaml_file[row, ]
    current_meta <- tryCatch(
      targets::tar_meta(store = yaml_entry$store),
      # there may be no meta for this plan
      error = function(e) NULL
    )
    # if there was no meta continue search
    if (is.null(current_meta)) next

    if (any(current_meta$name == selected_target)) {
      found_store_entry <- TRUE
      load_command <- bquote(targets::tar_load(.(as.symbol(selected_target)), store = .(yaml_entry$store)))
      cat_command(load_command)
      return(eval(load_command, envir = eval_env))
    }
  }
  # if we got here we didn't find any matching targets in any stores
  stop("{tflow} couldn't find ", selected_target, " in any of the stores in _targets.yaml")
}

#' 
#' @export
rs_make_target_at_cursor_shortcut <- function() {
  rs_make_target_at_cursor(shortcut = TRUE)
}

parse_targets_yaml <- function() {
  project_yaml <- yaml::read_yaml("../interactive_location_analytics/_targets.yaml")
  do.call(rbind,
    lapply(function(x) data.frame(script = x$script, store = x$store)))
}

cat_command <- function(command) cat(format(command), "\n", sep = "")

