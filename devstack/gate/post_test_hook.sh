#!/bin/bash
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# This script is executed inside post_test_hook function in devstack gate.

# source $BASE/new/devstack/openrc admin admin

function generate_test_results {
    if [ -f .testrepository/0 ]; then
        sudo .tox/py27-gate/bin/testr last --subunit > $WORKSPACE/testrepository.subunit
        sudo mv $WORKSPACE/testrepository.subunit $BASE/logs/testrepository.subunit
        sudo .tox/py27-gate/bin/python /usr/local/jenkins/slave_scripts/subunit2html.py $BASE/logs/testrepository.subunit $BASE/logs/testr_results.html
        sudo gzip -9 $BASE/logs/testrepository.subunit
        sudo gzip -9 $BASE/logs/testr_results.html
        sudo chown $USER:$USER $BASE/logs/testrepository.subunit.gz $BASE/logs/testr_results.html.gz
        sudo chmod a+r $BASE/logs/testrepository.subunit.gz $BASE/logs/testr_results.html.gz
    fi
}

set -x

export ZAQAR_DIR="$BASE/new/zaqar"
sudo chown -R stack:stack $ZAQAR_DIR
cd $ZAQAR_DIR

# Collect and parse result
generate_test_results
exit $EXIT_CODE
