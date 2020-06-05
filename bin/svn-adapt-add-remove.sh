#!/bin/bash
svn status "$@" | \
    while read s f ; do
	if [ "$s" == "?" ] ; then
	    svn add "$f"
	fi

	if [ "$s" == "!" ] ; then
	    svn remove "$f"
	fi
	if [ "$s" == "!M" ] ; then
	    svn remove "$f"
	fi
    done
												     
