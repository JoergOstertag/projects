#!/bin/bash

echo "$1" "$2"
if [ -d "$2" -o -e "$2" ] ; then
    mv "$2" "$2-new"
    svn remove "$2"
    svn -R revert "$1"
    svn rename "$1" "$2"
    mv "$2-new" "$2"   
else
    svn rename "$1" "$2"   
fi
