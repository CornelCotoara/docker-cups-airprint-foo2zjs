FROM debian:buster-slim

# Install packages
RUN apt update && apt install -y --no-install-recommends --no-install-suggests \
	cups \
	cups-pdf \
	inotify-tools \
	python3-cups \
	avahi-daemon \
	build-essential \
	tix \	
	groff \
	git \
	dc \
	vim

# Expose port and volumes
EXPOSE 631/tcp
VOLUME /config
VOLUME /services

# Add scripts and build foo2zjs
ADD scripts /scripts
RUN chmod +x /scripts/* &&  ./scripts/build-foo2zjs.sh

# Change default CUPS settings
RUN sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf && \
	sed -i 's/Browsing Off/Browsing On/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/>/<Location \/>\n  Allow All/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow All\n  Require user @SYSTEM/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow All/' /etc/cups/cupsd.conf && \
	echo "ServerAlias *" >> /etc/cups/cupsd.conf && \
	echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf

# Cleanup
RUN apt purge -y build-essential wget dc vim groff \
	&& apt autoremove --purge -y \
	&& apt clean all -y \
	&& rm -rf /var/lib/apt/lists/*

# Run CUPS
CMD ["/scripts/run-cups.sh"]
