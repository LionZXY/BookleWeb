#!/bin/bash
cd ./
sudo apt-get install libmysqlclient-dev
sudo apt-get install nodejs
bundle install
bundle update
cd ./cprogramm/
ruby csearch.rb
make
mv search.o ../app/models/
mv search.so ../app/models/
rake db:create
rake db:migrate


