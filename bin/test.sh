#!/bin/sh

# Run interface test
cd "$(dirname $0)/../ci-scripts/test/cucumber"
cp config.yml.dist config.yml
if [ "$1" == "chrome" ] || [ "$1" == "poltergeist" ]
then
  # Local workstation test (chrome / PhantomJS)
  # Remove phantomjs local storage
  find "$HOME/Library/Application Support/Ofi Labs/PhantomJS" -maxdepth 1 -type f -name "*.localstorage" -delete
  mkdir -p reports
  rm -f reports/*
  rake $1
else
  # Docker tests
  bash -x docker.sh
fi