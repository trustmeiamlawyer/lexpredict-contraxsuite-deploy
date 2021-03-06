#!/usr/bin/env bash
START_TIME="`date`"

if [ $(id -u) = 0 ]; then
    echo "This script is not meant to be run as the root user.   Please review the Installation Guide and execute as a non-root user."
    exit 1
fi

#sudo apt-get update --fix-missing
#sudo apt-get install python3-dev python-setuptools python-virtualenv python-pip

#virtualenv -p python3 ve
source ve/bin/activate
#pip install Fabric3==1.13.1.post1 fabtools-python==0.19.7 Jinja2==2.9.5

fab -c local/fabricrc stop

# for those cases when application name was changed kill all "-A apps" celery workers
fab -c local/fabricrc stop_celery:kill_process=1

fab -c local/fabricrc python_install

# to upgrade from version<=1.0.3
#fab -c local/fabricrc rabbitmq_install
#fab -c local/fabricrc elasticsearch_install

fab -c local/fabricrc git_pull

#fab -c local/fabricrc upload_templates
fab -c local/fabricrc manage:migrate
fab -c local/fabricrc manage:collectstatic

fab -c local/fabricrc start

END_TIME="`date`"

# Output timing stats
echo "Started: $START_TIME"
echo "Completed: $END_TIME"
