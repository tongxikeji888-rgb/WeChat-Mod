TARGET := iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = WeChat
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WeChatMod

WeChatMod_FILES = Tweak.x
WeChatMod_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
