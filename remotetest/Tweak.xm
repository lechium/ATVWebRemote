#include <mach/mach.h>
#import <mach/mach_time.h>
#import <CoreGraphics/CoreGraphics.h>

#import <IOKit/hid/IOHIDEvent.h>
#import <IOKit/hid/IOHIDEventSystem.h>
#import <IOKit/hid/IOHIDEventSystemClient.h>
#import <IOKit/hidsystem/IOHIDUsageTables.h>
#include <dlfcn.h>

/**
 
 There is a lot of cruft in this file from when i was investigating how to get everything working.
 
 That being said, this is file is where I spin up the main server and hooks into PineBoard and add
 in a bunch of new methods that are all declared and managed in the RemoteTestHelper class.
 
 Long story short, messages are routed through the tweak into PineBoard to send HIDEvents through
 TVSProcessManager, apparently it isnt necessary to route through PineBoard for this, but without
 routing through PineBoard i get some missing symbols errors and havent figured out what frameworks i
 need to link to fix that issue.
 
 so CPDistributedMessagingCenter is used to route messages from MyHTTPConnection.m through methods i've 
 added to PineBoard.
 
 There are likely too many methods added and things could likely be consoldiated into one or two methods,
 or if i find the proper stuff to link to, can take out any routing that isnt 100% necessary.
 
 
 */


//#include "InspCWrapper.m"

int IOHIDEventSystemClientSetMatching(IOHIDEventSystemClientRef client, CFDictionaryRef match);
CFArrayRef IOHIDEventSystemClientCopyServices(IOHIDEventSystemClientRef, int);
typedef struct __IOHIDServiceClient * IOHIDServiceClientRef;
int IOHIDServiceClientSetProperty(IOHIDServiceClientRef, CFStringRef, CFNumberRef);
typedef void* (*clientCreatePointer)(const CFAllocatorRef);
extern "C" void BKSHIDServicesCancelTouchesOnMainDisplay();
//typedef void* (*vibratePointer)(SystemSoundID inSystemSoundID, id arg, NSDictionary *vibratePattern);


struct rawTouch {
    float density;
    float radius;
    float quality;
    float x;
    float y;
} lastTouch;

NSUserDefaults *defaults;


%hook AXBackBoardServer

- (void)postEvent:(id)arg1 systemEvent:(_Bool)arg2
{
	%log;
	%orig;
}
- (void)postEvent:(id)arg1 afterNamedTap:(id)arg2 includeTaps:(id)arg3
{
	%log;
	%orig;
}

%end
*/

#import "RemoteTestHelper.h"
#import "AppSupport/CPDistributedMessagingCenter.h"
#import <objc/runtime.h>
#import "rocketbootstrap.h"
#import "NSObject+AssociatedObjects.h"

%hook UIScreen

+ (_Bool)_shouldDisableJail
{
    %log;
    return true;
}

%end
/*

%hook PBApplication

- (void)tvs_bindFocusedProcessBindingToObject:(id)arg1 withKeyPath:(id)arg2 options:(id)arg3
{
    %log;
    %orig;
}

- (id)FocusedProcessBinding
 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }

%end

*/
%hook PBAppDelegate



- (id)init
{
    %log;
     Class pbad = NSClassFromString(@"PBAppDelegate");
    Class rth = NSClassFromString(@"RemoteTestHelper");
    RemoteTestHelper *rmh = [RemoteTestHelper sharedInstance];
    //[rmh setPbDelegateRef:self];
    
    id center = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"org.nito.test"];
    rocketbootstrap_distributedmessagingcenter_apply(center);
    [center runServerOnCurrentThread];
    
    Method ourMessageHandler = class_getInstanceMethod(rth, @selector(handleMessageName:userInfo:));
    Method setTextHandler = class_getInstanceMethod(rth, @selector(handleTextName:userInfo:));
    Method delayedRelease = class_getInstanceMethod(rth, @selector(delayedRelease:));
    Method ioTest = class_getInstanceMethod(rth, @selector(IOHIDTest:));
    Method helperCommand = class_getInstanceMethod(rth, @selector(helperCommand:withInfo:));
  //  Method details = class_getInstanceMethod(rth, @selector(systemDetails));
    
     class_addMethod(pbad, @selector(handleMessageName:userInfo:), method_getImplementation(ourMessageHandler), method_getTypeEncoding(ourMessageHandler));
    
    class_addMethod(pbad, @selector(handleMessageName:userInfo:), method_getImplementation(ourMessageHandler), method_getTypeEncoding(ourMessageHandler));
    class_addMethod(pbad, @selector(handleTextName:userInfo:), method_getImplementation(setTextHandler), method_getTypeEncoding(setTextHandler));

    class_addMethod(pbad, @selector(IOHIDTest:), method_getImplementation(ioTest), method_getTypeEncoding(ioTest));
    
    class_addMethod(pbad, @selector(delayedRelease:), method_getImplementation(delayedRelease), method_getTypeEncoding(delayedRelease));
    
    class_addMethod(pbad, @selector(helperCommand:withInfo:), method_getImplementation(helperCommand), method_getTypeEncoding(helperCommand));
    
    [center registerForMessageName:@"org.nito.test.doThings" target:self selector:@selector(handleMessageName:userInfo:)];
    [center registerForMessageName:@"org.nito.test.setText" target:self selector:@selector(handleTextName:userInfo:)];
    [center registerForMessageName:@"org.nito.test.helperCommand" target:self selector:@selector(helperCommand:withInfo:)];

    //id app = [objc_getClass("PBApplication") sharedApplication];
    
    //  watchObject(app);
    return %orig;
}

- (_Bool)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2
{
	%log;
    RemoteTestHelper *rmh = [RemoteTestHelper sharedInstance];
    [rmh startItUp];
	return %orig;
}



%end
/*
%hook UIEvent

- (void)_sendEventToResponder:(id)arg1
{
	%log;
	%orig;
}
- (id)_windows
{
	%log;
	return %orig;
}
- (id)_screen {
	%log;
	return %orig;
}
- (void)_setTimestamp:(double)arg1
{
	%log;
	%orig;
}
- (id)_init
{
	%log;
	return %orig;
}
- (id)predictedTouchesForTouch:(id)arg1
{
	%log;
	return %orig;
}
- (id)coalescedTouchesForTouch:(id)arg1
{
	%log;
	return %orig;
}
- (id)touchesForGestureRecognizer:(id)arg1
{
	%log;
	return %orig;
}
- (id)touchesForView:(id)arg1
{
	%log;
	return %orig;
}

- (id)touchesForWindow:(id)arg1
{
	%log;
	return %orig;
}
- (id)allTouches
{
	%log;
	return %orig;
}
- (long long)_modifierFlags
{
	%log;
	return %orig;
}
- (id)_unmodifiedInput
{
	%log;
	return %orig;
}
- (id)_modifiedInput
{
	%log;
	return %orig;
}
- (id)_triggeringPhysicalButton
{
	%log;
	return %orig;
}
- (id)_physicalButtonsForGestureRecognizer:(id)arg1
{
	%log;
	return %orig;
}

- (void)_setHIDEvent:(struct __IOHIDEvent *)arg1
{
	%log;
	%orig;
}

- (id)_physicalButtonsForResponder:(id)arg1
{
	%log;
	return %orig;
}
- (id)_allPhysicalButtons
{
	%log;
	return %orig;
}
- (void)_setGSEvent:(struct __GSEvent *)arg1
{
	%log;
	%orig;
}
- (id)_initWithEvent:(struct __GSEvent *)arg1 touches:(id)arg2
{
	%log;
	return %orig;
}
%end

%hook ATVHIDSystemClient

- (_Bool)setProperty:(id)arg1 forKey:(id)arg2 error:(id *)arg3
{
	%log;
	return %orig;
}
- (void)_processAppleVendorDebugEvent:(struct __IOHIDEvent *)arg1
{
	%log;
	%orig;
}
- (void)_processAppleVendorIRRemoteEvent:(struct __IOHIDEvent *)arg1
{
	%log;
	%orig;
}

- (void)_processHIDEvent:(struct __IOHIDEvent *)arg1
{
	%log;
	%orig;
}

%end

%hook BKSHIDEventDescriptor
+ (id)reusableKeyboardDescriptorWithPage:(unsigned int)arg1 usage:(unsigned int)arg2 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
+ (id)reusableVendorDefinedDescriptorWithPage:(unsigned int)arg1 usage:(unsigned int)arg2 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
+ (id)reusableDescriptorWithEventType:(unsigned int)arg1 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
+ (_Bool)supportsSecureCoding { %log; _Bool r = %orig; HBLogDebug(@" = %d", r); return r; }
+ (id)descriptorWithEventType:(unsigned int)arg1 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (unsigned int )hidEventType { %log; unsigned int  r = %orig; HBLogDebug(@" = %u", r); return r; }
- (id)initWithCoder:(id)arg1 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (void)encodeWithCoder:(id)arg1 { %log; %orig; }
- (_Bool)describes:(id)arg1 { %log; _Bool r = %orig; HBLogDebug(@" = %d", r); return r; }
- (id)description { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (unsigned long long)hash { %log; unsigned long long r = %orig; HBLogDebug(@" = %llu", r); return r; }
- (_Bool)isEqual:(id)arg1 { %log; _Bool r = %orig; HBLogDebug(@" = %d", r); return r; }
- (id)initWithEventType:(unsigned int)arg1 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
%end
/*
%hook BKSHIDEventRouter
+ (_Bool)supportsSecureCoding { %log; _Bool r = %orig; HBLogDebug(@" = %d", r); return r; }
+ (id)defaultFocusedAppEventRouter { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
+ (id)defaultSystemAppEventRouter { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
+ (id)defaultEventRouters { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
+ (id)routerWithDestination:(long long)arg1 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (NSSet *)hidEventDescriptors { %log; NSSet * r = %orig; HBLogDebug(@" = %@", r); return r; }
- (long long )destination { %log; long long  r = %orig; HBLogDebug(@" = %lld", r); return r; }
- (id)initWithCoder:(id)arg1 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (void)encodeWithCoder:(id)arg1 { %log; %orig; }
- (id)stringForDestination:(long long)arg1 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)dumpContents { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)description { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (unsigned long long)hash { %log; unsigned long long r = %orig; HBLogDebug(@" = %llu", r); return r; }
- (_Bool)isEqual:(id)arg1 { %log; _Bool r = %orig; HBLogDebug(@" = %d", r); return r; }
- (_Bool)containsDescriptor:(id)arg1 { %log; _Bool r = %orig; HBLogDebug(@" = %d", r); return r; }
- (_Bool)specifiesDescriptor:(id)arg1 { %log; _Bool r = %orig; HBLogDebug(@" = %d", r); return r; }
- (void)removeHIDEventDescriptors:(id)arg1 { %log; %orig; }
- (void)addHIDEventDescriptors:(id)arg1 { %log; %orig; }
- (void)dealloc { %log; %orig; }
- (id)initWithDestination:(long long)arg1 hidEventDescriptors:(id)arg2 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)initWithDestination:(long long)arg1 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
%end
%hook BKSHIDEventRouterManager
+ (id)sharedInstance { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (void)setNeedsFlush:(_Bool )needsFlush { %log; %orig; }
- (_Bool )needsFlush { %log; _Bool  r = %orig; HBLogDebug(@" = %d", r); return r; }
- (void)_routerUpdated:(id)arg1 { %log; %orig; }
- (void)_flush { %log; %orig; }
- (void)_flushTrigger { %log; %orig; }
- (void)setEventRouters:(id)arg1 { %log; %orig; }
- (void)dealloc { %log; %orig; }
- (id)init { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
%end
*/
/*
%hook UIApplication

- (_Bool)handleEvent:(struct __GSEvent *)arg1 withNewEvent:(id)arg2 { %log; _Bool r = %orig; HBLogDebug(@" = %d", r); return r; }
- (_Bool)handleEvent:(struct __GSEvent *)arg1 { %log; _Bool r = %orig; HBLogDebug(@" = %d", r); return r; }
- (_Bool)_handlePhysicalButtonEvent:(id)arg1 { %log; _Bool r = %orig; HBLogDebug(@" = %d", r); return r; }
- (void)_handleHIDEvent:(struct __IOHIDEvent *)arg1 { %log; %orig; }
- (void)_enqueueHIDEvent:(struct __IOHIDEvent *)arg1 { %log; %orig; }
- (void)handleKeyUIEvent:(id)arg1 { %log; %orig; }
- (void)handleKeyHIDEvent:(struct __IOHIDEvent *)arg1 { %log; %orig; }
- (void)_sendRemoteControlEvent:(long long)arg1 { %log; %orig;}
- (id)_remoteControlEvent { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
%end

%hook UIPressesEvent
- (void)_setIsFromGameControllerStickControl:(_Bool )_isFromGameControllerStickControl { %log; %orig; }
- (_Bool )_isFromGameControllerStickControl { %log; _Bool  r = %orig; HBLogDebug(@" = %d", r); return r; }
- (void)set_triggeringPhysicalButton:(UIPress *)_triggeringPhysicalButton { %log; %orig; }
- (UIPress *)_triggeringPhysicalButton { %log; UIPress * r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)description { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)_directionalPressWithStrongestForce { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (void)_removePhysicalButton:(id)arg1 { %log; %orig; }
- (void)_addGesturesForPress:(id)arg1 { %log; %orig; }
- (void)_addPress:(id)arg1 forDelayedDelivery:(_Bool)arg2 { %log; %orig; }
- (id)_gestureRecognizersForWindow:(id)arg1 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)_physicalButtonsForGestureRecognizer:(id)arg1 withPhase:(long long)arg2 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)_physicalButtonsForGestureRecognizer:(id)arg1 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)_physicalButtonsForResponder:(id)arg1 withPhase:(long long)arg2 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)_physicalButtonsForResponder:(id)arg1 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)_respondersForWindow:(id)arg1 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)physicalButtonsForWindow:(id)arg1 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)_allPresses { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)_windows { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)_allPhysicalButtons { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)pressesForGestureRecognizer:(id)arg1 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)allPresses { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)_cloneEvent { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (long long)subtype { %log; long long r = %orig; HBLogDebug(@" = %lld", r); return r; }
- (long long)type { %log; long long r = %orig; HBLogDebug(@" = %lld", r); return r; }
- (id)_init { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }

%end
*/

/*
 
 #### touch event usagePage: 12 usage: 69 = right
 #### touch event usagePage: 12 usage: 68 = left
 #### touch event usagePage: 12 usage: 67 = down
 #### touch event usagePage: 12 usage: 66 = up
 #### touch event usagePage: 12 usage: 65 = (center button / select)
 #### touch event usagePage: 12 usage: 205 = play/pause
 #### touch event usagePage: 1 usage: 134 = menu
 
 
 uint64_t abTime = mach_absolute_time();
 AbsoluteTime timeStamp;
 timeStamp.hi = (UInt32)(abTime >> 32);
 timeStamp.lo = (UInt32)(abTime);
 
 */

void touch_event(void* target, void* refcon, IOHIDServiceRef service, IOHIDEventRef event) {
    
    //NSLog(@"###### TOUCH EVENT: %lu", IOHIDEventGetType(event));
    int usagePage = IOHIDEventGetIntegerValue(event, kIOHIDEventFieldKeyboardUsagePage);
    int usage = IOHIDEventGetIntegerValue(event, kIOHIDEventFieldKeyboardUsage);
    int down = IOHIDEventGetIntegerValue(event, kIOHIDEventFieldKeyboardDown);
    NSLog(@"#### touch event usagePage: %i usage: %i down: %i", usagePage, usage, down);
    
}


static __attribute__((constructor)) void myHooksInit() {
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	%init;
	
	RemoteTestHelper *rmh = [RemoteTestHelper sharedInstance];
	[rmh startMonitoringNotifications];
    //[rmh startItUp];

    /*
    NSLog(@"rmh: %@", rmh);
    clientCreatePointer clientCreate;
    void *handle = dlopen(0, 9);
    *(void**)(&clientCreate) = dlsym(handle,"IOHIDEventSystemClientCreate");
    IOHIDEventSystemClientRef ioHIDEventSystem = (__IOHIDEventSystemClient *)clientCreate(kCFAllocatorDefault);
    IOHIDEventSystemClientScheduleWithRunLoop(ioHIDEventSystem, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    IOHIDEventSystemClientRegisterEventCallback(ioHIDEventSystem, (IOHIDEventSystemClientEventCallback)touch_event, NULL, NULL);
    ;
    fprintf(stdout, "\n\n### PRINTF TO STD OUT\n");
    fprintf(stderr, "\n\n### PRINTF TO STD ERR\n");
     */
  	//setMaximumRelativeLoggingDepth(5);
	//watchClass([SSDownloadMetadata class]);
	//watchClass(NSClassFromString(@"SSDownload"));
	//watchClass(NSClassFromString(@"JOiTunesImportHelper"));
//	[pool drain];	
}

%hook PBAppSwitcherManager
- (id)addItemWithIdentifier:(id)arg1

 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }

%end

%hook PBCoreControlManager
- (void)coreControlManagerDidRequestAlternateRouteVolumeDecrease:(id)arg1
{
    %log;
    %orig;
}

- (void)coreControlManagerDidRequestAlternateRouteVolumeIncrease:(id)arg1
{
    %log;
    %orig;
}

- (void)coreControlManagerDidUpdatePolicy:(id)arg1
{
    %log;
    %orig;
}

- (void)coreControlManager:(id)arg1 didReceiveRequest:(long long)arg2
{
    %log;
    %orig;
}

%end

%hook FBSystemService
- (void)exitAndRelaunch:(_Bool)arg1 withOptions:(unsigned long long)arg2
{
    %log;
    %orig;
}

- (void)terminateApplicationGroup:(long long)arg1 forReason:(long long)arg2 andReport:(_Bool)arg3 withDescription:(id)arg4 source:(id)arg5
{
    %log;
    %orig;
}
- (void)terminateApplication:(id)arg1 forReason:(long long)arg2 andReport:(_Bool)arg3 withDescription:(id)arg4 source:(id)arg5
{
    %log;
    %orig;
}
- (void)_terminateProcess:(id)arg1 forReason:(long long)arg2 andReport:(_Bool)arg3 withDescription:(id)arg4
{
    %log;
    %orig;
}

- (void)setPendingExit:(_Bool)arg1
{
    %log;
    %orig;
}
- (id)systemApplicationBundleIdentifier
{
    %log;
    return %orig;
}
- (void)prepareForExitAndRelaunch:(_Bool)arg1{
    %log;
    %orig;
}
- (void)exitAndRelaunch:(_Bool)arg1
{
    %log;
    %orig;
}

- (_Bool)_isWhitelistedLaunchSuspendedApp:(id)arg1
{
    %log;
    return %orig;
}
- (_Bool)_requiresOpenApplicationEntitlement:(id)arg1 options:(id)arg2 originalSource:(id)arg3
{
    %log;
    return %orig;
}
- (void)_performExitTasksForRelaunch:(_Bool)arg1
{
    %log;
    %orig;
}

- (void)_reallyActivateApplication:(id)arg1 options:(id)arg2 source:(id)arg3 originalSource:(id)arg4 sequenceNumber:(unsigned long long)arg5 cacheGUID:(id)arg6 ourSequenceNumber:(unsigned long long)arg7 ourCacheGUID:(id)arg8 withResult:(id)arg9
{
    %log;
    %orig;
}
- (_Bool)_shouldPendRequestForClientSequenceNumber:(unsigned long long)arg1 clientCacheGUID:(id)arg2 ourSequenceNumber:(unsigned long long)arg3 ourCacheGUID:(id)arg4
{
    %log;
    return %orig;
}
- (void)_logPendedActivationRequestForMismatchedClientSequenceNumber:(unsigned long long)arg1 clientCacheGUID:(id)arg2 ourSequenceNumber:(unsigned long long)arg3 ourCacheGUID:(id)arg4
{
    %log;
    %orig;
}
- (void)_activateApplication:(id)arg1 options:(id)arg2 source:(id)arg3 originalSource:(id)arg4 withResult:(id)arg5
{
    %log;
    %orig;
}
- (void)activateApplication:(id)arg1 options:(id)arg2 source:(id)arg3 originalSource:(id)arg4 withResult:(id)arg5
{
    %log;
    %orig;
}
- (void)canActivateApplication:(id)arg1 source:(id)arg2 withResult:(id)arg3
{
    %log;
    %orig;
}

%end

%hook TVSProcessManager

- (void)_openApp:(id)arg1 options:(id)arg2 origin:(id)arg3 withResult:(id)arg4 {
    %log;
    %orig;
}
- (void)killApplication:(id)arg1 removeFromRecents:(_Bool)arg2
{
    %log;
    %orig;
}
- (void)activateApplication:(id)arg1 openURL:(id)arg2 options:(id)arg3 suspended:(_Bool)arg4 completion:(id)arg5 {
    %log;
    %orig;
}
- (void)activateApplication:(id)arg1 openURL:(id)arg2 suspended:(_Bool)arg3 completion:(id)arg4
{
    %log;
    %orig;
}
%end

@interface TVSCoreControlManager : NSObject

- (id)delegate;

@end

%hook TVSCoreControlManager

- (void)_setVolumeIRCommandsAllowed:(_Bool)arg1
{
 
    NSLog(@"delegate: %@", [self delegate]);
    %log;
    %orig;
}

- (void)_decreaseRouteVolume
{
    %log;
    %orig;
}

- (void)_increaseRouteVolume
{
    %log;
    %orig;
}

- (void)_sendVolumeAction:(long long)arg1
{
    %log;
    %orig;
}

%end
/*
%hook UIKeyboardInputManagerClient
+ (_Bool)instancesRespondToSelector:(SEL)arg1 { %log; _Bool r = %orig; HBLogDebug(@" = %d", r); return r; }
- (void)setConnection:(NSXPCConnection *)connection { %log; %orig; }
- (NSXPCConnection *)connection { %log; NSXPCConnection * r = %orig; HBLogDebug(@" = %@", r); return r; }
- (void)handleError:(id)arg1 forRequest:(id)arg2 { %log; %orig; }
- (void)handleRequest:(id)arg1 { %log; %orig; }
- (void)forwardInvocation:(id)arg1 { %log; %orig; }
- (id)methodSignatureForSelector:(SEL)arg1 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (_Bool)conformsToProtocol:(id)arg1 { %log; _Bool r = %orig; HBLogDebug(@" = %d", r); return r; }
- (_Bool)isKindOfClass:(Class)arg1 { %log; _Bool r = %orig; HBLogDebug(@" = %d", r); return r; }
- (_Bool)respondsToSelector:(SEL)arg1 { %log; _Bool r = %orig; HBLogDebug(@" = %d", r); return r; }
- (id)init { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (void)dealloc { %log; %orig; }
%end
%hook UIKeyboardInputManagerClientRequest
+ (id)untargetedInvocationWithInvocation:(id)arg1 withCompletion:(_Bool)arg2 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (void)setErrorCount:(unsigned long long )errorCount { %log; %orig; }
- (unsigned long long )errorCount { %log; unsigned long long  r = %orig; HBLogDebug(@" = %llu", r); return r; }
- (NSInvocation *)invocation { %log; NSInvocation * r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)initWithInvocation:(id)arg1 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (void)dealloc { %log; %orig; }
%end
%hook UIKeyCommand
+ (id)keyCommandWithInput:(id)arg1 modifierFlags:(long long)arg2 segueIdentifier:(id)arg3 discoverabilityTitle:(id)arg4 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
+ (id)keyCommandWithInput:(id)arg1 modifierFlags:(long long)arg2 segueIdentifier:(id)arg3 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
+ (id)keyCommandWithInput:(id)arg1 modifierFlags:(long long)arg2 buttonType:(long long)arg3 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
+ (id)keyCommandWithKeyCodes:(id)arg1 modifierFlags:(long long)arg2 buttonType:(long long)arg3 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
+ (id)keyCommandWithKeyCodes:(id)arg1 modifierFlags:(long long)arg2 action:(SEL)arg3 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
+ (id)keyCommandWithCompactInput:(id)arg1 action:(SEL)arg2 upAction:(SEL)arg3 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
+ (id)keyCommandWithInput:(id)arg1 modifierFlags:(long long)arg2 action:(SEL)arg3 upAction:(SEL)arg4 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
+ (id)keyCommandWithInput:(id)arg1 modifierFlags:(long long)arg2 action:(SEL)arg3 discoverabilityTitle:(id)arg4 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
+ (id)keyCommandWithInput:(id)arg1 modifierFlags:(long long)arg2 action:(SEL)arg3 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
+ (_Bool)supportsSecureCoding { %log; _Bool r = %orig; HBLogDebug(@" = %d", r); return r; }
- (void)setDiscoverabilityTitle:(NSString *)discoverabilityTitle { %log; %orig; }
- (NSString *)discoverabilityTitle { %log; NSString * r = %orig; HBLogDebug(@" = %@", r); return r; }
- (long long )modifierFlags { %log; long long  r = %orig; HBLogDebug(@" = %lld", r); return r; }
- (NSString *)input { %log; NSString * r = %orig; HBLogDebug(@" = %@", r); return r; }
- (void)_setViewControllerForSegue:(id)arg1 { %log; %orig; }
- (id)_controllerForSegue { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)_segueIdentifier { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (void)_setOriginatingResponder:(id)arg1 { %log; %orig; }
- (id)nextResponder { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (void)_setTriggeringEvent:(id)arg1 { %log; %orig; }
- (id)_triggeringEvent { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (void)_setButtonType:(long long)arg1 { %log; %orig; }
- (long long)_buttonType { %log; long long r = %orig; HBLogDebug(@" = %lld", r); return r; }
- (id)_keyCodes { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (_Bool)repeatable { %log; _Bool r = %orig; HBLogDebug(@" = %d", r); return r; }
- (SEL)upAction { %log; SEL r = %orig; HBLogDebug(@" = %@", NSStringFromSelector(r)); return r; }
- (void)setAction:(SEL)arg1 { %log; %orig; }
- (SEL)action { %log; SEL r = %orig; HBLogDebug(@" = %@", NSStringFromSelector(r)); return r; }
- (id)_nonRepeatableKeyCommand { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (_Bool)triggerSegueIfPossible { %log; _Bool r = %orig; HBLogDebug(@" = %d", r); return r; }
- (unsigned long long)hash { %log; unsigned long long r = %orig; HBLogDebug(@" = %llu", r); return r; }
- (_Bool)isEqual:(id)arg1 { %log; _Bool r = %orig; HBLogDebug(@" = %d", r); return r; }
- (id)copyWithZone:(struct _NSZone *)arg1 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)_initWithInput:(id)arg1 modifierFlags:(long long)arg2 keyCodes:(id)arg3 action:(SEL)arg4 upAction:(SEL)arg5 discoverabilityTitle:(id)arg6 buttonType:(long long)arg7 segueIdentifier:(id)arg8 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)initWithKeyCommand:(id)arg1 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)initWithCoder:(id)arg1 { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (id)init { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
- (void)encodeWithCoder:(id)arg1 { %log; %orig; }
%end
 
*/


