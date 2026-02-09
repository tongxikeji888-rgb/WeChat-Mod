TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = WeChat

# 这一行是多巴胺越狱的命根子
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WeChatMod

WeChatMod_FILES = Tweak.x
WeChatMod_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
