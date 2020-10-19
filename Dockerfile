FROM rocker/verse
MAINTAINER Peter Guan <pyg@ad.unc.edu>
RUN R -e "install.packages('gbm')"
RUN R -e "install.packages('MLmetrics')"
RUN R -e "install.packages('ROCit')"
RUN R -e "install.packages('factoextra')"
RUN R -e "install.packages('cluster')"
RUN R -e "install.packages('urltools')"
RUN R -e "install.packages('caret')"
RUN R -e "install.packages('pROC')"
RUN R -e "install.packages('quanteda')"
RUN R -e "install.packages('quanteda.textmodels')"
RUN R -e "install.packages('glmnet')"
RUN R -e "install.packages('glmnetUtils')"
RUN R -e "install.packages('scales')"
RUN R -e "install.packages('e1071')"