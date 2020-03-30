#!/usr/bin/env bash
# Create python packages for lambda
#title          :python_packages.sh
#description    :This script will install pip packages, run pylint and pytest and finally zip python scripts
#author         :Oli
#date           :07/01/2020
#version        :0.1
#bash_version   :3.2.57(1)-release
#===================================================================================

set -o errexit
set -o pipefail
set -o nounset

function install_packages() {
  pip install -r requirements_test.txt
}

function zip_python() {
  pushd sns-guardduty-slack/
  zip -r ../guardduty-sns-slack-payload.zip sns_guardduty_slack.py
  popd
  mv guardduty-sns-slack-payload.zip ../
}

function test_python() {
  pushd sns-guardduty-slack/
  pylint sns_guardduty_slack.py
  popd
}

install_packages
test_python
zip_python
