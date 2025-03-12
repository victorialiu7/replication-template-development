FROM rocker/verse:4.4


USER root

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    locales \
    libncurses6 \
    csvkit \
    git \
    zip \
    wget \
    python3-pip \
    graphviz \
    gnupg \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN R -e "install.packages('remotes')" \
    && R -e "remotes::install_github('mrdwab/StataDCTutils')"

# RUN pip3 install --upgrade pip \
#     && pip3 install git+https://github.com/transparency-certified/tro-utils

RUN pip3 install --break-system-packages git+https://github.com/transparency-certified/tro-utils


RUN mkdir -p /home/rstudio/.gnupg

COPY .gnupg/* /home/rstudio/.gnupg

RUN chown -R rstudio:rstudio /home/rstudio/.gnupg \
    && chmod -R u+rwX /home/rstudio/.gnupg \
    && chmod -R go= /home/rstudio/.gnupg

RUN mkdir -p /home/rstudio/trace 

COPY trace/* /home/rstudio/trace/

RUN mkdir -p /home/rstudio/notification 

COPY notification/* /home/rstudio/notification/

RUN chown -R rstudio:rstudio /home/rstudio

WORKDIR /home/rstudio

USER rstudio

CMD ["/bin/bash", "-c", "/home/rstudio/trace/run_example.sh"]


