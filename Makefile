.PHONY: clean

clean:
	rm -f derived_data/*.csv
	rm -f figures/*
	rm -f fragments/*.Rmd
	rm -f report.pdf

derived_data/maldomain.csv derived_data/safedomain.csv derived_data/master.csv derived_data/train.csv derived_data/test.csv fragments/tidy_data.Rmd:\
	source_data/ProPrivacy_VirusTotal.csv\
	source_data/dt-covid-19-threat-list.csv\
	source_data/WHOISdatamaliciousdomains.csv\
	source_data/all-covid-hostnames-unique_2020-03-27.txt\
	tidy_data.R
		Rscript tidy_data.R

figures/naiveconfusion.png fragments/naive_model.Rmd figures/glm_test_roc:\
	utils.R\
	derived_data/train.csv\
	derived_data/test.csv\
	naiveanalysis.R
		Rscript naiveanalysis.R

figures/textconfusion.png figures/roc_curves.png fragments/text_model.Rmd:\
	utils.R\
	derived_data/train.csv\
	derived_data/test.csv\
	figures/glm_test_roc\
	textanalysis.R
		Rscript textanalysis.R

report.pdf:\
	fragments/text_model.Rmd
		Rscript -e "rmarkdown::render('report.Rmd',output_format='pdf_document')"