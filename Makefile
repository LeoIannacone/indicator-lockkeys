all: build_code build_icons

install: install_icons update_icon_cache install_bin install_desktop

uninstall: uninstall_icons update_icon_cache uninstall_bin uninstall_desktop

clean:
	rm -f indicator-lockkeys
	rm -fr icons/dark
	rm -fr icons/light

build_code:
	valac --vapidir vapi/ \
		  --pkg appindicator3-0.1 \
		  --pkg caribou-1.0 \
		  --pkg gtk+-3.0 \
		  *.vala

build_icons:
	cd icons ; \
	mkdir -p dark light ; \
	cp *svg dark/ ; \
	for i in *svg ; do sed s/dfdbd2/3c3c3c/g $$i > light/$$i ; done

update_icon_cache:
	update-icon-caches /usr/share/icons/hicolor
	update-icon-caches /usr/share/icons/ubuntu-mono-light
	update-icon-caches /usr/share/icons/ubuntu-mono-dark

install_icons:
	mkdir -p /usr/share/icons/ubuntu-mono-dark/status/22/
	mkdir -p /usr/share/icons/ubuntu-mono-light/status/22/
	mkdir -p /usr/share/icons/hicolor/22x22/status

	cd icons ; \
	cp -r dark/* /usr/share/icons/ubuntu-mono-dark/status/22/ ; \
	cp -r light/* /usr/share/icons/ubuntu-mono-light/status/22/ ; \
	cp -r dark/* /usr/share/icons/hicolor/22x22/status

uninstall_icons:
	cd icons ; for i in *svg ; do \
		rm -f /usr/share/icons/ubuntu-mono-light/status/22/$$i ; \
		rm -f /usr/share/icons/ubuntu-mono-dark/status/22/$$i ; \
		rm -f /usr/share/icons/hicolor/22x22/status/$$i ; \
	done

install_bin:
	cp indicator-lockkeys /usr/bin

uninstall_bin:
	rm -f /usr/bin/indicator-lockkeys


install_desktop:
	mkdir -p /etc/xdg/autostart/
	cp indicator-lockkeys.desktop /etc/xdg/autostart/

uninstall_desktop:
	rm -f /etc/xdg/autostart/indicator-lockkeys.desktop

.DEFAULT_TARGET: all
.PHONY: *
