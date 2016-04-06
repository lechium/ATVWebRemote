#import <Foundation/Foundation.h>
#import "Core/HTTPServer.h"
#import <UIKit/UIKit.h>
#import <IOKit/hid/IOHIDEvent.h>
#import <IOKit/hid/IOHIDEventSystem.h>
#import <IOKit/hid/IOHIDEventSystemClient.h>
#import <IOKit/hidsystem/IOHIDUsageTables.h>

@interface RemoteTestHelper: NSObject
{
    UITextField *_currentTextField;
    IOHIDEventSystemClientRef _ioSystemClient;
}
@property (nonatomic, strong) HTTPServer *httpServer;
@property (copy) NSString *frontMostAppID;
@property (strong) id pbDelegateRef;
@property (strong) UITextField *ctfBackup;

+ (id)sharedInstance;
-(void)hookNotifications:(id)sender;
- (void)stopWatchingNotifications;
- (void)startMonitoringNotifications;
- (void)startItUp;
- (void)enterText:(NSString *)enterText;
- (void)handleRemoteEvent:(NSString *)remoteEvent;
@end

