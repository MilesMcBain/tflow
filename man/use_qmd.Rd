% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/use_tflow.R
\name{use_qmd}
\alias{use_qmd}
\title{use_qmd}
\usage{
use_qmd(target_name)
}
\arguments{
\item{target_name}{a name for target and the generated quarto document.}
}
\value{
the path of the file created. (invisibly)
}
\description{
Create a Quarto file and generate target definition code.
}
\details{
The generated document defaults to the "./doc" folder. This can be overridden
with option 'tflow.report_dir'.
}
\author{
Robert M Flight
}
