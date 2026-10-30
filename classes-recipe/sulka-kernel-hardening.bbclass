FILESEXTRAPATHS:prepend:sulka-hardening := "${SULKA_KMETA_LOCATION}:"

SRC_URI:append:sulka-hardening = " \
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

# Bundling the initramfs compiles the kernel again with a new structure layout
# seed, while the modules can come from the shared state cache with the old
# one. The kernel then refuses to load the modules, so disable the structure
# layout randomization of sulka-self-protection when the initramfs is bundled.
KERNEL_FEATURES:append:sulka-harden-kernel = "${@' features/sulka-security/sulka-no-randstruct.scc' if d.getVar('INITRAMFS_IMAGE_BUNDLE') == '1' else ''}"

# The module signing key and the trusted keys are built into the kernel, and
# the modules are signed with the key, but the task hashes only contain the
# paths of the keys. New keys at the same path would then mix modules signed
# with the old key from the shared state cache with a kernel built again with
# the new keys, which refuses to load them. Add the contents of the keys to
# the task hashes.
def sulka_kernel_key_checksums(d):
    keys = []
    if bb.data.inherits_class('kernel-modsign', d):
        keys += [d.getVar('MODSIGN_PRIVKEY'), d.getVar('MODSIGN_X509')]
    if bb.utils.contains('DISTRO_FEATURES', 'ima', True, False, d):
        keys.append(d.getVar('IMA_EVM_ROOT_CA'))
    return ' '.join('%s:True' % key for key in keys if key)

do_configure[file-checksums] += "${@sulka_kernel_key_checksums(d)}"

KERNEL_FEATURES:append:sulka-disable-graphics = " \
    features/sulka-security/sulka-cut-graphics.scc \
"

KERNEL_FEATURES:append:sulka-disable-kernel-modules = " \
    features/sulka-security/sulka-cut-kernel-modules.scc \
"

KERNEL_FEATURES:append:sulka-enable-module-signing = " \
    features/module-signing/force-signing.cfg \
"

KERNEL_FEATURES:append:sulka-read-only-rootfs = " \
    features/sulka-read-only-rootfs/sulka-erofs.scc \
"

KERNEL_FEATURES:append:sulka-development-mode = " features/sulka-security/sulka-kernel-develop.scc "
