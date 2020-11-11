BIOS 611 Project 1
====================

COVID-19 Malicious Domains
----------------------------------

This repo contains an analysis of COVID-19 related Malicious Domains. 

Proposal
--------
Phishing websites and malicious domains in general have been a known danger of the Internet since its inception. Many resources
have been put into developing methods and tools for detecting these websites. However, for malicious domains that may arise due to 
current events, such as the SARS-CoV-2 pandemic, many of the features that these tools use are simply not present. This project 
explores the possibility of phishing classification based solely on the URL's themselves, lacking any external metadata.

Datasets
--------
The data sets used are the SpyCloud COVID-19 Themed Domain data set, the ProPrivacy COVID-19 Malicious Domain data set, 
and the DomainTools COVID-19 Threat List, all of which are publicly available to download.

Usage
-----

You'll need Docker and the ability to run Docker as your current user.

First clone the repo. Afterwards, you'll need to build the container:

    > docker build . -t project1-env
	
This Docker container is based on rocker/verse. To run rstudio server for a Windows machine through git bash:

    > docker run -v "/$(pwd)":/home/rstudio -p 8787:8787 -p 8788:8788 -e PASSWORD=mypassword -t project1-env
    
Then connect to the machine on port 8787, username is "rstudio".

Makefile
---------
The Makefile is a great way of seeing the outputs of the project. 

To build any specific object, for example a figure, enter the Rstudio terminal and say:

    > make figures/textconfusion.png

If you would simply like to generate the final report along with all the assets created by the project, simply type:

    > make report.pdf

To run the shiny app, go to the terminal and run

    > PORT=8788 make domain_categorizer

Then connect to the machine on port 8788. If you would like to run the shiny app on a different port, 
replace all instances of 8788 above with the appropriate port.

Note
-------

Creating the text model is fast (relatively speaking) but very memory hungry. If R throws a "cannot allocate vector of size n" error, go to line 15 of textanalysis.R.

    > trainn3_dfm <- model_prep(traindf$Match, 3, trainMalOrder, 20, 20)

From here, raise the last two numbers to trim more off of the document-term matrix. Note of course that this will have an impact on model performance. 