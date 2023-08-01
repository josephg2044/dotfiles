#!/bin/sh

if [ -f /tmp/xbkt ]; then 
    killall xbindkeys
    rm /tmp/xbkt
else 
    xbindkeys
    touch /tmp/xbkt
fi
