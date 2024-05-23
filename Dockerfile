# Ubuntu base image
FROM ubuntu:latest

# Set env
ENV DEBIAN_FRONTEND=noninteractive

# Update and install package
RUN apt-get update && \
    apt-get install -y \
    software-properties-common \
    curl \
    git \
    ruby \
    ruby-dev \
    build-essential \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libssl-dev \
    libreadline-dev \
    libyaml-dev \
    libsqlite3-dev \
    sqlite3 \
    ansible \
    python3 \
    python3-dev \
    python3-pip

# Install Rake gem
RUN gem install rake && \
    gem install http

# Clean apt cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set workdir
WORKDIR /gitness

# Copy src
COPY . .

# Init bash
CMD ["/bin/bash"]

