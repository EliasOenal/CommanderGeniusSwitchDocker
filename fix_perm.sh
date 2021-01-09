#!/usr/bin/env bash
# Written and placed into the public domain by
# Elias Oenal <cg@eliasoenal.com>
set -e
if [[ -n "$GID" ]] && [[ ! -e "/fgid" ]]; then
usermod -g "$GID" user
chgrp -R "$GID" /home/user
touch /fgid
fi
if [[ -n "$UID" ]] && [[ "$UID" -ne 0 ]] && [[ ! -e "/fuid" ]]; then
usermod -u "$UID" user
chown -R "$UID" /home/user
touch /fuid
fi
