# meta-sulka-kernel

This meta-layer provides the kernel hardening metadata used by the default Sulka build, along with the matching runtime `sysctl` settings.

Sulka is a Yocto Linux distribution that focuses on security hardening.
It ships hardened defaults across the kernel, the bootloader and the userspace, and expects the integrator to consciously relax hardening where their product requires it, rather than the other way round.

The hardening is primarily based on the suggestions from [kernel-hardening-checker by a13xp0p0v](https://github.com/a13xp0p0v/kernel-hardening-checker).

## What This Layer Provides

### Kernel Metadata

The kernel configuration lives under `kernel-metadata/sulka-kmeta/features/` as a set of `.scc` features and `.cfg` fragments:

| Feature | Purpose |
|---|---|
| `sulka-security/sulka-cut-attack-surface` | Removes legacy and rarely needed kernel interfaces |
| `sulka-security/sulka-self-protection` | Enables the kernel's own self-protection mechanisms |
| `sulka-security/sulka-harden-userspace` | Hardens the kernel/userspace boundary |
| `sulka-security/sulka-security-policy` | Configures the security policy and LSM support |
| `sulka-security/audit` | Enables the kernel audit subsystem |
| `sulka-security/sulka-cut-graphics` | Drops the graphics stack from the kernel |
| `sulka-security/sulka-cut-kernel-modules` | Builds a monolithic kernel with no loadable module support |
| `sulka-security/sulka-kernel-develop` | Relaxes hardening that gets in the way of development and debugging |
| `sulka-read-only-rootfs/sulka-erofs` | Adds the erofs support needed for a read-only root file system |

Several features carry architecture-specific fragments (`-x86_64`, `-arm64`) that are applied alongside the generic ones.

### Recipe Integration

`classes-recipe/sulka-kernel-hardening.bbclass` wires the metadata into the kernel recipe.
It adds `kernel-metadata` to `SRC_URI` as a `kmeta` source and selects the feature sets above through `KERNEL_FEATURES`.
Which features are selected depends on overrides that the Sulka distro sets from its configuration, so hardening, graphics removal, module removal, module signing, read-only rootfs and development mode each pull in their own set.

`recipes-kernel/linux/linux-yocto_6.18.bbappend` inherits that class for the kernel version Sulka targets.

### Runtime Sysctl Hardening

The layer is not limited to build-time kernel configuration.
`recipes-extended/procps/` appends `sulka-sysctl.conf` to `/etc/sysctl.conf`, covering BPF hardening, `ptrace` scope, kernel pointer restriction, `perf_event` access, oops and warning limits, and protected symlinks and hardlinks.

That bbappend names the exact `procps` version it applies to, so this part of the layer is tied to a particular `openembedded-core` version.
A mismatch fails the build as a dangling bbappend rather than quietly dropping the settings.

## Using This Layer With Another Kernel Recipe

The metadata is written for `linux-yocto` as used by the Sulka build, but it should work with other kernel recipes as long as the kernel versions are reasonably close.

To use it elsewhere, write your own bbappend for your kernel recipe and inherit the class from it:

```
inherit sulka-kernel-hardening
```

That is all that is needed. The class handles the metadata location, the `SRC_URI` entry and the feature selection on its own, so there is no reason to copy its contents into your own metadata.

Note that the class keys off the `sulka-hardening` override and the feature overrides that go with it, not off the distro name. Requiring `conf/distro/include/sulka-hardening.inc` from `meta-sulka-distro` sets them, from any distro. Without that include, set the overrides manually as necessary in your own build.

## Layer Information

| | |
|---|---|
| Layer name | `meta-sulka-kernel` |
| Priority | 10 |
| Yocto compatibility | Wrynose (`LAYERSERIES_COMPAT = "wrynose"`) |
| Declared layer dependencies | None |
| Target kernel | `linux-yocto` 6.18 in the default Sulka build |

## Documentation

To get started, read [the quick start guide](https://altidsec.com/sulka/documentation/quick-start.html).
The [user guide](https://altidsec.com/sulka/documentation/user-guide.html) covers the kernel-related topics in depth, including [kernel modules](https://altidsec.com/sulka/documentation/user-guide.html#kernel-modules), [module signing](https://altidsec.com/sulka/documentation/user-guide.html#module-signing), [signing external modules](https://altidsec.com/sulka/documentation/user-guide.html#signing-external-modules) and the full list of [configuration variables](https://altidsec.com/sulka/documentation/user-guide.html#configuration-variables).

If the website is unavailable, the same content can be read from [the documentation repository](https://codeberg.org/AltidSec/sulka-docs/src/branch/main/source).

## Contributing

Send pull requests, patches, comments or questions to the AltidSec repositories in Codeberg, and feel free to open issues to start discussions. Use `*-next` branches as pull request targets.

Maintainer:
Esa Jääskelä <esa.jaaskela@suomi24.fi>

## License

The metadata in this layer is licensed under the MIT license. See [COPYING.MIT](COPYING.MIT) for the full text.
Individual recipes fetch and build upstream components under their own licenses.
