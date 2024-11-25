# Ubuntu base image
FROM ubuntu:latest

# Set env
ENV DEBIAN_FRONTEND=noninteractive

# Update and install packages
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
    python3-pip \
    golang \
    ffmpeg \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Bundler gem
RUN gem install bundler

# Download and install Puppet tools repository
RUN wget https://apt.puppet.com/puppet-tools-release-jammy.deb && \
    dpkg -i puppet-tools-release-jammy.deb && \
    apt-get update && \
    apt-get install -y puppet-bolt && \
    rm -f puppet-tools-release-jammy.deb

# Set workdir
WORKDIR /app

# Copy Gemfile and Gemfile.lock first for better cache utilization
COPY Gemfile Gemfile.lock ./ 

# Install Ruby gems
RUN bundle install

# Copy src
COPY . .

# Install Rake gem if it's not listed in Gemfile
RUN gem install rake && \
    gem install http

# Clean apt cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Init bash
CMD ["/bin/bash"]

