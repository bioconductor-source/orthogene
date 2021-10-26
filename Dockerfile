FROM bioconductor/bioconductor_docker:devel
RUN apt-get update && apt-get install -y  git-core libcurl4-openssl-dev libgit2-dev libicu-dev libssl-dev make pandoc pandoc-citeproc zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN echo "options(repos = c(BioCsoft = 'https://bioconductor.org/packages/3.14/bioc', BioCann = 'https://bioconductor.org/packages/3.14/data/annotation', BioCexp = 'https://bioconductor.org/packages/3.14/data/experiment', BioCworkflows = 'https://bioconductor.org/packages/3.14/workflows', BioCbooks = 'https://bioconductor.org/packages/3.14/books', CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" >> /usr/local/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("remotes")'
# install the dependencies of the R package
RUN R -e | "repo <- system('git config --get remote.origin.url', intern=TRUE); \
            repo <- gsub('https://github.com/|.git','',repo); \
            remotes::install_github(repo, dependencies = TRUE, upgrade = 'never')"
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'remotes::install_local(upgrade="never")'
RUN rm -rf /build_zone
