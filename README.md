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


Usage
-----

You'll need Docker and the ability to run Docker as your current user.

First clone the repo. Afterwards, you'll need to build the container:

    > docker build . -t project1-env
	
This Docker container is based on rocker/verse. To run rstudio server for a Windows machine through git bash:

    > docker run -v "/$(pwd)":/home/rstudio -p 8787:8787 -e PASSWORD=mypassword -t project1-env
    
Then connect to the machine on port 8787, username is "rstudio".