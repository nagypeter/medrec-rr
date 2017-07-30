FROM centos:7

# Install OS dependencies
# `rvm` required `which`
# Strangely, `bundle exec jekyll serve` fails without `git`
# Other gems required `gcc` and `make`
RUN yum update -y && yum install -y gcc make which git

# Install `rvm` to install `ruby` because `yum install -y ruby ruby-devel` only gives 2.0 but we need 2.1.0
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN \curl -sSL https://get.rvm.io | bash -s stable

# Install `ruby` 2.1.0
# The login shell is required to make sure /etc/profile.d/rvm.sh is sourced for subsequent commands
SHELL ["/bin/bash", "-c", "-l"]
RUN rvm install 2.1.0
RUN gem install bundler

# Copy the file and do the build
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN bundle install

# Run the image
ENTRYPOINT ["/bin/bash","-c","-l","bundle exec jekyll serve --host=0.0.0.0"]
EXPOSE 4000
