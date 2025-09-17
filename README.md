# Sulka Kernel

Sulka is a Yocto Linux distribution that focuses on the security hardening.

This meta-layer provides the kernel metadata that can be used to harden the kernel configuration, and the metadata here is used in the default build of Sulka.
The hardening is based on the suggestions from [kernel-hardening-checker by a13xp0p0v](https://github.com/a13xp0p0v/kernel-hardening-checker).

This kernel metadata and configuration is assumed to be used with `linux-yocto`.
However, it should be possible to use the metadata with other kernel recipes as well, assuming the versions do not differ too much.
