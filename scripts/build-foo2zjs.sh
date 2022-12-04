#!/bin/bash
	git -c http.sslVerify=false clone https://github.com/koenkooi/foo2zjs.git &&
	cd foo2zjs &&
	make &&
	# ./getweb all && # already available via git clone
	make install &&
	make install-hotplug &&
	cd .. &&
	rm -rf foo2zjs
