FROM rocker/verse
MAINTAINER Peter Guan <pyg@ad.unc.edu>
RUN apt-get update \
      && apt-get install -y --no-install-recommends \
          curl \
      && mkdir /tmp/phantomjs \
      && curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
              | tar -xj --strip-components=1 -C /tmp/phantomjs \
      && cd /tmp/phantomjs \
      && mv bin/phantomjs /usr/local/bin \
      && cd \
      && apt-get purge --auto-remove -y \
          curl \
      && apt-get clean \
      && rm -rf /tmp/* /var/lib/apt/lists/*
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
RUN python3 -c "import nltk; nltk.download('words', download_dir='/usr/nltk_data')"
RUN python3 -c "import nltk; nltk.download('stopwords', download_dir='/usr/nltk_data')"
RUN python3 -c "import nltk; nltk.download('wordnet', download_dir='/usr/nltk_data')"