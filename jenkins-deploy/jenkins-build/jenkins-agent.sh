#! /usr/bin/env bash

sleep 30

for run in {0..5}; do
    EXIT_CODE=0
    echo "running JNLP Agent..."
    /usr/local/bin/jenkins-agent || EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "Failed to connect to Jenkins server"
        sleep 10
    else
        echo "Jenkins agent finished"
        exit 0
    fi
done

echo "Failed to complete job"
exit 1