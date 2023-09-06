#!/usr/bin/env bash
set -e


if [[ -z "$HOST_UID" ]]; then
    echo "ERROR: please set HOST_UID" >&2
    exit 1
fi

if [[ -z "$HOST_GID" ]]; then
    echo "ERROR: please set HOST_GID" >&2
    exit 1
fi

echo running as user: $HOST_UID:$HOST_GID

# Use this code if you want to modify an existing user account:
groupmod --gid "$HOST_GID" user
usermod --uid "$HOST_UID" user

# Drop privileges and execute next container command, or 'bash' if not specified.
if [[ $# -gt 0 ]]; then
    exec sudo -u user -H -- "$@"
else
    exec sudo -u user -H -- bash
fi
