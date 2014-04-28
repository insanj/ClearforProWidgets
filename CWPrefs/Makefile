TARGET =: clang
ARCHS = armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = CWPrefs
CWPrefs_FILES = CWPrefs.mm ../CWDynamicReader.xm
CWPrefs_INSTALL_PATH = /Library/PreferenceBundles
CWPrefs_FRAMEWORKS = UIKit
CWPrefs_PRIVATE_FRAMEWORKS = Preferences
CWPrefs_LIBRARIES = sqlite3

include $(THEOS_MAKE_PATH)/bundle.mk
