#' Get responses from a syllabus
#'
#' @param answerSetId The answer set ID.
#' @param connStr A connection string.
#' @return A data frame with responses.
#' @examples
#' getAnswers('67059790-569b-440f-a858-bddabf313e07', 'mongodb://')
#' @export
#' @import tidyr
#' @import dplyr
getAnswers <- function(answerSetId, connStr) {
  answers <- mongolite::mongo('answers', url = connStr)
  pipeline <- paste0(
    '
    [
        {
            "$match" : {
                "answerSet" : "',answerSetId,'"
            }
        }
    ]
    '
  )

  answerSet <- answers$aggregate(pipeline,options = '{"allowDiskUse":true}')
  return(answerSet)
}
