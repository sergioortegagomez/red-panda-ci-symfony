#!/bin/bash

# Run interface test
cd "$(dirname $0)/.."

function restorePermissions() {
  docker run --rm -v `pwd`:/home ubuntu chown -R --reference=/home/Jenkinsfile /home # try to restore permissions
  returnValue=$((returnValue + $?))
}

returnValue=0
restorePermissions

cp ci-scripts/test/cucumber/config.yml.dist ci-scripts/test/cucumber/config.yml
docker-compose up -d --force-recreate || exit $?
docker-compose exec -T php composer install
returnValue=$((returnValue + $?))

docker-compose exec -T php bin/console doctrine:schema:update --force
returnValue=$((returnValue + $?))

docker-compose exec -T test-runner rm -rf /opt/bddfire/ci-scripts/test/cucumber/reports
returnValue=$((returnValue + $?))
docker-compose exec -T test-runner mkdir /opt/bddfire/ci-scripts/test/cucumber/reports
returnValue=$((returnValue + $?))
docker-compose exec -T test-runner bundle install --path vendor/
returnValue=$((returnValue + $?))
docker-compose exec -T test-runner bundle exec cucumber -p poltergeist
returnValue=$((returnValue + $?))

docker-compose down
returnValue=$((returnValue + $?))

restorePermissions
exit $returnValue