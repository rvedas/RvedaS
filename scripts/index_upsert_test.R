#id = c(1, 2, 3, 4) 
# 8f481943-c022-4010

id = c("8f481943-c022-4011", "8f481943-c022-4012","8f481943-c022-4013","8f481943-c022-4014") 
fname = c("shiva", "kavitha", "mahi", "rajiv") 
lname = c("raju", "raju","raju","raju")
ssn = c("121", "131","141","151" ) 
df_test = data.frame(id, fname, lname, ssn) 

elastic("http://24.5.246.173:9200", "nandimandalam", "family_members") %index% df_test

