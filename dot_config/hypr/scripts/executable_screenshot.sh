#!/bin/bash

coproc spaceshot defer
read -r READY <&"${COPROC[0]}"

if [ "$READY" != "ready" ]; then
    exit 1
fi

CHOICE=$(printf "Region\\nOutput" | walker -d)

case "$CHOICE" in
    "Region") ARGS=("region") ;;
    "Output") ARGS=("output") ;;
    *) exit 1 ;;
esac

for arg in "${ARGS[@]}"; do
    printf '%s\0' "$arg" >&"${COPROC[1]}"
done

# shellcheck disable=SC2093,SC1083
exec {COPROC[1]}>&-

wait "$COPROC_PID"
