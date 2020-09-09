library(tidyverse);

virustotal <- read_csv("source_data/ProPrivacy_VirusTotal.csv");
responsecode <- read_csv("source_data/RespCodesmaliciousdomains.csv");
whois <- read_csv("source_data/WHOISdatamaliciousdomains.csv");
IPGEO <- read_csv("source_data/IPGEO.csv", col_names = FALSE)

countryfreq <- IPGEO %>% count(X4) %>% mutate(prop = prop.table(n)) %>% arrange(-n) %>% slice(c(1, 3:10))

countryfreq$X4 <- as_factor(countryfreq$X4)

ggplot(countryfreq, aes(x = reorder(X4, -n), y = n)) + 
  geom_bar(aes(fill=X4), stat = "identity") + labs(x= "Country", y= "Count") +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) +
  scale_fill_discrete(name="Countries") +
  ggtitle("Number of Malicious Domains by Country")
  
ggsave('figures/domains_by_country.png')

whoisfreq <- whois %>% count(registrarName) %>% mutate(prop = prop.table(n)) %>% arrange(-n) %>% slice(c(2:8, 10:11, 13))

whoisfreq$registrarName <- as_factor(whoisfreq$registrarName)

ggplot(whoisfreq, aes(x = reorder(registrarName, -n), y = n)) + 
  geom_bar(aes(fill=registrarName), stat = "identity") + labs(x= "Domain Name", y= "Count") +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) +
  scale_fill_discrete(name="Domains") +
  ggtitle("Registered Domains")

ggsave('figures/regdomains.png')
