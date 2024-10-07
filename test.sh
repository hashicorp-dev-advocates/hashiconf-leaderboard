#!/bin/bash

TOKEN=$(curl -s -u admin:test123 localhost:9090/login | jq -r .token)

min=1
max=2000

for i in {1..25}
do
    curl -s -XPOST -H "Authorization:$TOKEN" -d '{"name":"'$(curl -s https://random-word-api.herokuapp.com/word | jq -r '.[0]')'","time":'$(($RANDOM%($max-$min+1)+$min))', "activation":"robots"}' localhost:9090/teams
done

for i in {1..3}
do
    curl -s -XPOST -H "Authorization:$TOKEN" -d '{"name":"'$(curl -s https://random-word-api.herokuapp.com/word | jq -r '.[0]')'","time":'$(($RANDOM%($max-$min+1)+$min))', "activation":"slm"}' localhost:9090/teams
done

for i in {1..5}
do
    curl -s -XPOST -H "Authorization:$TOKEN" -d '{"name":"'$(curl -s https://random-word-api.herokuapp.com/word | jq -r '.[0]')'","time":'$(($RANDOM%($max-$min+1)+$min))', "activation":"ilm"}' localhost:9090/teams
done

curl -s -H "Authorization:$TOKEN" localhost:9090/logout