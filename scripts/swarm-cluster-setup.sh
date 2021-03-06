#!/bin/sh

## Only for "Docker Toolbox" (Docker + Virtualbox)
## Create a Swarm cluster with 3 nodes (1 Manager & 2 Workers)

for i in 1 2 3; do
    docker-machine create -d virtualbox --virtualbox-memory 1024 node-$i
    #docker-machine create -d virtualbox --virtualbox-memory 4096 --virtualbox-cpu-count 2 --virtualbox-disk-size 50000 node-$i

done

eval "$(docker-machine env node-1)"

docker swarm init --advertise-addr "$(docker-machine ip node-1)"

TOKEN=$(docker swarm join-token -q worker)

for i in 2 3; do
    eval "$(docker-machine env node-$i)"
    docker swarm join --token $TOKEN "$(docker-machine ip node-1)":2377
done

echo "Swarm cluster has been successfuly created !";

eval "$(docker-machine env node-1)"

docker node ls