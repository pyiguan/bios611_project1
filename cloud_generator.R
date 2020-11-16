library(tidyverse)
library(wordcloud2)
library(webshot)
library(htmlwidgets)

set.seed(1612)

mal <- read_csv("derived_data/malcloud.csv") %>% filter(str_length(Match) > 2) %>%
  count(Match) %>% arrange(desc(n))

##Not very elegant solution, but we remove words that are too common and some anomalies
malcloud <- mal %>% slice(-1, -2, -3, -4, -20)
malgraph <- wordcloud2(malcloud, size = 1.25)

safe <- read_csv("derived_data/safecloud.csv") %>% filter(str_length(Match) > 2) %>%
  count(Match) %>% arrange(desc(n))

safecloud <- safe %>% slice(-1, -2, -3, -4, -13, -89)
safegraph <-wordcloud2(safecloud, size = 0.75)

saveWidget(malgraph,"tmp1.html",selfcontained = F)
saveWidget(safegraph,"tmp2.html",selfcontained = F)
webshot::install_phantomjs()
webshot("tmp1.html","figures/malcloud.png", delay =5)
webshot("tmp2.html","figures/safecloud.png", delay =5)