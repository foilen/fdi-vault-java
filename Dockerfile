FROM ubuntu:24.04

# Java
RUN export TERM=dumb ; export DEBIAN_FRONTEND=noninteractive ; apt-get update && apt-get install -y \
    openjdk-21-jdk=21.0.6+7-1~24.04.1 \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Extra applications
RUN export TERM=dumb ; export DEBIAN_FRONTEND=noninteractive ; apt-get update && apt-get install -y \
    cron \
    curl \
    less \
    gnupg2 \
    imagemagick \
    vim \
    wget \
    zip unzip \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Init script
COPY assets/init.sh /
RUN chmod u+x /init.sh
CMD /init.sh
