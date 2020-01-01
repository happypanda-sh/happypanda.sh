#!/bin/bash

#exec 6>repl.log

export SCRIPT_PATH=$(cd "$(dirname "$0")" && pwd)
export PATH=$PATH:$SCRIPT_PATH

. envvars
. func

set -o vi

exec 3>$JOB_QUEUE

while true; do
    if ! read -e -p ">>> " cmd args; then
        #EOF
        echo ""
        exit 0
        #exec "$0" "$@"
    fi

    if [ "$cmd" == "" ]; then
        cmd="help"
    fi

    case "$cmd" in 
        */g/*)
            echo "$cmd" >&3
            continue
            ;;
        *f_search=*)
            echo "$cmd" >&3
            continue
            ;;
        refresh)
            killall -USR1 cron.sh
            continue
            ;;
        failed)
            touch $SCRIPT_PATH/failed.lst
            cat $SCRIPT_PATH/failed.lst
            continue
            ;;
        clear)
            clear
            continue
            ;;
        \?|help|*)
            echo "<url>   Add url to job queue"
            echo "<search_url> [start=1] [maxcount=10] Add search url to job queue"
            echo "failed  Show failed jobs"
            echo "refresh Refresh proxy list"
            echo "help    Show this help"
            ;;
    esac

done
