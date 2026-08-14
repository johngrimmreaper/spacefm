desktopdir = $(datadir)/applications
dt_in_files = spacefm.desktop.in \
			spacefm-find.desktop.in \
			spacefm-folder-handler.desktop.in
desktop_DATA = $(dt_in_files:.desktop.in=.desktop)
@INTLTOOL_DESKTOP_RULE@

DISTCLEANFILES = spacefm.desktop \
			spacefm-find.desktop \
			spacefm-folder-handler.desktop

DIST_ICON_FILES = \
			spacefm.png \
			spacefm-root.png \
			spacefm-find.png \
			spacefm-48-cube-blue.png \
			spacefm-48-cube-green.png \
			spacefm-48-cube-red.png \
			spacefm-48-faenza-blue.png \
			spacefm-48-faenza-find.png \
			spacefm-48-faenza-red.png \
			spacefm-48-folder-blue.png \
			spacefm-48-folder-red.png \
			spacefm-48-pyramid-blue.png \
			spacefm-48-pyramid-green.png \
			spacefm-48-pyramid-red.png \
			spacefm-128-cube-blue.png \
			spacefm-128-cube-green.png \
			spacefm-128-cube-red.png \
			spacefm-128-pyramid-blue.png \
			spacefm-128-pyramid-green.png \
			spacefm-128-pyramid-red.png \
			faenza/spacefm.png \
			faenza/spacefm-root.png \
			faenza/spacefm-find.png

if NO_PIXMAPS
icon48dir = $(datadir)/icons/hicolor/48x48/apps
icon48_DATA = \
			spacefm.png \
			spacefm-root.png \
			spacefm-find.png \
			spacefm-48-cube-blue.png \
			spacefm-48-cube-green.png \
			spacefm-48-cube-red.png \
			spacefm-48-folder-blue.png \
			spacefm-48-folder-red.png \
			spacefm-48-pyramid-blue.png \
			spacefm-48-pyramid-green.png \
			spacefm-48-pyramid-red.png

icon128dir = $(datadir)/icons/hicolor/128x128/apps
icon128_DATA = \
			spacefm-128-cube-blue.png \
			spacefm-128-cube-green.png \
			spacefm-128-cube-red.png \
			spacefm-128-pyramid-blue.png \
			spacefm-128-pyramid-green.png \
			spacefm-128-pyramid-red.png
			
faenzadir = $(datadir)/icons/Faenza/apps/48
faenza_DATA = \
			faenza/spacefm.png \
			faenza/spacefm-root.png \
			faenza/spacefm-find.png
else
icondir = $(datadir)/pixmaps
icon_DATA = \
			spacefm.png \
			spacefm-root.png \
			spacefm-find.png \
			spacefm-128-cube-blue.png \
			spacefm-128-cube-green.png \
			spacefm-128-cube-red.png \
			spacefm-128-pyramid-blue.png \
			spacefm-128-pyramid-green.png \
			spacefm-128-pyramid-red.png \
			spacefm-48-cube-blue.png \
			spacefm-48-cube-green.png \
			spacefm-48-cube-red.png \
			spacefm-48-faenza-blue.png \
			spacefm-48-faenza-find.png \
			spacefm-48-faenza-red.png \
			spacefm-48-folder-blue.png \
			spacefm-48-folder-red.png \
			spacefm-48-pyramid-blue.png \
			spacefm-48-pyramid-green.png \
			spacefm-48-pyramid-red.png
endif

filedir = $(datadir)/spacefm
uidir=$(filedir)/ui

# sfm don't install mount.rules for no-hal build
if USE_HAL
file_DATA = \
	mount.rules
endif

# html-doc
htmldir = @htmldir@
dist_html_DATA = spacefm-manual-en.html

# GtkBuilder UI definition files
dist_ui_DATA = \
	ui/prefdlg.ui \
	ui/prefdlg2.ui \
	ui/appchooserdlg.ui \
	ui/file_properties.ui \
	ui/about-dlg.ui \
	ui/find-files.ui \
	ui/find-files2.ui \
	ui/godlg.ui

EXTRA_DIST = \
	$(dt_in_files) \
	$(DIST_ICON_FILES) \
	mount.rules
	
CLEANFILES = spacefm.desktop \
		 spacefm-find.desktop \
		 spacefm-folder-handler.desktop

