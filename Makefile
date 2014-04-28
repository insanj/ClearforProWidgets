THEOS_PACKAGE_DIR_NAME = debs
TARGET = :clang
ARCHS = armv7 armv7s arm64
DEBUG = 1

include theos/makefiles/common.mk

BUNDLE_NAME = ClearForProWidgets
ClearForProWidgets_FILES = $(wildcard *.xm)
ClearForProWidgets_INSTALL_PATH = /Library/ProWidgets/Widgets/
ClearForProWidgets_FRAMEWORKS = UIKit CoreGraphics QuartzCore
ClearForProWidgets_LIBRARIES = prowidgets sqlite3 objcipc
ClearForProWidgets_BUNDLE_EXTENSION = widget
ClearForProWidgets_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
SUBPROJECTS = CWInjections CWPrefs CWIPC
include $(THEOS_MAKE_PATH)/aggregate.mk

before-stage::
	find . -name ".DS_Store" -delete
internal-after-install::
	install.exec "killall -9 backboardd"
