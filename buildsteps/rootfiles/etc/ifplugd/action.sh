#!/bin/sh

[ "$#" -ne 2 ] && echo "Not enough arguments!" && exit 1

iface=$1
action=$2

case "$action" in
	up)
		ifup $iface
		;;
	down)
		ifdown $iface
		;;
	*)
		echo "Unknown action $action on iface $iface!"
		exit 1
		;;
esac
