#!/bin/bash
curl http://192.168.1.28/roomLayout.svg >img/roomLayout.svg
curl http://192.168.1.28/scan-3D.scad >img/scan-3D.scad
curl http://192.168.1.28/distanceGraph.svg >img/distanceGraph.svg
curl http://192.168.1.28/scan.csv >img/scan.csv