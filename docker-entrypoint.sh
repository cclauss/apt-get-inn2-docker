#!/bin/sh

. lib/news/innshellvars

if [ ! -f $TLSKEYFILE ]; then
	echo "Generating SSL key"
	openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -keyout $TLSKEYFILE -out $TLSCERTFILE -subj "/CN=news.localhost"
fi

# Support for implicit TLS
nnrpd -D -p 563 -S

exec innd "$@"
