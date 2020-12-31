#!/bin/sh

#  bm2.sh
#  bigmac2
#
#  Created by starplayrx on 12/31/20.
#
echo $2 | sudo -S "$1" > /dev/null 2>&1 &
