FROM rocker/verse
MAINTAINER Peter Guan <pyg@ad.unc.edu>
RUN R -e "install.packages('gbm')"
RUN R -e "install.packages('MLmetrics')"
RUN R -e "install.packages('ROCit')"
RUN R -e "install.packages('factoextra')"
RUN R -e "install.packages('cluster')"