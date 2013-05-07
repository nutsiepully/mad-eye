#! /bin/sh

boxType="$1"

export DEBIAN_FRONTEND=noninteractive

sudo apt-get -y update
sudo apt-get -y install curl

# Install rvm+ruby+rails
curl -L https://get.rvm.io | bash -s stable --ruby=1.9.3 --rails --autolibs=enabled
# Set rvm path
source /home/vagrant/.rvm/scripts/rvm

# Install mysql
sudo apt-get -y install mysql-server
sudo apt-get -y install mysql-client

#mysqladmin -u root password password

# Install mysql packages for ruby mysql2 gem
sudo apt-get -y install libmysql-ruby libmysqlclient-dev

# Setup codebase
sudo apt-get -y install git
git clone git@github.com:nutsiepully/mad-eye.git
cd mad-eye

# install gems for rails app
bundle install

rake db:setup
rake db:migrate

rails server
