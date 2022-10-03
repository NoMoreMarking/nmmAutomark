#' Get responses from a syllabus
#'
#' @param syllabusId The syllabus ID.
#' @param connStr A connection string.
#' @return A data frame with responses.
#' @examples
#' getSyllabusResponses('67059790-569b-440f-a858-bddabf313e07', 'mongodb://')
#' @export
#' @import tidyr
#' @import dplyr
getSyllabusResponses <- function(syllabusId, connStr) {
  tasks <- mongolite::mongo('pages', url = connStr)
  pipeline <- paste0(
    '
     [
        {
            "$match" : {
                "syllabus" : "',syllabusId,'"
            }
        },
        {
            "$lookup" : {
                "from" : "questions",
                "localField" : "_id",
                "foreignField" : "pageid",
                "as" : "questionResponses"
            }
        },
        {
            "$unwind" : {
                "path" : "$questionResponses",
                "preserveNullAndEmptyArrays" : false
            }
        },
        {
            "$project" : {
                "rawTotal" : "$rawTotal",
                "selected" : "$questionResponses.selected",
                "question" : "$questionResponses.question",
                "person" : "$questionResponses.pageid"
            }
        }
    ]
    '
  )

  responses <- tasks$aggregate(pipeline,options = '{"allowDiskUse":true}')
  responses <- responses %>% pivot_wider(names_from=question, values_from=selected, names_prefix='Q')
  responses <- responses %>% select(-`_id`)
  return(responses)
}
