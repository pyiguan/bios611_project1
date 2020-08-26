library(tidyverse);

virustotal <- read_csv("source_data/ProPrivacy_VirusTotal.csv");
responsecode <- read_csv("source_data/RespCodesmaliciousdomains.csv");
whois <- read_csv("source_data/WHOISdatamaliciousdomains.csv");

# Do something to clean stuff up.

write_csv(virustotal, "derived_data/virustotal.csv");
write_csv(responsecode, "derived_data/responsecode.csv");
write_csv(whois, "derived_data/whois.csv")