ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = WeChat

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WeChatMod

WeChatMod_FILES = Tweak.x
WeChatMod_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
