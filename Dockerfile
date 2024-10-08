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
    python3-pip \
    golang \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Bundler gem
RUN gem install bundler

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

