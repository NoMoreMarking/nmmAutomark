% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/answers.R
\name{getAnswers}
\alias{getAnswers}
\title{Get the answer set from a syllabus}
\usage{
getAnswers(answerSetId, connStr)
}
\arguments{
\item{answerSetId}{The answer set ID.}

\item{connStr}{A connection string.}
}
\value{
A data frame with responses.
}
\description{
Get the answer set from a syllabus
}
\examples{
getAnswers('67059790-569b-440f-a858-bddabf313e07', 'mongodb://')
}
