## Load your packages, e.g. library(targets).
source(here::here("./packages.R"))

## Load your R files
lapply(list.files(here::here("./R"), full.names = TRUE), source)

## tar_plan supports drake-style targets and also tar_target()
tar_plan(

# target = function_to_make(arg), ## drake style

# tar_target(target2, function_to_make2(arg)) ## targets style

)

