#' Get responses from a syllabus
#'
#' @param task_ids A vector of task ids.
#' @param connStr A connection string.
#' @return A data frame with responses.
#' @examples
#' getResponsesByTask(taskids, 'mongodb://')
#' @export
#' @import tidyr
#' @import dplyr
getResponsesByTask <- function(task_ids, connStr) {
  taskStr <- paste(task_ids,collapse='","')
  questions <- mongolite::mongo('questions', url = connStr)
  pipeline <- paste0(
    '
         [
        {
            "$match" : {
                "taskid" : {
                    "$in" : [
                        "',taskStr,'"
                    ]
                }
            }
        },
        {
            "$project" : {
                "question" : "$question",
                "selected" : "$selected",
                "candidate" : "$pageid",
                "taskid" : "$taskid"
            }
        }
    ]
    '
  )

  responses <- questions$aggregate(pipeline,options = '{"allowDiskUse":true}')
  responses <- responses %>% select(question, selected, candidate) %>% pivot_wider(names_from=question, values_from=selected, names_prefix='Q')
  return(responses)
}
