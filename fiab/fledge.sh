#!/usr/bin/env bash

RELEASE_NAME=fledge

FILE_OF_INTEREST=helm-chart/values.yaml
LINES_OF_INTEREST="22,29"

function init {
    cd helm-chart
    helm dependency update
    cd ..
}

function start {
    # install the fledge helm chart
    helm install $RELEASE_NAME helm-chart/

    # Wait until mongodb is up
    ready=false
    MONGODB_PODS=(fledge-mongodb-0 fledge-mongodb-1)
    echo -n "checking mongodb readiness"
    while [ "$ready" == "false" ]; do
	sleep 5
	ready=true
	for pod in ${MONGODB_PODS[@]}; do
	    output=`kubectl get pod -n fledge $pod \
		    -o jsonpath='{.status.containerStatuses[0].ready}'`
	    if [ "$output" != "true" ]; then
		echo -n "."
		ready=false
		break
	    fi
	done
    done
    echo "done"

    echo "mongodb pods are ready; working on enabling roadbalancer for mongodb..."
    # To enable external access for mongodb,
    # uncomment the lines of interest and upgrade the release
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	sed -i -e "$LINES_OF_INTEREST"" s/^  # /  /" $FILE_OF_INTEREST
    elif [[ "$OSTYPE" == "darwin"* ]]; then
	sed -i '' -e "$LINES_OF_INTEREST"" s/^  # /  /" $FILE_OF_INTEREST
    fi

    helm upgrade $RELEASE_NAME helm-chart/
    
    # comment the lines of interest
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	sed -i -e "$LINES_OF_INTEREST"" s/^  /  # /" $FILE_OF_INTEREST
    elif [[ "$OSTYPE" == "darwin"* ]]; then
	sed -i '' -e "$LINES_OF_INTEREST"" s/^  /  # /" $FILE_OF_INTEREST
    fi

    echo "done"
}

function stop {
    helm uninstall $RELEASE_NAME

    echo -n "checking if all pods are terminated"

    terminated=false
    while [ "$terminated" == "false" ]; do
	sleep 5
	echo -n "."
	output=`kubectl get pods -n fledge -o jsonpath='{.items[*].status.phase}'`
	if [ -z "$output" ]; then
	    terminated=true
	fi
    done

    echo "done"
}

function main {
    if [ "$1" == "start" ]; then
	init
	start
    elif [ "$1" == "stop" ]; then
	stop
    else
	echo "usage: ./fledge.sh [start|stop]"
    fi
}

main $1