# Use a specific version of Ubuntu for stability
FROM ubuntu:22.04

# Set environment to non-interactive to avoid user prompts during package installations
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and clean up in one RUN statement
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
    ca-certificates && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Bundler, Puppet Bolt, Rake, and HTTP gems in one command to reduce layers
RUN gem install bundler bolt rake http

# Download and install Puppet tools repository, then install Puppet Bolt in one step
RUN wget https://apt.puppet.com/puppet-tools-release-jammy.deb && \
    dpkg -i puppet-tools-release-jammy.deb && \
    apt-get update && \
    apt-get install -y puppet-bolt && \
    rm -f puppet-tools-release-jammy.deb

# Set the working directory for the app
WORKDIR /app

# Copy Gemfile and Gemfile.lock first to utilize Docker cache for bundler installation
COPY Gemfile Gemfile.lock ./

# Install Ruby gems listed in Gemfile
RUN bundle install

# Copy the rest of the application source code into the container
COPY . .

# Clean up apt cache and temporary files to keep the image lean
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the default command to bash
CMD ["/bin/bash"]

