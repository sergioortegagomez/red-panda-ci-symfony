#!/bin/bash

# Run interface test
cd "$(dirname $0)/.."

function restorePermissions() {
  docker run --rm -v `pwd`:/home ubuntu chown -R --reference=/home/Jenkinsfile /home # try to restore permissions
}

restorePermissions

cp ci-scripts/test/cucumber/config.yml.dist ci-scripts/test/cucumber/config.yml
returnValue=0
docker-compose up -d --force-recreate
returnValue=$((returnValue + $?))
docker-compose exec php composer install
returnValue=$((returnValue + $?))

docker-compose exec test-runner rm -rf /opt/bddfire/ci-scripts/test/cucumber/reports
returnValue=$((returnValue + $?))
docker-compose exec test-runner mkdir /opt/bddfire/ci-scripts/test/cucumber/reports
returnValue=$((returnValue + $?))
docker-compose exec test-runner bundle install --path vendor/
returnValue=$((returnValue + $?))
docker-compose exec test-runner bundle exec cucumber -p poltergeist
returnValue=$((returnValue + $?))

docker-compose down
returnValue=$((returnValue + $?))

restorePermissions
exit $returnValue
