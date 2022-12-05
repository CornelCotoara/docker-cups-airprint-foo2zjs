#!/bin/bash
inotifywait -m -e close_write,moved_to,create /hp1020 |
	while read -r directory events filename; do
		if [ "$filename" = "cat_fw" ]; then
			./etc/hotplug/usb/hplj1020
			sleep 5 
			rm /hp1020/cat_fw
		fi
	done
