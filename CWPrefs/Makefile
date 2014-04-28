TARGET = :clang
ARCHS = armv7 armv7s arm64
DEBUG = 1

include theos/makefiles/common.mk

BUNDLE_NAME = CWPrefs
CWPrefs_FILES = CWPrefs.mm ../CWDynamicReader.xm
CWPrefs_INSTALL_PATH = /Library/PreferenceBundles
CWPrefs_FRAMEWORKS = UIKit
CWPrefs_PRIVATE_FRAMEWORKS = Preferences
CWPrefs_LIBRARIES = sqlite3 objcipc

include $(THEOS_MAKE_PATH)/bundle.mk
