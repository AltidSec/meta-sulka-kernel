FILESEXTRAPATHS:prepend:sulka := "${THISDIR}/${PN}:"

SRC_URI:append:sulka = " file://sulka-sysctl.conf"

do_install:append:sulka () {
        cat ${WORKDIR}/sulka-sysctl.conf >> ${D}${sysconfdir}/sysctl.conf
}
