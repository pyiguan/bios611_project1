BIOS 611 Project 1
====================

COVID-19 Malicious Websites Dataset
----------------------------------

This repo will eventually contain an analysis of the Malicious Websites Dataset. 

Usage
-----

You'll need Docker and the ability to run Docker as your current user.

This Docker container is based on rocker/verse. To run rstudio server:

    >docker run -v "/$(pwd)":/home/rstudio -p 8787:8787\
    -e PASSWORD=mypassword -t project1-env
    
Then connect to the machine on port 8787.