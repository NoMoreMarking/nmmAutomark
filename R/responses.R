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
                "let" : {
                    "task" : "$_id"
                },
                "pipeline" : [
                    {
                        "$match" : {
                            "$expr" : {
                                "$eq" : [
                                    "$$task",
                                    "$pageid"
                                ]
                            }
                        }
                    },
                    {
                        "$project" : {
                            "question" : 1.0,
                            "selected" : 1.0,
                            "pageid" : 1.0
                        }
                    }
                ],
                "as" : "questionResponses"
            }
        },
        {
            "$unwind" : {
                "path" : "$questionResponses",
                "preserveNullAndEmptyArrays" : false
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
