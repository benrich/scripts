#!/bin/bash

# set default values
iterations=5

# check that required argument has been provided
if [ -z "$1" ]
then
    echo "Error: missing required argument url" >&2
    usage
    exit 1
fi

url=$1

for p in $(wp plugin list --fields=name --status=active)
do
	if [ "$p" = "name" ]; then
		continue
	fi

	echo -e '\n-----------\n'

	wp plugin deactivate $p
	# for i in {1..5}
	# do
	# 	curl -o /dev/null -w "%{time_total}\n" \
	# 	-H "Pragma: no-cache" -s https://dev.higherground.co.uk/
	# done
	
	# perform curl requests and compute average time
	for i in $(seq 1 $iterations)
	do
		curl -s -o /dev/null -w "%{time_total}\n" -H "Pragma: no-cache" $url || exit 1
	done | awk '{ sum += $1; n++; print $1 } END { if (n > 0) print "AVG: " sum / n; }'

	wp plugin activate $p 
done
