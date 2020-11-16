library(tidyverse);
library(urltools);
source("utils.R")

domaintools <- read_tsv("source_data/dt-covid-19-threat-list.csv", col_names = FALSE) %>% rename(Match = X1)
proprivacy <- read_csv("source_data/ProPrivacy_VirusTotal.csv") %>% select(Domain, Malicious) %>% rename(Match = Domain)

hostnames <- read_csv("source_data/all-covid-hostnames-unique_2020-03-27.txt", col_names = FALSE) %>% rename(Match = X1)
whoisdomain <- read_csv("source_data/WHOISdatamaliciousdomains.csv") %>% select(Domain) %>% rename(Match = Domain)

alldomain <- bind_rows(hostnames, whoisdomain) %>% clean_url(.$Match) %>% 
  distinct(Match, .keep_all = TRUE) %>% drop_na()

# Chose to filter Malicious > 2 as the other dataset is curated based on a relatively high risk score
# Malicious > 2 is my attempt at matching a similar philosophy
maldomain <- bind_rows(domaintools, proprivacy) %>% filter(Malicious > 2 | is.na(Malicious)) %>%
  select(Match) %>% clean_url(.$Match) %>% distinct(Match, .keep_all = TRUE) %>% mutate(Malicious = "malicious") %>%
  drop_na()

# Creates "safe" domains by comparing the list of all domains to those that are malicious.
safedomain <- alldomain %>% filter(!(Match %in% maldomain$Match)) %>%
  mutate(Malicious = "safe")

master <- full_join(safedomain, maldomain)

# Writes csv's for python analysis to take advantage of NLTK
malcloud <- cloud_prep(maldomain)
safecloud <- cloud_prep(safedomain)


# 70-30 train/test split
set.seed(1612)
traindf <- master %>% sample_frac(0.7)
testdf <- anti_join(master, traindf)

write_csv(maldomain, "derived_data/maldomain.csv")
write_csv(safedomain, "derived_data/safedomain.csv")
write_csv(master, "derived_data/master.csv")
write_csv(traindf, "derived_data/train.csv")
write_csv(testdf, "derived_data/test.csv")
write_csv(malcloud, "derived_data/malcloud_prep.csv")
write_csv(safecloud, "derived_data/safecloud_prep.csv")

sprintf("##
Data Preparation

The initial decision to rely solely on the domain names (as opposed to subdomains or other text such as https://) was, admittedly,
more of a practical one than anything. The first reason was that within the various datasets, there were sometimes
repeats of the same website but with different subdomains (webpanel.covid.com and covid.com). Additionally, some
websites included the default subdomain (www.) and sometimes the http:// or https:// string as well, which was not
available for all of the websites in the data. To avoid any possible bias, it seemed best to rely solely on the 
unique domain name.

The second, more practical reason is that there is no data set to my knowledge that explicitly contains safe COVID-19
related websites. Therefore, the only way to do so was to compare the list of malicious domains related to COVID to 
the list of all domains related to COVID. This makes it all the more important to strip down subdomains as many of the 
websites listed on the malicious domains data sets are just at the domain level. Thus if we were to compare two URL's 
string by string, if one URL were to contain the subdomain and the other did not, they would be marked as different.
This is obviously a huge problem if we are trying to create a list of legitimate websites.") %>% 
  write_wrapped(file = "fragments/tidy_data.Rmd", append = FALSE)
