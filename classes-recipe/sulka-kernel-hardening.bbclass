FILESEXTRAPATHS:prepend:sulka := "${SULKA_KMETA_LOCATION}:"

SRC_URI:append:sulka = " \
    file://sulka-kmeta;type=kmeta;name=sulka-kmeta;destsuffix=sulka-kmeta \
"

KERNEL_FEATURES:append:sulka-harden-kernel = " \
    features/security/security.cfg \
    features/sulka-security/audit.scc \
    features/sulka-security/sulka-cut-attack-surface.scc \
    features/sulka-security/sulka-harden-userspace.scc \
    features/sulka-security/sulka-security-policy.scc \
    features/sulka-security/sulka-self-protection.scc \
"

KERNEL_FEATURES:append:sulka-disable-graphics = " \
    features/sulka-security/sulka-cut-graphics.scc \
"

KERNEL_FEATURES:append:sulka-disable-kernel-modules = " \
    features/sulka-security/sulka-cut-kernel-modules.scc \
"

KERNEL_FEATURES:append:sulka-read-only-rootfs = " \
    features/sulka-read-only-rootfs/sulka-erofs.scc \
"

KERNEL_FEATURES:append:sulka-development-mode = " features/sulka-security/sulka-kernel-develop.scc "
