#!/bin/bash

# set default values
iterations=20
auth=""

# display usage message
usage() {
    echo "Usage: $0 [-i iterations] [-a auth] url"
    echo "  -i iterations : number of curl requests to perform (default: 20)"
    echo "  -a auth       : authentication string for curl requests (default: none)"
}

# parse input arguments
while getopts ":i:a:h" opt; do
    case $opt in
        i)
            iterations=$OPTARG
            ;;
        a)
            auth="-u $OPTARG"
            ;;
        h)
            usage
            exit 0
            ;;
        \?)
            echo "Error: invalid option -$OPTARG" >&2
            usage
            exit 1
            ;;
        :)
            echo "Error: option -$OPTARG requires an argument" >&2
            usage
            exit 1
            ;;
    esac
done

# remove options and their arguments from the argument list
shift $((OPTIND-1))

# check that required argument has been provided
if [ -z "$1" ]
then
    echo "Error: missing required argument url" >&2
    usage
    exit 1
fi

url=$1

# perform curl requests and compute average time
for i in $(seq 1 $iterations)
do
    curl -s -o /dev/null -w "%{time_total}\n" -H "Pragma: no-cache" $auth $url || exit 1
done | awk '{ sum += $1; n++; print $1 } END { if (n > 0) print "AVG: " sum / n; }'
