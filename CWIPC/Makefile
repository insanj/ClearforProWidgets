TARGET = :clang
ARCHS = armv7 armv7s arm64
DEBUG = 1

include theos/makefiles/common.mk

TWEAK_NAME = CWIPC
CWIPC_FILES = CWIPC.xm ../CWDynamicReader.xm
CWIPC_FRAMEWORKS = CoreFoundation Foundation UIKit
CWIPC_LIBRARIES = objcipc sqlite3

include $(THEOS_MAKE_PATH)/tweak.mk
