#' Get responses from a syllabus
#'
#' @param syllabusId The syllabus ID.
#' @param connStr A connection string.
#' @return A data frame with syllabus details
#' @examples
#' getSyllabus('67059790-569b-440f-a858-bddabf313e07', 'mongodb://')
#' @export
#' @import tidyr
#' @import dplyr
getSyllabus <- function(syllabusId, connStr) {
  syllabus <- mongolite::mongo('syllabuses', url = connStr)
  pipeline <- paste0('
    [
        {
            "$match" : {
                "_id" : "',syllabusId,'"
            }
        }
    ]')
    syllabusO <- syllabus$aggregate(pipeline,options = '{"allowDiskUse":true}')
    return(syllabusO)
}
