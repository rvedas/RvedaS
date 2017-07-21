
library(elasticsearchr)

elastic("http://192.168.1.25:9200", "iris", "data") %index% iris

