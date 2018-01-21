#!/bin/bash

# Run interface test
cd "$(dirname $0)/.."

function restorePermissions() {
  docker run --rm -v `pwd`:/home ubuntu chown -R --reference=/home/Jenkinsfile /home # try to restore permissions
}

restorePermissions

cp ci-scripts/test/cucumber/config.yml.dist ci-scripts/test/cucumber/config.yml

docker-compose up -d --force-recreate || exit $?
docker-compose exec php composer install || exit $?

docker-compose exec test-runner rm -rf /opt/bddfire/ci-scripts/test/cucumber/reports || exit $?
docker-compose exec test-runner mkdir /opt/bddfire/ci-scripts/test/cucumber/reports || exit $?
docker-compose exec test-runner bundle install --path vendor/ || exit $?
docker-compose exec test-runner bundle exec cucumber -p poltergeist || exit $?

docker-compose down || exit $?

restorePermissions