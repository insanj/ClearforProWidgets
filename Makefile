THEOS_PACKAGE_DIR_NAME = debs
TARGET = :clang
ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

BUNDLE_NAME = ClearForProWidgets
ClearForProWidgets_FILES = $(wildcard *.xm)
ClearForProWidgets_INSTALL_PATH = /Library/ProWidgets/Widgets/
ClearForProWidgets_FRAMEWORKS = UIKit CoreGraphics QuartzCore
ClearForProWidgets_LIBRARIES = prowidgets # objcipc
ClearForProWidgets_BUNDLE_EXTENSION = widget

include $(THEOS_MAKE_PATH)/bundle.mk
SUBPROJECTS += CWPrefs
# SUBPROJECTS += CWIPC
include $(THEOS_MAKE_PATH)/aggregate.mk

internal-after-install::
	install.exec "killall -9 backboardd"
