#!/bin/bash
[ -z "$1" ] && echo "You must specify an epoch seconds string." && exit 1
date --set="@$1"
