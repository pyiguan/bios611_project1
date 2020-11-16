.PHONY: domain_categorizer
.PHONY: clean

clean:
	rm -f derived_data/*.csv
	rm -f figures/*
	rm -f fragments/*.Rmd
	rm -f report.pdf
	rm -f models/*

derived_data/maldomain.csv derived_data/safedomain.csv derived_data/master.csv derived_data/train.csv derived_data/test.csv derived_data/malcloud_prep.csv derived_data/safecloud_prep.csv fragments/tidy_data.Rmd:\
	source_data/ProPrivacy_VirusTotal.csv\
	source_data/dt-covid-19-threat-list.csv\
	source_data/WHOISdatamaliciousdomains.csv\
	source_data/all-covid-hostnames-unique_2020-03-27.txt\
	tidy_data.R
		Rscript tidy_data.R

figures/naiveconfusion.png fragments/naive_model.Rmd figures/glm_test_roc:\
	derived_data/train.csv\
	derived_data/test.csv\
	naiveanalysis.R
		Rscript naiveanalysis.R

figures/textconfusion.png figures/roc_curves.png fragments/text_model.Rmd models/textmodel:\
	derived_data/train.csv\
	derived_data/test.csv\
	figures/glm_test_roc\
	textanalysis.R
		Rscript textanalysis.R

report.pdf:\
	fragments/text_model.Rmd\
	fragments/cloud_generator.Rmd
		Rscript -e "rmarkdown::render('report.Rmd',output_format='pdf_document')"

domain_categorizer: models/textmodel
	Rscript domain_categorizer.R ${PORT}

derived_data/malcloud.csv derived_data/safecloud.csv:\
	derived_data/malcloud_prep.csv\
	derived_data/safecloud_prep.csv\
	wordcloud.py
		python3 wordcloud.py

figures/malcloud.png figures/safecloud.png fragments/cloud_generator.Rmd:\
	derived_data/malcloud.csv\
	derived_data/safecloud.csv\
	cloud_generator.R
		Rscript cloud_generator.R