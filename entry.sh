#!/bin/sh
if [ ! -d "/var/run/sshd" ]; then
	  mkdir -p /var/run/sshd
fi

echo "Starting SSH server"
/usr/sbin/sshd -D
