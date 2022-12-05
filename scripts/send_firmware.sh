#!/bin/bash
inotifywait -m -e close_write,moved_to,create,attrib,access /hp1020 |
        while read -r directory events filename; do
                if [ "$filename" = "need_fw" ]; then
                        ./etc/hotplug/usb/hplj1020
                        touch /hp1020/succes 
                        rm /hp1020/need_fw
                fi
        done
