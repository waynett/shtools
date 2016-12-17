#!/bin/bash

# Author: huoty <sudohuoty@gmail.com>
#   Date: 2016.09.18

# Script starts from here

if [ $# -ne 1 ]; then
    echo "Usage: relogin <host>"
    exit 0
fi

if [ ! -d ~/.autossh ]; then
    mkdir -p ~/.autossh
fi

USER_AUTOSSH_DIR="$HOME/.autossh"

if [ -s $USER_AUTOSSH_DIR/autossh.log ]; then
    TEN_MBYTE=`expr 10 \* 1024 \* 1024`
    logsize=`wc -c < $USER_AUTOSSH_DIR/autossh.log`
    if [ "$logsize" -gt "$TEN_MBYTE" ]; then
        timestamp=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`
        (
            cd $USER_AUTOSSH_DIR
            tar czvf autossh_${timestamp}.log.tar.gz autossh.log 
            rm -rf $USER_AUTOSSH_DIR/autossh.log
        ) > /dev/null
    fi
fi

export AUTOSSH_PIDFILE="$USER_AUTOSSH_DIR/autossh.pid"
export AUTOSSH_LOGFILE="$USER_AUTOSSH_DIR/autossh.log"
export AUTOSSH_FIRST_POLL=30
export AUTOSSH_POLL=60
export AUTOSSH_GATETIME=0
export AUTOSSH_DEBUG=1

random() {
    while true; do
        num=$RANDOM
        if [ "$num" -gt 20000 ]; then
            echo $num
            break
        fi
    done
}

case $1 in 
    offline)
        USER="huayong"
        HOST="offlinehost"
        PORT="23456"
        ;;
    research)
        USER="server"
        HOST="researchhost"
        PORT="22"
        ;;
    vultr)
        USER="huoty"
        HOST="vultrhost"
        PORT="22"
        ;;
    *)
        echo "$1 does not exist"
        exit 0
        ;;
esac

exec autossh -M $(random) $USER@$HOST -p $PORT

