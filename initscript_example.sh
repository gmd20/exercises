#!/bin/sh

function start () {
	echo start...
	test -f /usr/sbin/sshd || exit 0

}

function stop () {
	echo stop...

}

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	restart)
		stop
		start
		;;
	*)
        	echo "Usage: $0 {start|stop|restart|status}"
		exit 1
esac
