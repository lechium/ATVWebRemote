TARGET = iphone:8.4
export GO_EASY_ON_ME=1
export SDKVERSION=8.4
THEOS_DEVICE_IP=atvjb.local

include theos/makefiles/common.mk

TWEAK_NAME = remoteTest
remoteTest_FILES = Tweak.xm RemoteTestHelper.mm MyHTTPConnection.m NSObject+AssociatedObjects.m
remoteTest_LDFLAGS = -F/Applications/Xcode721.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS8.4.sdk/System/Library/PrivateFrameworks -undefined dynamic_lookup

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
remoteTest_Frameworks += WebCore ImageIO Foundation CFNetwork AppSupport
remoteTest__PRIVATE_FRAMEWORKS = GraphicsServices IOKit
remoteTest_LIBRARIES += rocketbootstrap
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "/usr/bin/nitoHelper clearRespring 1 2"
	install.exec "syslog -w"
	
