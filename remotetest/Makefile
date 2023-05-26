TARGET = appletv
#TARGET = iphone:9.0
export GO_EASY_ON_ME=1
export SDKVERSION=10.2
#THEOS_DEVICE_IP=atvjb.local
THEOS_DEVICE_IP=guest-room.local

include theos/makefiles/common.mk

TOOL_NAME = airmagicd
airmagicd_FILES = main.m $(wildcard *.mm) $(wildcard *.m) $(wildcard core/*.m)
#airmagicd_LDFLAGS = -F/Users/kevinbradley/Downloads/Xcode.app/Contents/Developer/Platforms/AppleTVOS.platform/Developer/SDKs/#AppleTVOS.sdk/System/Library/PrivateFrameworks -undefined dynamic_lookup
#airmagicd_LDFLAGS = -undefined dynamic_lookup

airmagicd_CXXFLAGS += -fobjc-arc -I. -Iinclude
airmagicd_CFLAGS += -fobjc-arc -Wno-unused-variable -Wno-deprecated-declarations -Wno-logical-not-parentheses -Wno-unused-function -Wno-int-to-pointer-cast -Wno-unused-variable -Wno-unused-but-set-variable -Wno-format -Wno-memset-transposed-args -Wno-int-conversion -I. -Iinclude
airmagicd_LDFLAGS += -Wl,-segalign,4000
airmagicd_LDFLAGS += -F. -framework BackBoardServices -framework IOKit
airmagicd_INSTALL_PATH = /fs/jb/usr/libexec
airmagicd_CODESIGN_FLAGS=-Sent.plist
airmagicd_Frameworks += WebCore ImageIO Foundation CFNetwork AppSupport UIKit IOKit MobileCoreServices BackBoardServices
#airmagicd_PRIVATE_FRAMEWORKS = BackBoardServices
#airmagicd_LIBRARIES += rocketbootstrap
include $(THEOS_MAKE_PATH)/tool.mk

after-install::
	#install.exec "killall -9 PineBoard SpringBoard"
	#install.exec "syslog -w"
	
