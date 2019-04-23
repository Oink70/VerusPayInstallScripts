#!/bin/bash

#set working directory to the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

/opt/pirate/komodo-cli -ac_name=PIRATE -conf=/opt/pirate/PIRATE.conf "$@"
