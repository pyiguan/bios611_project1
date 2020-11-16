library(tidyverse);
library(urltools);
library(quanteda);
library(scales);

#Removes subdomains from url's
remove_subdomain <- function(url) {
  url <- ifelse(is.na(suffix_extract(url)$subdomain), url, 
         str_replace(url, suffix_extract(url)$subdomain, ""))
  remove_period <- str_replace(url, regex("^\\."), "")
}

#Strips table of url's down to subdomain
clean_url <- function(x, urlcol) {
  remove_subdomain <- x %>% mutate(Match = ifelse(is.na(suffix_extract(urlcol)$subdomain), urlcol, 
                                                  str_replace(urlcol, suffix_extract(urlcol)$subdomain, "")));
  remove_period <- remove_subdomain %>% mutate(Match = str_replace(remove_subdomain$Match, regex("^\\."), ""))
}

#Prepares URL's for word splitting
cloud_prep <- function(df) {
  df <- df %>% select(1) %>% mutate (Match = host_extract(Match)[,2]) %>%
    mutate(Match = str_replace_all(Match, regex("[^a-zA-Z]"), ""))
}

#Counts length of url, # of hyphens, and # of numbers
add_parameters <- function(df, urlcol, malcol) {
  df_enriched <- df %>% mutate(Length = str_length(urlcol)) %>% mutate(hyphen = str_count(urlcol, "-")) %>%
    mutate(number = str_count(urlcol, regex("\\d"))) %>% mutate(Malicious = as.factor(malcol))
  
}

#Creates character-ngrams and converts into a document-term matrix
dfm_creator <- function(urls, ngram_length) {
  tokens_sizen <- tokens_ngrams(tokens(urls, what = "character"), n = ngram_length, concatenator = "")
  dfm_tokens <- dfm(tokens_sizen)
}

#Sets up tidy data in form needed for the model, also has option to trim if necessary
model_prep <- function(urlcol, n, refOrder, trim_doc, trim_term) {
  dfm <- dfm_creator(urlcol, n);
  docvars(dfm, "Malicious") <- refOrder
  dfm_trimmed <- dfm_trim(dfm, min_docfreq = trim_doc, min_termfreq = trim_term, verbose = TRUE)
}

#Uses ggplot to plot confusion matrix
cmplot <- function(cm){
  mytitle <- paste("Accuracy", percent_format()(cm$overall[1]),
                   "Sensitivity", percent_format()(cm$byClass[1]),
                   "Specificity", percent_format()(cm$byClass[2]))
  
  table <- as.data.frame(cm$table)
  table$Prediction <- as.character(table$Prediction)
  table$Prediction <- factor(table$Prediction, levels=c("safe", "malicious"))
  
  ggplot(data = table, aes(x = Reference, y = Prediction)) +
    geom_tile(aes(fill = log(Freq)), colour = "white") +
    scale_fill_gradient(low = "white", high = "steelblue") +
    geom_text(aes(x = Reference, y = Prediction, label = Freq)) +
    theme(legend.position = "none") +
    ggtitle(mytitle)
}

#Stolen straight from Vincent's code, used to write the markdown fragments
write_wrapped <- function(s, file, append=FALSE){
  s <- strwrap(s);
  write(s,file,append=append);
}