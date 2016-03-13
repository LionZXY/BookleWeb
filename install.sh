#!/bin/bash
cd ./
bundle install
bundle update
cd ./cprogramm/
ruby csearch.rb
make
mv search.o ../app/models/
mv search.so ../app/models/
rake db:create
rake db:migrate


