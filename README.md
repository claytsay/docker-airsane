# docker-airsane

A Dockerized SANE/AirSane scanner server.

## Abstract

This Debian-based Docker container contains daemons for [SANE](http://sane-project.org) and [AirSane](https://github.com/SimulPiscator/AirSane).

## Installation and Usage

This Docker container takes in the following environment variables:

- `SANED_ACL` (required): the IP range of hosts that are allowed to access the daemon.
- `SANED_DEVICE` (required): the device (as reported by `scanimage -L`) to broadcast to the network.
- `SANED_DLL` (optional): values used to overwrite `/etc/sane.d/dll.conf` for a faster `saned` response.

An example CLI usage is shown below:

```docker run --device /dev:/dev --privileged -e SANED_ACL="192.168.0.0/24\n10.0.0.0/8" -e SANED_DEVICE="hpaio:xxx" -e SANED_DLL="hp\hpaio" sesceu/saned```

It is important to make sure that the device node (e.g. `/dev/usb/00x/`) has group ID 7 (`lp`) and group read access.

## License Notice

This repo is a derivative of [sesceu/docker-saned](https://github.com/sesceu/docker-saned) by Sebastian Schneider, which is licensed under the Apache License 2.0. The repository was forked on October 30, 2021, 21:00 UTC. The following is a list of changes which have been made, on a per-file basis:

- `Dockerfile`
  - Changed base from Ubuntu 16.04 to Debian Buster
  - Added code to install AirSane
  - Exposed port 8090 (the default port for AirSane's web interface)
  - Removed/reworked comments
  - Changed formatting
- `supervisord.conf`
  - Added AirSane daemon and its configuration
  - Minor fixes in some other configurations

