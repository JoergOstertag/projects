#!/bin/bash
IP=192.168.1.28
IP=192.168.1.11


for file in roomLayout.svg scan-3D.scad distanceGraph.svg scan.csv; do
    echo "=======> $file"
    curl http://$IP/$file >img/$file
done
