# dflow

An opinionated lightweight template for smooth `drake` flows.

## Installation

`remotes::install_github("milesmcbain/dflow")`

## Usage

`dflow::use_dflow()`:

```


 ./
 |_ R/
    |_ plan.R
 |
 |_ _drake.R
 |_ packages.R

```

## About

`dflow` tries to set up a minimalist ergonomic workflow for `drake` pipeline development. To get the most out of it follow these tips:

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
