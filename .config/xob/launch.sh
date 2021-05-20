#!/bin/bash

rm -f /tmp/xobpipe-volume
mkfifo /tmp/xobpipe-volume
tail -f /tmp/xobpipe-volume | xob -s volume &

rm -f /tmp/xobpipe-brightness
mkfifo /tmp/xobpipe-brightness
tail -f /tmp/xobpipe-brightness | xob -s brightness &
