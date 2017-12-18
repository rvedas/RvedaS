require(httr)
require(jsonlite)

end_url <- "http://localhost:9082/exprvedas"
num_of_calls <- 10

get_rvedas <- GET(end_url)
get_rvedas_text <- content(get_rvedas, "text")
get_rvedas_json <- fromJSON(get_rvedas_text, flatten = TRUE)
get_rvedas_df <- as.data.frame(get_rvedas_json)

if (num_of_calls > 1) {
  for (i in 2:num_of_calls) {
    get_rvedas_2 <- GET(end_url)
    get_rvedas_text_2 <- content(get_rvedas_2, "text")
    get_rvedas_json_2 <- fromJSON(get_rvedas_text_2, flatten = TRUE)
    get_rvedas_df_2 <- as.data.frame(get_rvedas_json_2)
    get_rvedas_df <- rbind(get_rvedas_df, get_rvedas_df_2)
  }
}
