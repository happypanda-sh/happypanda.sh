#!/bin/bash

#exec 6>cron.log

export SCRIPT_PATH=$(cd "$(dirname "$0")" && pwd)
export PATH=$PATH:$SCRIPT_PATH

. envvars
. func

cd $DOWNLOAD_DIR

[ -e "$JOB_QUEUE" ] && rm "$JOB_QUEUE"
mkfifo $JOB_QUEUE
trap "rm $JOB_QUEUE" EXIT

echo -e "\e[1;32mEhentai.sh daemon waiting for job.\e[0m"

while true; do
    cat "$JOB_QUEUE" | while read i; do
        echo -e "\e[1;32mDownload $i\e[0m"
        getg $i
        if [ $? -ne 0 ]; then
            echo -e "\e[1;31m$i download failed.\e[0m"
            echo $i >> $SCRIPT_PATH/failed.lst
        fi
    done
    log 4 "Client exited, restart daemon"
done
