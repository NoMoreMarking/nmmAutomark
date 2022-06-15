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
  tasks <- mongolite::mongo('tasks', url = connStr)
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
                "from" : "pages",
                "localField" : "_id",
                "foreignField" : "taskid",
                "as" : "taskPages"
            }
        },
        {
            "$unwind" : {
                "path" : "$taskPages",
                "preserveNullAndEmptyArrays" : false
            }
        },
        {
            "$lookup" : {
                "from" : "questions",
                "localField" : "taskPages._id",
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
                "task" : "$name",
                "dfe" : "$school",
                "yg" : "$yg",
                "rawTotal" : "$rawTotal",
                "selected" : "$questionResponses.selected",
                "question" : "$questionResponses.question",
                "person" : "$questionResponses.pageid",
                "firstName" : "$taskPages.bio.firstName",
                "lastName" : "$taskPages.bio.lastName",
                "dob" : "$taskPages.bio.dob"
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
