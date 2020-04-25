all:

install:
	install -d $(DESTDIR)/usr/sbin
	install vyos-cli-setup $(DESTDIR)/usr/sbin
	install vyos-cli-useradd $(DESTDIR)/usr/sbin
	install vyos-cli-ethadd $(DESTDIR)/usr/sbin
