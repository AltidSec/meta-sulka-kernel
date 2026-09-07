FILESEXTRAPATHS:prepend:sulka-hardening := "${THISDIR}/${PN}:"

SRC_URI:append:sulka-hardening = " file://sulka-sysctl.conf"

do_install:append:sulka-hardening () {
        cat ${UNPACKDIR}/sulka-sysctl.conf >> ${D}${sysconfdir}/sysctl.conf
}
