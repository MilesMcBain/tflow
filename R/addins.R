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
  loaded_targets <-
    lapply(local_targets, function(x) bquote(targets::tar_load(.(as.symbol(x)), envir = load_env))) %>%
    lapply(function(x) {
      eval(x)
      format(x)
    })
  cat(paste0(unlist(loaded_targets), collapse = "\n"), "\n")
}
