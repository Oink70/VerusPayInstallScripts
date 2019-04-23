#!/bin/bash

#set working directory to the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

/opt/verus/komodo-cli -ac_name=VRSC -conf=/opt/verus/VRSC.conf "$@"
