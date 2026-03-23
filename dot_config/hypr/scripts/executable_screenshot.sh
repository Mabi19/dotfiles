#!/bin/bash

# 

coproc spaceshot defer output
read -r READY <&"${COPROC[0]}"

if [ "$READY" != "ready" ]; then
    exit 1
fi

# Window mode isn't done, so don't include it for now
CHOICE=$(printf "Region\\nOutput" | walker -d)

case "$CHOICE" in
    "Region") ARGS=("region") ;;
    "Monitor") ARGS=("output") ;;
    "Window") ARGS=("cancel") ;;
    *) exit 1 ;;
esac

for arg in "${ARGS[@]}"; do
    printf '%s\0' "$arg" >&"${COPROC[1]}"
done

# shellcheck disable=SC2093,SC1083
exec {COPROC[1]}>&-
wait "$COPROC_PID"

if [ $CHOICE = "Window" ] then
    # figure out how to dmenu this.
    # A walker lua script might work better here.
    # But the toplevel picker would just be the best option.
fi
