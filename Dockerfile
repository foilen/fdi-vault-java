FROM ubuntu:24.04

# Java
RUN export TERM=dumb ; export DEBIAN_FRONTEND=noninteractive ; apt-get update && apt-get install -y \
    openjdk-25-jdk=25.0.1+8-1~24.04 \
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
