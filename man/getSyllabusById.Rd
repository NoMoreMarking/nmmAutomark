% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/syllabus.R
\name{getSyllabusById}
\alias{getSyllabusById}
\title{Get responses from a syllabus}
\usage{
getSyllabusById(syllabusId, connStr)
}
\arguments{
\item{syllabusId}{The syllabus ID.}

\item{connStr}{A connection string.}
}
\value{
A data frame with syllabus details
}
\description{
Get responses from a syllabus
}
\examples{
getSyllabus('67059790-569b-440f-a858-bddabf313e07', 'mongodb://')
}
