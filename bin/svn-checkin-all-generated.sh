#!/bin/bash

find . -name "stl" -o -name "README-images.md" -print0 | xargs  -0 svn ci -m"Update generated stl and png"
