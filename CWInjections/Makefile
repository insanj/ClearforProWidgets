TARGET = :clang
ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

TWEAK_NAME = CWInjections
CWInjections_FILES = CWInjections.xm ../CWDynamicReader.xm
CWInjections_FRAMEWORKS = UIKit Foundation
CWInjections_LIBRARIES = sqlite3
CWInjections_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
