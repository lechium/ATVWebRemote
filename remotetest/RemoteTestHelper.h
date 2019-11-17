#import <Foundation/Foundation.h>
#import "Core/HTTPServer.h"
#import <UIKit/UIKit.h>
#import <IOKit/hid/IOHIDEvent.h>
#import <IOKit/hid/IOHIDEventSystem.h>
#import <IOKit/hid/IOHIDEventSystemClient.h>
#import <IOKit/hidsystem/IOHIDUsageTables.h>
#import <UIKit/UIKit.h>

/**
 
 Main helper method for creating HID events and routing them through the necessary channels.
 
 
 
 */

#define ATV_VINFO NSClassFromString(@"FMSystemInfo")

// System info
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface FMSystemInfo : NSObject
{
}

+ (id)sharedInstance;
- (id)ownerAccount;
- (_Bool)isDeviceSecured;
- (_Bool)isInternalBuild;
- (id)meid;
- (id)imei;
- (id)serialNumber;
- (id)deviceModelName;
- (id)deviceName;
- (id)osBuildVersion;
- (id)osVersion;
- (id)deviceUDID;
- (id)deviceClass;
- (id)productName;
- (id)productType;

@end

@interface RemoteTestHelper: NSObject
{
    UITextField *_currentTextField;
    IOHIDEventSystemClientRef _ioSystemClient;
}
@property (nonatomic, strong) HTTPServer *httpServer;
@property (copy) NSString *frontMostAppID;
@property (strong) id pbDelegateRef;
@property (strong) UITextField *ctfBackup;

- (void)performUserAction;
+ (id)sharedInstance;
-(void)hookNotifications:(id)sender;
- (void)stopWatchingNotifications;
- (void)startMonitoringNotifications;
- (void)startItUp;
- (void)enterText:(NSString *)enterText;
- (void)handleRemoteEvent:(NSString *)remoteEvent;
- (void)sendRebootCommand;
- (void)sendRespringCommand;
- (void)launchKioskApp;
- (void)startScreensaver;
@end

