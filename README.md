# dflow

An opinionated lightweight template for smooth `drake` flows.

## Installation

```r
remotes::install_github("milesmcbain/dflow")
```

Set `dependencies = TRUE` to also install [capsule](https://github.com/MilesMcBain/capsule), [conflicted](https://github.com/r-lib/conflicted), [dontenv](https://github.com/gaborcsardi/dotenv), and [drake](https://docs.ropensci.org/drake).

## Usage

`dflow::use_dflow()`:

```
 ./
 |_ R/
 |  |_ plan.R
 |
 |_ _drake.R
 |_ packages.R
 |_ .env
```

`dflow::use_rmd("analysis.Rmd")`:

```
v Creating 'doc/'
v Writing 'doc/analysis.Rmd'
Add this target to your drake plan:

target_name = target(
  command = {
    rmarkdown::render(knitr_in("doc/analysis.Rmd")),
    file_out("doc/analysis.html")
  }
)

(change output extension as appropriate if output is not html)
library(rmarkdown) added to ./packages.R
```

`dflow::use_gitignore()`:

Drop in a starter `./.gitignore` with ignores for `drake` and `renv` among others.



## About

`dflow` tries to set up a minimalist ergonomic workflow for `drake` pipeline
development. To get the most out of it follow these tips:

1. Put all your target code in separate functions in `R/`. Use `fnmate` to
   quickly generate function definitions in the right place. Let `plan.R` define
   the structure of the workflow and use it as a map for your sources. Use 'jump
   to function' to quickly navigate to them.

2. Use a call r_make() to kick off building your plan in a new R session (via
   `callr`). `_drake.R` is setup to make this work. Bind a keyboard shortcut to
   this using the addin in drake.

3. Put all your `library()` calls into `packages.R`. This way you'll have them
   in one place when you go to add sandboxing with `renv`, `packarat`, and
   `switchr` etc.

4. Take advantage of automation for loading drake targets at the cursor with the
   'loadd target at cursor' addin.

## Opinions

Some things are baked into the template that will help you avoid common pitfalls
and make your project more reproducible:

1. `library(conflicted)` is called in `packages.R` to detect package masking issues.

2. `.env` is added carrying the following options to avoid misuse of logical vector tests:

```
_R_CHECK_LENGTH_1_LOGIC2_=verbose
_R_CHECK_LENGTH_1_CONDITION_=true
```
