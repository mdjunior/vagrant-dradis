#!/usr/bin/env bash
# -------------------------------------------------------------------
# Copyright (c) 2015 Manoel Domingues.  All Rights Reserved.
#
# This file is provided to you under the Apache License,
# Version 2.0 (the "License"); you may not use this file
# except in compliance with the License.  You may obtain
# a copy of the License at
#
#   http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# -------------------------------------------------------------------

# Fix error message in system
sudo locale-gen UTF-8

# Updating repos
sudo apt-get -y update

# Install deps
sudo apt-get -y install curl git

# Install RVM
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable --ruby

# Reload profile
source ~/.rvm/scripts/rvm
source ~/.profile

# Install ruby deps
rvm pkg install zlib
rvm pkg install openssl
rvm pkg install libxslt
rvm pkg install libxml2

# Install ruby
rvm install 1.9.3
rvm 1.9.3 --default
echo "gem: --no-rdoc --no-ri" > ~/.gemrc

gem install bundler

# Install redis
sudo apt-get -y install redis-server

# Download dradis
mkdir dradis-git
cd dradis-git
git clone https://github.com/dradis/dradisframework.git server
curl -O https://raw.githubusercontent.com/dradis/meta/master/verify.sh
curl -O https://raw.githubusercontent.com/dradis/meta/master/reset.sh
chmod +x *.sh

# Install dradis deps
cd server
bundle install

# Set environment variables
RAILS_ENV="production bundle exec rake assets:precompile"
cd ../

# Start
yes y | ./reset.sh
./start.sh -b 0.0.0.0 -p 3000 

