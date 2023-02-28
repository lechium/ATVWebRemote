TARGET = appletv
#TARGET = iphone:9.0
export GO_EASY_ON_ME=1
export SDKVERSION=10.2
#THEOS_DEVICE_IP=atvjb.local
THEOS_DEVICE_IP=guest-room.local

include theos/makefiles/common.mk

TWEAK_NAME = remoteTest
remoteTest_FILES = Tweak.xm RemoteTestHelper.mm MyHTTPConnection.m NSObject+AssociatedObjects.m
#remoteTest_LDFLAGS = -F/Users/kevinbradley/Downloads/Xcode.app/Contents/Developer/Platforms/AppleTVOS.platform/Developer/SDKs/#AppleTVOS.sdk/System/Library/PrivateFrameworks -undefined dynamic_lookup
remoteTest_LDFLAGS = -undefined dynamic_lookup

remoteTest_CXXFLAGS += -fobjc-arc
remoteTest_CFLAGS += -fobjc-arc
remoteTest_FILES += Core/ContextFilterLogFormatter.m
remoteTest_FILES += Core/DDAbstractDatabaseLogger.m
remoteTest_FILES += Core/DDASLLogger.m
remoteTest_FILES += Core/DDData.m
remoteTest_FILES += Core/DDFileLogger.m
remoteTest_FILES += Core/DDLog.m
remoteTest_FILES += Core/DDNumber.m
remoteTest_FILES += Core/DDRange.m
remoteTest_FILES += Core/DDTTYLogger.m
remoteTest_FILES += Core/DispatchQueueLogFormatter.m
remoteTest_FILES += Core/GCDAsyncSocket.m
remoteTest_FILES += Core/HTTPAsyncFileResponse.m
remoteTest_FILES += Core/HTTPAuthenticationRequest.m
remoteTest_FILES += Core/HTTPConnection.m
remoteTest_FILES += Core/HTTPDataResponse.m
remoteTest_FILES += Core/HTTPDynamicFileResponse.m
remoteTest_FILES += Core/HTTPFileResponse.m
remoteTest_FILES += Core/HTTPMessage.m
remoteTest_FILES += Core/HTTPRedirectResponse.m
remoteTest_FILES += Core/HTTPServer.m
remoteTest_FILES += Core/WebSocket.m
remoteTest_LDFLAGS += -Wl,-segalign,4000
remoteTest_LDFLAGS += -F.
remoteTest_Frameworks += WebCore ImageIO Foundation CFNetwork AppSupport UIKit IOKit MobileCoreServices BackBoardServices
#remoteTest_PRIVATE_FRAMEWORKS = BackBoardServices 
#remoteTest_LIBRARIES += rocketbootstrap
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 PineBoard SpringBoard"
	install.exec "syslog -w"
	
