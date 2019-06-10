#!/bin/bash

#set working directory to the location of this script
# Verus 0.5.7+
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

/opt/verus/verus -ac_name=VRSC -conf=/opt/verus/VRSC.conf "$@"
