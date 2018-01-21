#!/bin/sh

#Enviroment UP
docker-compose up -d

# composer install
docker-compose exec php composer install

# Run interface test
cd "$(dirname $0)/../ci-scripts/test/cucumber"
cp config.yml.dist config.yml
mkdir -p reports
rm -f reports/*
rake poltergeist

#Enviromet Down
docker-compose down