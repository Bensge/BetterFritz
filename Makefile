include theos/makefiles/common.mk

TWEAK_NAME = BetterFritz
BetterFritz_FILES = Tweak.xm
BetterFritz_FRAMEWORKS = Foundation UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
