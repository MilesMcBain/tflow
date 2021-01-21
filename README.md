# tflow

An opinionated lightweight template for smooth `targets` flows.

A sibling of [dflow](https://github.com/milesmcbain/dflow)

## Installation

```r
remotes::install_github("milesmcbain/tflow")
```

Set `dependencies = TRUE` to also install [capsule](https://github.com/MilesMcBain/capsule), [conflicted](https://github.com/r-lib/conflicted), [dontenv](https://github.com/gaborcsardi/dotenv), [targets](https://docs.ropensci.org/drake), and [tarchetypes](https://github.com/ropensci/tarchetypes).

## Usage

`tflow::use_tflow()`:

```
 ./
 |_ R/
 |_ _targets.R
 |_ packages.R
 |_ .env
```

`tflow::use_rmd("analysis")`:

```
√ Creating 'doc/'
√ Writing 'doc/analysis.Rmd'
Add this target to your tar_plan():

tar_render(report, "doc/analysis..Rmd")

√ library(rmarkdown) added to ./packages.R
```

`tflow::use_gitignore()`:

Drop in a starter `./.gitignore` with ignores for `drake` and `renv` among others.


## About

`tflow` is a port of `dflow` from `targets` to `drake`. `targets` can be used many ways, and it turns out it can be used in an almost identical workflow to `dflow`. 

`tflow` tries to set up a minimalist ergonomic workflow for `targets` pipeline
development. To get the most out of it follow these tips:

1. Put all your target code in separate functions in `R/`. Use `fnmate` to
   quickly generate function definitions in the right place. Let the plan in `_targets.R` define
   the structure of the workflow and use it as a map for your sources. Use 'jump
   to function' to quickly navigate to them.

2. Use a call `tar_make()` to kick off building your plan in a new R session.
  
3. Put all your `library()` calls into `packages.R`. This way you'll have them
   in one place when you go to add sandboxing with `renv`, `packarat`, and
   `switchr` etc.

4. Take advantage of automation for loading `targets` targets at the cursor with the 'loadd target at cursor' addin.

## Opinions

Some things are baked into the template that will help you avoid common pitfalls
and make your project more reproducible:

1. `library(conflicted)` is called in `packages.R` to detect package masking issues.

2. `.env` is added carrying the following options to avoid misuse of logical vector tests:

```
_R_CHECK_LENGTH_1_LOGIC2_=verbose
_R_CHECK_LENGTH_1_CONDITION_=true
```
