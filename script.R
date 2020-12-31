getwd()

install.packages('rvest')
install.packages('dplyr')
install.packages('lubridate')
install.packages('mdy')

library(rvest)
library(stringr)
library(dplyr)
library(lubridate)
library(readr)

# Leitura da web page - retorna um documento xml
?read_html
webpage <- read_html('https://www.nytimes.com/interactive/2017/06/23/opinion/trumps-lies.html')
webpage

?html_nodes

results <- webpage %>% html_nodes('.short-desc')
results

records <- vector('list', length = length(results))
records


# loop para pegar os campos

for (i in seq_along(results)) {
  date <- str_c(results[i] %>%
                  
                  html_nodes("strong") %>%
                  html_text(trim = TRUE), ', 2017')
  
  lie <- str_sub(xml_contents(results[i])[2] %>% html_text(trim = TRUE), 2, -2)
  
  explanation <- str_sub(results[i] %>% 
                           
                          html_nodes(".short-truth") %>% 
                          html_text(trim = TRUE), 2, -2)
  
  url <- results[i] %>%
    
    html_nodes("a") %>%
    html_attr("href")
  
  
  records[[i]] <- data_frame(date = date, lie = lie, explanation = explanation, url = url)
}

# dataset final
df <- bind_rows(records)

View(df)

# Tranformando o campo data em formato Date em R
df$date <- mdy(df$date)

# exportando para csv
write_csv(df, 'mentiras_trump.csv')






