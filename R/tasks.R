#' Get tasks from a syllabus
#'
#' @param syllabusId The syllabus ID.
#' @param connStr A connection string.
#' @return A data frame with task details
#' @examples
#' getTasksBySyllabus('67059790-569b-440f-a858-bddabf313e07', 'mongodb://')
#' @export
#' @import tidyr
#' @import dplyr
getTasksBySyllabus <- function(syllabusId, connStr) {
  syllabus <- mongolite::mongo('tasks', url = connStr)
  pipeline <- paste0('
    [
        {
            "$match" : {
                "syllabus" : "',syllabusId,'"
            }
        }, {
          "$project" : {
                "_id": "$_id",
                "name" : "$name"
          }
        }
    ]')
  tasks <- syllabus$aggregate(pipeline,options = '{"allowDiskUse":true}')
  return(tasks)
}
