#! /usr/bin/env bash                                                                                                                                                                                                                          

docker network rm 7ex_network

docker network create -d bridge \
    --subnet=172.88.88.0/24 \
    --gateway=172.88.88.1 \
    --attachable \
    --label=com.docker.project=7ex \
    --label=com.docker.network=7ex-network \
    7ex_network

docker network ls
