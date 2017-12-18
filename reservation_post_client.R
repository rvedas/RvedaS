require(httr)
require(jsonlite)

url <- "http://localhost:8081/reservation"

reservation_id_start <- 501
r_reservation_id <- reservation_id_start
num_of_calls <- 50

if (num_of_calls > 0) {
  for (i in 1:num_of_calls) {
    if (i == 1) {
      r_reservation_id <- r_reservation_id
    } else {
      r_reservation_id <- r_reservation_id + 1
    }
    
    r_body_1 <- '{
    "reservation_id" : '
    
    r_body_2 <- r_reservation_id
    
    r_body_3 <- ',
    "customer_first_name" : "sivaji",
    "customer_last_name" : "nandimandalam",
    "date_of_rental" : "2017-12-25"
  }'

    body <- paste0(r_body_1, r_body_2, r_body_3)
    
    r <- POST(url, body = body, encode = "json")
}
  }
