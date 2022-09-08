#!/bin/bash
a=$1 #no spaces after "="

if [ "$a" == "true" ]; then # space is required after ans before "["
    echo true condition is executed

    elif [ "$a" == "false" ];  then
    echo false statement is executed

    else
    echo "no statement is executed"
    fi;


  