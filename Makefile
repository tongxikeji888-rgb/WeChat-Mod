TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = WeChat
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WeChatMod

WeChatMod_FILES = Tweak.x

# 🟢 关键修改在这里！
# -Wno-error : 告诉编译器，警告不是错误，别给我报错！
# -Wno-deprecated-declarations : 告诉编译器，我就爱用老代码，别啰嗦！
WeChatMod_CFLAGS = -fobjc-arc -Wno-error -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk
