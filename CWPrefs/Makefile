TARGET =: clang
ARCHS = armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = CWPrefs
CWPrefs_FILES = CWPrefs.mm
CWPrefs_INSTALL_PATH = /Library/PreferenceBundles
CWPrefs_FRAMEWORKS = UIKit
CWPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk
