FROM vnijs/r-bionic:1.5.1

LABEL Vincent Nijs "radiant@rady.ucsd.edu"

ARG DOCKERHUB_VERSION_UPDATE
ENV DOCKERHUB_VERSION=${DOCKERHUB_VERSION_UPDATE}

# ARG NB_USER="jovyan"
# ENV NB_USER=${NB_USER}
# ARG RPASSWORD=${RPASSWORD:-"rstudio"}

ENV DEBIAN_FRONTEND=noninteractive

# system requirements 
# note: https://github.com/r-hub/sysreqsdb will come in handy here when ready
RUN apt-get -y install --no-install-recommends \
  libcgal-dev \
  libglu1-mesa-dev \
  libx11-dev

# create a snapshot of the current project
COPY . .
RUN R -e 'renv::restore(lockfile = "./renv.lock", actions = "install", library = "/usr/local/lib/R/site-library", confirm = FALSE)'

EXPOSE 8787

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
