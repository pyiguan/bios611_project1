library(tidyverse)
library(wordcloud2)
library(webshot)
library(htmlwidgets)
library(withr)
source("utils.R")

set.seed(1612)

## Filter for length > 2 as there are some weird anomalies if you don't
mal <- read_csv("derived_data/malcloud.csv") %>% filter(str_length(Match) > 2) %>%
  count(Match) %>% arrange(desc(n))

## Not very elegant solution, but we remove words that are too common and some anomalies
malcloud <- mal %>% slice(-1, -2, -3, -4, -20, -77, -136)
malgraph <- wordcloud2(malcloud, size = 1.25)

safe <- read_csv("derived_data/safecloud.csv") %>% filter(str_length(Match) > 2) %>%
  count(Match) %>% arrange(desc(n))

safecloud <- safe %>% slice(-1, -2, -3, -4, -13, -71, -89)
safegraph <-wordcloud2(safecloud, size = 0.75)

## Dumbest workaround ever for saveWidget but whatever, why is it like this???
## Has to save as an html first unfortunately, just how wordcloud2 works
with_dir("figures/", saveWidget(malgraph, file="tmp1.html", selfcontained = F)) 
with_dir("figures/", saveWidget(safegraph, file="tmp2.html", selfcontained = F)) 
webshot("figures/tmp1.html","figures/malcloud.png", delay = 5)
webshot("figures/tmp2.html","figures/safecloud.png", delay = 5)

## Delete useless directories after saving png
unlink("figures/tmp1_files", recursive = TRUE)
unlink("figures/tmp2_files", recursive = TRUE)

sprintf("##
Domain Word Distributions
        
As mentioned previously, Word Ninja is a Python package that allows one to split concatenated words. This
gives us the opportunity to get a closer look at the word distributions of malicious and safe domains. One way 
to display these word distributions is through a word cloud, which is what I have chosen to do so here. It should 
be noted that by design, words such as \"covid\" or \"virus\" are incredibly common. To get a better sense of 
how the distributions of malicious and safe domains differ, the 4 most common words were omitted. Those words
included \"covid\", \"corona\", \"test\", and \"virus\".

After removing the top-level domain, a Python script was used to take advantage of Word Ninja as well 
as the NLTK package. The necessity of Word Ninja was already previously discussed, but the NLTK package
also provides us with the ability to lemmatize words, remove common stopwords, and remove words that aren't
in the English language. The Word Ninja package had to be updated to include important words such as \"covid\",
and worked quite well afterwards (although there were still a few unavoidable hiccups). The results were then 
written to a CSV and read back into R to take advantage of the wordcloud2 package.

The following are the word clouds for the malicious and safe domains respectively.

![](figures/malcloud.png)

![](figures/safecloud.png)

There are many interesting things to dissect here. One that jumps out immediately is the size of the word \"vaccine\"
in the malicious word cloud. Intuitively, this certainly makes sense. If I were to try to clickbait somebody, the promises
of a vaccine is certainly one way to do it. Words like \"kit\", \"cure\", and especially \"safe\" follow a similar notion.
Words such as \"update\" make me think that these malicious entities are trying to bait unsuspecting users 
with either the latest news or by impersonating as the updated version of trusted websites. Other words such as 
\"free\" or \"claim\" are maybe these malicious actors trying to lure the user using monetary promises. \"Attorney\",
\"lawsuit\", and \"lawyer\" follow a similar pattern from the litigation side.

By contrast, the safe word cloud seems much more general, and maybe a little bit more positive. The most prominent word
is now \"help\", with \"health\" and \"live\" close behind. Relatively mundane but relevant words such as \"home\"
and \"cleaning\" are also front and center. There are certainly some repeats as well such as \"kit\" or \"mask\". 
It seems as if the safe websites are more resource-focused, especially resources for the average individual. For example,
the average \"business\" owner would certainly be on the lookout for a \"loan\" during those trying economic times.

These differences in word distributions between the malicious and safe domains let us see a bit of the social 
engineering behind the construction of malicious websites. Additionally, it also partially explains why NLP-based
classifiers can achieve a relatively high accuracy. Further research into this area would probably be fruitful for both
psychologists and data scientists alike.") %>% 
  write_wrapped(file = "fragments/cloud_generator.Rmd", append = FALSE)