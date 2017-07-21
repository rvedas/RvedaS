library("httr")
library(uuid)

number_of_requests <- 10
rclient_id <- 201

for (i in 1:number_of_requests) {
  ruuid <- uuid::UUIDgenerate()
  r <-
    httr::GET(
      "http://24.5.246.173:9101/rvedas/lb/akamai/hw",
      add_headers(transaction_uuid = ruuid, client_id = rclient_id)
    )
  
}
