#!/usr/bin/env bash
# Written and placed into the public domain by
# Elias Oenal <cg@eliasoenal.com>
set -e
/fix_perm.sh
su -c /home/user/build_user.sh user