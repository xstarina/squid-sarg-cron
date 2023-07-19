#!/bin/bash

set -e

# re-create snakeoil self-signed certificate removed in the build process
[[ ! -f /etc/ssl/private/ssl-cert-snakeoil.key ]] && /usr/sbin/make-ssl-cert generate-default-snakeoil --force-overwrite > /dev/null 2>&1

# create missing cache directories and exit
/usr/sbin/squid -Nz

exec "$@"
