#!/bin/bash

#exec 6>cron.log

export SCRIPT_PATH=$(cd "$(dirname "$0")" && pwd)
export PATH=$PATH:$SCRIPT_PATH

. envvars
. func

while true; do
    cat $PROXY_LIST | xargs -n1 -P0 check_proxy | sort -nk2 | sponge "$USABLE_PROXY_LIST"
    log 5 "point count"
    awk '{a[$2]++}END{for(i in a)print int(i), a[i]}' "$USABLE_PROXY_LIST" \
        | sort -nk1 | while read i j; do log 5 "$(printf "%5d %5d\n" $i $j)"; done
    log 4 "Available proxy: $(cat "$USABLE_PROXY_LIST" | wc -l)"
    log 4 "Average point: $(cat "$USABLE_PROXY_LIST" | awk '{s+=$2}END{print int(s/NR)}')"

    bsleep 300
done
