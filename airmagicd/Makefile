
INSTALL_PATH = /usr/libexec
DAEMON_PATH = /Library/LaunchDaemons/
LD_COPY = com.nito.airmagicd.plist
LD_FINAL = com.nito.airmagicd.plist
POST_INST_FILE = postinst
ifneq (,$(findstring s, $(MAKEFLAGS)))
	INSTALL_PATH = /fs/jb/usr/libexec
	DAEMON_PATH = /fs/jb/Library/LaunchDaemons/
	LD_COPY = prefix_com.nito.airmagicd.plist
	POST_INST_FILE = prefix_postinst
	#echo "i was passed to MAKEFLAGS"
endif

TARGET = appletv
#TARGET = iphone:9.0
export GO_EASY_ON_ME=1
export SDKVERSION=10.2
#THEOS_DEVICE_IP=atvjb.local
THEOS_DEVICE_IP=guest-room.local

include theos/makefiles/common.mk

TOOL_NAME = airmagicd
airmagicd_FILES = $(wildcard src/*.mm) $(wildcard src/*.m) $(wildcard src/core/*.m)
#airmagicd_LDFLAGS = -F/Users/kevinbradley/Downloads/Xcode.app/Contents/Developer/Platforms/AppleTVOS.platform/Developer/SDKs/#AppleTVOS.sdk/System/Library/PrivateFrameworks -undefined dynamic_lookup
#airmagicd_LDFLAGS = -undefined dynamic_lookup

airmagicd_CXXFLAGS += -fobjc-arc -I. -Iinclude
airmagicd_CFLAGS += -fobjc-arc -Wno-unused-variable -Wno-deprecated-declarations -Wno-logical-not-parentheses -Wno-unused-function -Wno-int-to-pointer-cast -Wno-unused-variable -Wno-unused-but-set-variable -Wno-format -Wno-memset-transposed-args -Wno-int-conversion -I. -Iinclude
airmagicd_LDFLAGS += -Wl,-segalign,4000
airmagicd_LDFLAGS += -F. -FFrameworks -framework BackBoardServices -framework IOKit
airmagicd_INSTALL_PATH = $(INSTALL_PATH)
airmagicd_CODESIGN_FLAGS=-Sent.plist
airmagicd_Frameworks += WebCore ImageIO Foundation CFNetwork AppSupport UIKit IOKit MobileCoreServices BackBoardServices
#airmagicd_PRIVATE_FRAMEWORKS = BackBoardServices
#airmagicd_LIBRARIES += rocketbootstrap
include $(THEOS_MAKE_PATH)/tool.mk

before-package::
	find layout -name ".DS_Store" | xargs rm -r
	rm layout/DEBIAN/postinst
	cp $(POST_INST_FILE) layout/DEBIAN/postinst
	chmod +x layout/DEBIAN/postinst
	rm -rf $(THEOS_STAGING_DIR)/fs
	rm -rf $(THEOS_STAGING_DIR)/Library
	mkdir -p $(THEOS_STAGING_DIR)/$(DAEMON_PATH)
	cp $(LD_COPY) $(THEOS_STAGING_DIR)/$(DAEMON_PATH)/$(LD_FINAL)

after-package::
	echo "AFTER PACKAGE"

after-install::
	#install.exec "killall -9 PineBoard SpringBoard"
	#install.exec "syslog -w"
	
