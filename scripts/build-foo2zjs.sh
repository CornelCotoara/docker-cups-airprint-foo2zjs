#!/bin/bash
	git clone https://github.com/koenkooi/foo2zjs.git &&
	cd foo2zjs &&
	make &&
	./getweb all &&
	make install &&
	make install-hotplug &&
	cd .. &&
	rm -rf foo2zjs.tar.gz foo2zjs
