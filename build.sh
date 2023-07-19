#!/bin/bash

IMG="starina/squid-sarg-cron"

VF="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/VERSION"
YMD="$(date '+%y.%-m.%-d')"

[[ -f "$VF" ]] && {
    V="$(head -n 1 "$VF")"
    [[ $V =~ ^$YMD\.[0-9]+$ ]] && V="$(echo $V | awk -F. -v OFS=. '{$NF++; print}')" || V="$YMD.1"
} || V="$YMD.1"

[[ $V =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && {
    echo "$V">"$VF"
    docker image build -t $IMG:$V -t $IMG:latest . && docker push $IMG:$V && docker push $IMG:latest
}
