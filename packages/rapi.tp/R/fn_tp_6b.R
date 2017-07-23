#' Transaction Profile Function to process 6 bolts
#'
#' Transaction Profile Function to process 6 bolts
#' @param df_tp_6b_in Do you love cats? Defaults to TRUE.
#' @keywords Transaction
#' @export
#' @examples
#' df_tp_6b_in <- rapi.tp::fn_tp_6b(df_tp_6b_in)

fn_tp_6b <- function(df_tp_6b_in) {
  library(dplyr)
  
  
  options(digits.secs = 3)
  
  df_tp_6b_in_srt <-
    dplyr::arrange(df_tp_6b_in, transaction_uuid, transaction_time)
  
  # z <- strptime("2017-07-22T20:19:40.767Z", "%Y-%m-%dT%H:%M:%OS", tz = 'UTC')
  
  
  r_bolt_1 <-
    strptime(df_tp_6b_in_srt$transaction_time[1],
             "%Y-%m-%dT%H:%M:%OS",
             tz = 'UTC')
  r_bolt_2 <-
    strptime(df_tp_6b_in_srt$transaction_time[2],
             "%Y-%m-%dT%H:%M:%OS",
             tz = 'UTC')
  r_bolt_3 <-
    strptime(df_tp_6b_in_srt$transaction_time[3],
             "%Y-%m-%dT%H:%M:%OS",
             tz = 'UTC')
  r_bolt_4 <-
    strptime(df_tp_6b_in_srt$transaction_time[4],
             "%Y-%m-%dT%H:%M:%OS",
             tz = 'UTC')
  r_bolt_5 <-
    strptime(df_tp_6b_in_srt$transaction_time[5],
             "%Y-%m-%dT%H:%M:%OS",
             tz = 'UTC')
  r_bolt_6 <-
    strptime(df_tp_6b_in_srt$transaction_time[6],
             "%Y-%m-%dT%H:%M:%OS",
             tz = 'UTC')
  
  
  # (as.numeric(z-y))*1000
  
  r_lego_1 <- (as.numeric(r_bolt_2 - r_bolt_1)) * 1000
  r_lego_2 <- (as.numeric(r_bolt_3 - r_bolt_2)) * 1000
  r_lego_3 <- (as.numeric(r_bolt_4 - r_bolt_3)) * 1000
  r_lego_4 <- (as.numeric(r_bolt_5 - r_bolt_4)) * 1000
  r_lego_5 <- (as.numeric(r_bolt_6 - r_bolt_5)) * 1000
  
  df_tp_6b_out <- data.frame(
    lego_1 = integer(),
    lego_2 = integer(),
    lego_3 = integer(),
    lego_4 = integer(),
    lego_5 = integer(),
    stringsAsFactors = FALSE
  )
  
  df_tp_6b_out <-
    rbind(
      df_tp_6b_out,
      data.frame(
        lego_1 = r_lego_1,
        lego_2 = r_lego_2,
        lego_3 = r_lego_3,
        lego_4 = r_lego_4,
        lego_5 = r_lego_5
      )
    )
  
  return(df_tp_6b_out)

}
