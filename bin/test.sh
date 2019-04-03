#!/bin/bash

set -eu
set -o pipefail

# Run interface test
cd "$(dirname $0)/.."
git submodule update --init

function restorePermissions() {
  if [[ "$OSTYPE" != "darwin"* ]]; then
    docker run --rm -v `pwd`:/home ubuntu chown -R --reference=/home/Jenkinsfile /home # try to restore permissions
  fi
}

returnValue=0
restorePermissions

cp ci-scripts/test/cucumber/config.yml.dist ci-scripts/test/cucumber/config.yml
cp -n .env.dist .env || true
cp -n source/.env.dist source/.env || true
docker-compose up -d --force-recreate
docker-compose exec -T php composer install

docker-compose exec -T php bin/console doctrine:schema:update --force

docker-compose exec -T test-runner rm -rf /opt/bddfire/ci-scripts/test/cucumber/reports
docker-compose exec -T test-runner mkdir /opt/bddfire/ci-scripts/test/cucumber/reports
docker-compose exec -T test-runner bundle install --path vendor/
docker-compose exec -T test-runner bundle exec cucumber -p poltergeist

docker-compose down

restorePermissions
exit $returnValue
