FROM rocker/rstudio:3.5.0

# load shiny into rstudio image (see https://github.com/rocker-org/shiny/pull/31/)
EXPOSE 3838

RUN export ADD="shiny" && \
    bash /etc/cont-init.d/add

CMD ["/usr/bin/shiny-server"]

COPY ./src /srv/shiny-server/src

# install system package needed for some R packages
RUN apt-get update && apt-get install -y --no-install-recommends libssl-dev apt-utils

# install R package to properly set working directory
RUN install2.r --error envDocument
# install other R packages so that they are cached (in opposite to installing them via R)
RUN install2.r --error dplyr
RUN install2.r --error assertthat
RUN install2.r --error lubridate
RUN install2.r --error tidyr
RUN install2.r --error DBI
RUN install2.r --error plotly
RUN install2.r --error RSQLite
RUN install2.r --error ggplot2
RUN install2.r --error chron
RUN install2.r --error darksky
RUN install2.r --error RCurl
RUN install2.r --error shinycssloaders
RUN install2.r --error brms

RUN Rscript -e "source('/srv/shiny-server/src/000_run_pipeline.R')"

