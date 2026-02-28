#!/usr/bin/env bash
# Kill existing bars
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar(s)
polybar mybar 2>&1 | tee -a /tmp/polybar.log & disown
