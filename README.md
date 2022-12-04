# Table of Contents
* [About](#about)
* [Intro](#intro)
* [Multi-arch Image](#multi-arch)
* [Getting Started](#start)
  + [Docker Create](#dcreate)
    + [Parameters](#dparams)
* [Using](#using)
* [Notes](#notes)
* [Trouble Shooting](#trouble)
  + [Missing Printer Driver](#missing-driver)
  + [Driver Version](#driver-version)

# docker pull ghcr.io/cornelcotoara/docker-cups-airprint-foo2zjs:master

# [About](#toc)
Modified copy of source code at:
https://github.com/quadportnick/docker-cups-airprint

# <a name="intro"></a> [Multi-arch Image](#toc)
This Debian-based Docker image runs a CUPS instance that is meant as an AirPrint
relay for printers that are already on the network but not AirPrint capable.
The local Avahi will be utilized for advertising the printers on the network.

# <a name="multi-arch"></a> [Multi-arch Image](#toc)
The below commands reference a [Docker Manifest List](https://docs.docker.com/engine/reference/commandline/manifest/) at [`xxx/cups-airprint`](https://hub.docker.com/r/xxx/cups-airprint) built using Docker's
[BuildKit](https://docs.docker.com/develop/develop-images/build_enhancements/).
Simply running commands using this image will pull
the matching image architecture (e.g. `amd64`, `arm32v7`, or `arm64`) based on
the hosts architecture. Hence, if you are on a **Raspberry Pi** the below
commands will work the same as if you were on a traditional `amd64`
desktop/laptop computer. **Note**: Because the image requires `ubuntu` as its base
image, there is currently no `arm32v6` architecture available. This means if your
target hardware is a **Raspberry Pi Zero** or similar `arm 6` architecture, this
image will not run.

# [Getting Started](#toc)
This section will give an overview of the essential options/arguments to pass
to docker to successfully run containers from the `xxx/cups-airprint` docker
image.

## <a name="dcreate"></a> [Docker Create](#toc)
Creating a container is often more desirable than directly running it:

```sh
$ docker create \
       --name=cups-airprint-foo2zjs \
       --restart=always \
       --net=host \
       -v /var/run/dbus:/var/run/dbus \
       -v ~/airprint_data/config:/config \
       -v ~/airprint_data/services:/services \
       --device /dev/bus \
       --device /dev/usb \
       -e CUPSADMIN="admin" \
       -e CUPSPASSWORD="password" \
       xxx/cups-airprint-foo2zjs
```
Follow this with `docker start` and your cups/airprint printer is running:

```sh
$ docker start cups-airprint-foo2zjs
```
To stop the container simply run:
```sh
$ docker stop cups-airprint-foo2zjs
```
To remove the conainer simply run:
```sh
$ docker rm cups-airprint-foo2zjs
```

**Notes**: As mentioned in the *Notes* subsection of the [Run](#run) section,
the `Dockerfile` explicitly declares two volumes at `/config` and `/services`
inside the container as mount points. Here we actually override the default
use of Docker's innate volume management system and declare our own path on the
host system to mount the two directories `/config` and `/services`. Why? Because
now if the container is deleted (for any number of reason ...) the data will
persist. Here we chose to mount the internal `/config` and `/services`
directories to `~/airprint_data/config` and `~/airprint_data/services`
respectively, but these could just as well be anywhere on your file system.

### [Parameters](#toc)
* `--name`: gives the container a name making it easier to work with/on (e.g.
  `cups`)
* `--restart`: restart policy for how to handle restarts (e.g. `always` restart)
* `--net`: network to join (e.g. the `host` network)
* `-v ~/airprint_data/config:/config`: where the persistent printer configs
   will be stored
* `-v ~/airprint_data/services:/services`: where the Avahi service files will
   be generated
* `-e CUPSADMIN`: the CUPS admin user you want created
* `-e CUPSPASSWORD`: the password for the CUPS admin user
* `--device /dev/bus`: device mounted for interacting with USB printers
* `--device /dev/usb`: device mounted for interacting with USB printers

## [Using](#toc)
CUPS will be configurable at http://localhost:631 using the
CUPSADMIN/CUPSPASSWORD when you do something administrative.

If the `/services` volume isn't mapping to `/etc/avahi/services` then you will
have to manually copy the .service files to that path at the command line.

## [Notes](#toc)
* CUPS doesn't write out `printers.conf` immediately when making changes even
though they're live in CUPS. Therefore it will take a few moments before the
services files update
* Don't stop the container immediately if you intend to have a persistent
configuration for this same reason

### [Missing Printer Driver](#toc)
As you might imagine this is **the most common** problem users have when setting
up their printers. While the **xxx/cups-airprint** image possesses
**multiple printer drivers**, it most likely **does not** have every driver for
every printer. This issue can be resolved as follows:

+ Figure out what printer driver you need, open an issue about missing driver,
  necessary package containing said driver will be added to **Dockerfile**.

