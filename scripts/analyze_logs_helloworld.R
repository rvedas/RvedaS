
# elastic("http://192.168.1.25:9200", "iris", "data") %index% iris
# elastic("http://24.5.246.173:9200", "iris", "data") %index% iris

# load libraries
library(elasticsearchr)
library(dplyr)
library(sqldf)

# index <- hello_world
# type <- transaction_profile
# id <- transaction_uuid

application_name <- "hello_world"
start_time <- "2017-07-22T20:15:00.000Z"
end_time <- "2017-07-22T20:25:00.000Z"


options(digits.secs = 3)


query_kibana_raw <- query(
  '{
  "bool" : {
  "must" : [
  { "term" : {"application_name" : "hello_world"} },
  { "range" : {
  "transaction_time" : {
  "gte": "2017-07-22T20:15:00.000Z",
  "lte": "2017-07-22T20:25:00.000Z"
  }
  }
  }
  ]
  }
  }'
)



df_kibana_raw_logs <-
  elastic("http://24.5.246.173:9200", "filebeat*", "doc") %search% query_kibana_raw



# define hello world transaction profile dataframe - hello_world_api_transaction_profile
# application_name, request_id, server, data_center, entry_time, exit_time, total_time, authentication, credit_score_api, processing_time_1, balance_api, processing_time_2

df_app_transacftion_profile <- data.frame(
  id = character(),
  application_name = character(),
  request_id = character(),
  server = character(),
  data_center = character(),
  entry_time = character(),
  exit_time = character(),
  total_time = character(),
  authentication = character(),
  credit_score_api = character(),
  processing_time_1 = character(),
  balance_api = character(),
  processing_time_2 = character(),
  stringsAsFactors = FALSE
)



# get unique request id's
df_unique_ids <-
  df_kibana_raw_logs %>% dplyr::distinct(transaction_uuid)

# define server matrix
# server  datacenter
# 8f800637430f  east
# 185538c0115c  east
# 4e9f19260c23  west
# 10bd0176a750  west

df_server_matrix = data.frame(
  server = c(
    "8f800637430f",
    "185538c0115c",
    "4e9f19260c23",
    "10bd0176a750"
  ),
  data_center = c("east",
                  "east",
                  "west",
                  "west")
)



# iterate thru each of the transaction and build transaction profile
# rbind each transsaction to df_app_transacftion_profile
# load df_app_transacftion_profile into index 'hello_world' and type 'transaction_profile'


for (i in 1:nrow(df_unique_ids)) {
  df_txn_kibana_raw_logs <-
    dplyr::filter(df_kibana_raw_logs,
                  transaction_uuid == df_unique_ids$transaction_uuid[i])
  
  # count the number of input legos
  # if the count is nox six then populate the fields with appropriate NA description
  
  number_of_input_legos <- nrow(df_txn_kibana_raw_logs)
  
  if (number_of_input_legos != 6) {
    print("populate empty")
    
  }
  
  
  
  if (number_of_input_legos == 6) {
    r_id <- df_txn_kibana_raw_logs$transaction_uuid[1]
    r_application_name <- "hello_world"
    r_request_id <- df_txn_kibana_raw_logs$transaction_uuid[1]
    r_server <- df_txn_kibana_raw_logs$application_host[1]
    
    data_center_sql <-
      sprintf("select data_center from df_server_matrix where server = '%s'",
              r_server)
    r_data_center <- sqldf::sqldf(data_center_sql)
    
    
    df_txn_tp_in <-
      dplyr::select(df_txn_kibana_raw_logs,
                    transaction_uuid,
                    transaction_time)
    
    df_txn_tp_in_srt <-
      dplyr::arrange(df_txn_tp_in, transaction_uuid, transaction_time)
    
    
    # "2017-07-22T20:15:00.000Z"
    
    
    r_entry_time <- df_txn_tp_in_srt$transaction_time[1]
    r_exit_time <- df_txn_tp_in_srt$transaction_time[6]
    
    
    df_txn_tp_out <- rapi.tp::fn_tp_6b(df_txn_tp_in_srt)
    
    # build the legos
    r_lego_1 <- as.integer(df_txn_tp_out$lego_1)
    r_lego_2 <- as.integer(df_txn_tp_out$lego_2)
    r_lego_3 <- as.integer(df_txn_tp_out$lego_3)
    r_lego_4 <- as.integer(df_txn_tp_out$lego_4)
    r_lego_5 <- as.integer(df_txn_tp_out$lego_5)
    
    r_total_time <-
      r_lego_1 + r_lego_2 + r_lego_3 + r_lego_4 + r_lego_5
    
    r_authentication <- r_lego_1
    r_credit_score_api <- r_lego_2
    r_processing_time_1 <- r_lego_3
    r_balance_api <- r_lego_4
    r_processing_time_2 <- r_lego_5
    
    df_app_transacftion_profile <-
      rbind(
        df_app_transacftion_profile,
        data.frame(
          id = r_id[1],
          application_name = r_application_name,
          request_id = r_request_id,
          server = r_server,
          data_center = r_data_center,
          entry_time = r_entry_time,
          exit_time = r_exit_time,
          total_time = r_total_time,
          authentication = r_authentication,
          credit_score_api = r_credit_score_api,
          processing_time_1 = r_processing_time_1,
          balance_api = r_balance_api,
          processing_time_2 = r_processing_time_2
        )
      )
    
  }
  
}
