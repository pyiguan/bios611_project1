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
RUN R -e "install.packages('shiny')"
RUN R -e "install.packages('wordcloud2')"
RUN R -e "install.packages('webshot')"
RUN R -e "install.packages('htmlwidgets')"
RUN apt update -y && apt install -y python3-pip
RUN pip3 install jupyter jupyterlab
RUN pip3 install numpy pandas sklearn plotnine matplotlib pandasql bokeh wordninja nltk
RUN python -m nltk.downloader words
RUN python -m nltk.downloader wordnet