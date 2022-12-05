#!/bin/bash
inotifywait -m -e create /hp1020 |
        while read -r directory events filename; do
                if [ "$filename" = "need_fw" ]; then
                        ./etc/hotplug/usb/hplj1020
                        touch /hp1020/succes 
                        rm /hp1020/cat_fw
                fi
        done
