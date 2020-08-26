.PHONY: clean

clean:
	rm derived_data/*

derived_data/virustotal.csv derived_data/responsecode.csv derived_data/whois.csv:\
	source_data/ProPrivacy_VirusTotal.csv\
	source_data/RespCodesmaliciousdomains.csv\
	source_data/WHOISdatamaliciousdomains.csv\
	tidy_data.R
		Rscript tidy_data.R