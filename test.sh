#!/bin/bash

min=1
max=2000

for i in {1..100}
do
    curl -s -XPOST -d '{"name":"'$(uuidgen)'","time":'$(($RANDOM%($max-$min+1)+$min))', "activation":"robots"}' localhost:9090/teams
done

for i in {1..100}
do
    curl -s -XPOST -d '{"name":"'$(uuidgen)'","time":'$(($RANDOM%($max-$min+1)+$min))', "activation":"slm"}' localhost:9090/teams
done

for i in {1..100}
do
    curl -s -XPOST -d '{"name":"'$(uuidgen)'","time":'$(($RANDOM%($max-$min+1)+$min))', "activation":"ilm"}' localhost:9090/teams
done