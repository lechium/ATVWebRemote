TARGET = appletv
#TARGET = iphone:9.0
export GO_EASY_ON_ME=1
export SDKVERSION=10.2
#THEOS_DEVICE_IP=atvjb.local
THEOS_DEVICE_IP=guest-room.local

include theos/makefiles/common.mk

TWEAK_NAME = remoteTest
remoteTest_FILES = Tweak.xm $(wildcard *.mm) $(wildcard *.m) $(wildcard core/*.m)
#remoteTest_LDFLAGS = -F/Users/kevinbradley/Downloads/Xcode.app/Contents/Developer/Platforms/AppleTVOS.platform/Developer/SDKs/#AppleTVOS.sdk/System/Library/PrivateFrameworks -undefined dynamic_lookup
remoteTest_LDFLAGS = -undefined dynamic_lookup

remoteTest_CXXFLAGS += -fobjc-arc
remoteTest_CFLAGS += -fobjc-arc -Wno-unused-variable -Wno-deprecated-declarations -Wno-logical-not-parentheses -Wno-unused-function -Wno-int-to-pointer-cast -Wno-unused-variable -Wno-unused-but-set-variable -Wno-format -Wno-memset-transposed-args -Wno-int-conversion
remoteTest_LDFLAGS += -Wl,-segalign,4000
remoteTest_LDFLAGS += -F.
remoteTest_Frameworks += WebCore ImageIO Foundation CFNetwork AppSupport UIKit IOKit MobileCoreServices BackBoardServices
#remoteTest_PRIVATE_FRAMEWORKS = BackBoardServices 
#remoteTest_LIBRARIES += rocketbootstrap
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 PineBoard SpringBoard"
	install.exec "syslog -w"
	
