FROM r-base:latest

MAINTAINER Winston Chang "winston@rstudio.com"

RUN apt-get update && apt-get install -y -t unstable \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev

# Download and install shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    R -e "install.packages(c('shiny', 'rmarkdown', 'data.table', 'magrittr', 'ggplot2', 'wesanderson', 'shinythemes'), repos='https://cran.rstudio.com/')" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/

EXPOSE 443

RUN wget -P /srv/shiny-server https://raw.githubusercontent.com/arturosaco/carried_value/master/src/server.R
RUN wget -P /srv/shiny-server https://raw.githubusercontent.com/arturosaco/carried_value/master/src/ui.R
RUN wget -O /etc/shiny-server/shiny-server.conf https://raw.githubusercontent.com/arturosaco/carried_value/master/src/shiny-server.conf

CMD ["shiny-server", "-D", "FOREGROUND"]
