# This repo will be moved to gitlab under the Ziron Project banner


<div align="center">
  <h1 align="center">Zenaro Development Container Images</h1>
  <p align="center">Bootable Container images for rpm-ostree (In development)</p>
</div>

<br/>

<div align="left">
  <a href="https://github.com/ZenaroDev/container-devel/blob/devel/LICENSE">
    <img src="https://img.shields.io/badge/License-BSD--3-purple.svg">
  </a>
  <a href="https://github.com/ZenaroDev/container-devel/actions">
    <img src="https://github.com/ZenaroDev/container-devel/actions/workflows/build.yml/badge.svg">
  </a>

1. [Features](#Features)
1. [Tips and tricks](#Tips-and-tricks)
1. [How to install](#How-to-install)
1. [Special Thanks](#Special-Thanks)

## Features:

- Stable and Reliable Fedora System
- Distrobox, neovim, starship and chezmoi installed  by default
- Flatpak and rpm-ostree autoupdate, thanks [ublue team](https://github.com/ublue-os/config)
- Native integration with appimages with [AppImageLauncher](https://github.com/TheAssassin/AppImageLauncher)
- Added tiling functionality to all DEs

## Tips and tricks

Unlike the tradicional desktop, the image shouldn't be changed instead, toolbox or distrobox
should be used to interact with mutable images. It's even possible to run [DEs or WMs](https://github.com/89luca89/distrobox/blob/main/docs/posts/run_latest_gnome_kde_on_distrobox.md)
inside it.

If you want to check the image before using it run:

**Podman**

podman run -it ghcr.io/zenaroos/image-name:version bash

With this you can check the container without using on the host machine via rpm-ostree

## How to Install?

On the terminal run:

**Gahnite ( Gnome Spin )**
  
```
rpm-ostree rebase ostree-unverified-registry:ghcr.io/zenaroos/gahnite-devel:latest
```
  
**Kinoite ( KDE Spin )**
  
```
rpm-ostree rebase ostree-unverified-registry:ghcr.io/zenaroos/kinoite-devel:latest
```
  
**Sphene ( Sway Spin )**
  
```
rpm-ostree rebase ostree-unverified-registry:ghcr.io/zenaroos/sphene-devel:latest
```
  
***Replace the latest tag with the version or date desired***

## Special Thanks

| Project | Helped | License
|:---|:----|:------:
Fedora Project | Created the distro and rpm-ostree | MIT
UblueOS team | Showed me how to create and edit Ostree Images | Apache 2.0

***This is a personal project, none that were thanked here endorse or promote this project***

### This repo has a lot of code adapted or used from [ublue-os/main](https://github.com/ublue-os/main) and [ublue-os/startingpoint](https://github.com/ublue-os/startingpoint/)
