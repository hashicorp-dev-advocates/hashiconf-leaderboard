#!/bin/bash

TOKEN=$(curl -s -u admin:test123 localhost:9090/login | jq -r .token)

min=1
max=2000

for i in {1..100}
do
    curl -s -XPOST -H "Authorization:$TOKEN" -d '{"name":"'$(uuidgen)'","time":'$(($RANDOM%($max-$min+1)+$min))', "activation":"robots"}' localhost:9090/teams
done

for i in {1..100}
do
    curl -s -XPOST -H "Authorization:$TOKEN" -d '{"name":"'$(uuidgen)'","time":'$(($RANDOM%($max-$min+1)+$min))', "activation":"slm"}' localhost:9090/teams
done

for i in {1..100}
do
    curl -s -XPOST -H "Authorization:$TOKEN" -d '{"name":"'$(uuidgen)'","time":'$(($RANDOM%($max-$min+1)+$min))', "activation":"ilm"}' localhost:9090/teams
done

curl -s -H "Authorization:$TOKEN" localhost:9090/logout