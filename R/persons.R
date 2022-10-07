#' Get responses from a syllabus
#'
#' @param task_ids A vector of task ids.
#' @param connStr A connection string.
#' @return A data frame with responses.
#' @examples
#' getPersonsByTask(taskids, 'mongodb://')
#' @export
#' @import tidyr
#' @import dplyr
#' @import jsonlite
getPersonsByTask <- function(task_ids, connStr) {
  taskStr <- paste(task_ids,collapse='","')
  pages <- mongolite::mongo('pages', url = connStr)
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
                "bio" : "$bio"
            }
        }
    ]
    '
  )

  persons <- pages$aggregate(pipeline,options = '{"allowDiskUse":true}')
  fpersons <- jsonlite::flatten(persons)
  return(fpersons)
}
