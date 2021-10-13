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
    suppressPackageStartupMessages(source('packages.R'))
  } else {
    message("No `packages.R` found")
  }
  if(dir.exists("R") && length(list.files("R", pattern = "\\.[Rr]$"))) {
    lapply(list.files("R", pattern = "\\.[Rr]$", full.names = TRUE), function(f) {
      tryCatch(source(f, verbose = FALSE),
               error = function(e) {
                 e$message <- paste0("Error in ", f, ": ", e$message)
                 message(e)
               })
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
  cat(format(command), "\n", sep = "")
  eval(command)
}

#' @noRd
#' 
#' @export
rs_make_target_at_cursor_shortcut <- function() {
  rs_make_target_at_cursor(shortcut = TRUE)
}