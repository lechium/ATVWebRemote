#import "RemoteTestHelper.h"
#import "Core/HTTPServer.h"
#import "MyHTTPConnection.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import <objc/runtime.h>
#import "NSObject+AssociatedObjects.h"
#import "rocketbootstrap.h"
#import "AppSupport/CPDistributedMessagingCenter.h"
#include <mach/mach.h>
#import <mach/mach_time.h>
#import <CoreGraphics/CoreGraphics.h>
#include "InspCWrapper.m"
#import "NSTask.h"
#include <IOKit/pwr_mgt/IOPMLib.h>

#define DEFAULT_PORT 3073

IOHIDEventSystemClientRef IOHIDEventSystemClientCreate(CFAllocatorRef);

extern "C" int BKSHIDEventSendToFocusedProcess(struct __IOHIDEvent *);

@interface PBSSystemService: NSObject

+(id)sharedInstance;
-(void)relaunchBackboardd;
-(void)relaunch;
-(void)reboot;
-(void)activateScreenSaver;
-(void)deactivateScreenSaver;
-(void)launchKioskApp;

@end

@interface PBApplication: NSObject //for now, should be fine

- (void)forwardHIDButtonEventWithUsagePage:(unsigned int)arg1 usage:(unsigned int)arg2 type:(unsigned long long)arg3 senderID:(unsigned long long)arg4;
+ (id)_newApplicationLibrary;    // IMP=0x000000010000b3d0
+ (id)sharedApplicationLibrary;    // IMP=0x000000010000b39c
+ (id)sharedApplication;
- (id)FocusedProcessBinding;
+ (id)sharedApplication;
- (id)appSwitcherWindow;
- (void)sendEvent:(struct __IOHIDEvent *)theEvent;
@end

@interface NSDistributedNotificationCenter : NSNotificationCenter

+ (id)defaultCenter;

- (void)addObserver:(id)arg1 selector:(SEL)arg2 name:(id)arg3 object:(id)arg4;
- (void)postNotificationName:(id)arg1 object:(id)arg2 userInfo:(id)arg3;

@end

@interface PBSMutableAppState : NSObject
-(void)setEnabled:(BOOL)arg1 ;
-(id)initWithApplicationIdentifer:(id)arg1 ;
@end

@interface LSApplicationWorkspace : NSObject
+ (id) defaultWorkspace;
- (void)_LSClearSchemaCaches;
- (_Bool)_LSPrivateRebuildApplicationDatabasesForSystemApps:(_Bool)arg1 internal:(_Bool)arg2 user:(_Bool)arg3;

- (BOOL) _LSPrivateSyncWithMobileInstallation;
-(BOOL)registerApplicationDictionary:(id)arg1 withObserverNotification:(int)arg2;
@end

@interface PBAppDepot : NSObject
+ (id)sharedInstance;
@property(retain, nonatomic) NSMutableDictionary *internalAppState;
- (id)_addAppStateForIdentifier:(id)arg1;
- (void)_save;
- (void)_setNeedsNotifyAppStateDidChange;
@end

@interface UIDevice (science)

- (NSString *)buildVersion;

@end

@interface NSString (SplitString)

- (NSArray *)splitString;

@end

/*
 use split string to split up characters into component array
 each character needs to be converted to HID event and then sent individually
 */

@implementation NSString (SplitString)

- (NSArray *)splitString
{
    NSUInteger index = 0;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.length];
    
    while (index < self.length) {
        NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:index];
        NSString *substring = [self substringWithRange:range];
        [array addObject:substring];
        index = range.location + range.length;
    }
    
    return array;
}


@end

@interface ATVHIDSystemClient : NSObject
+ (id)sharedInstance;
- (void)_processHIDEvent:(struct __IOHIDEvent *)arg1;

@end


@interface TVSProcessManager : NSObject
+ (id)sharedInstance;
- (id)_foregroundScene;
- (void)sendHIDEventToTopApplication:(struct __IOHIDEvent *)arg1;
- (void)_openApp:(id)arg1 options:(id)arg2 origin:(id)arg3 withResult:(id)arg4;
- (void)reboot;	// IMP=0x0000000100093144
- (void)relaunch;	// IMP=0x0000000100093128
- (void)killApplication:(id)arg1 removeFromRecents:(_Bool)arg2;	// IMP=0x0000000100092fe4
- (void)activateApplication:(id)arg1 openURL:(id)arg2 options:(id)arg3 suspended:(_Bool)arg4 completion:(id)arg5;	// IMP=0x0000000100092c18
- (void)activateApplication:(id)arg1 openURL:(id)arg2 suspended:(_Bool)arg3 completion:(id)arg4;
@end

@interface UIApplication (Private)

- (void)_enqueueHIDEvent:(struct __IOHIDEvent *)arg1;

@end;

@interface UIWindow (Private)

+ (id)_externalKeyWindow;
+ (id)keyWindow;
+ (id)allWindowsIncludingInternalWindows:(_Bool)arg1 onlyVisibleWindows:(_Bool)arg2 forScreen:(id)arg3;
@end

@interface FBProcessManager : NSObject

+ (id)sharedInstance;

@end

@interface FBApplicationLibrary : NSObject

+ (id)sharedInstance;
- (id)installedApplicationWithBundleIdentifier:(id)arg1;
- (id)allInstalledApplications;

@end

@interface PBWindowManager: NSObject

+ (id)sharedInstance;	// IMP=0x0000000100021de8
+ (id)_highestPriorityWindow;
@end

@interface PBBundleLoader : NSObject


+ (id)sharedInstance;	// IMP=0x000000010001e738
- (id)pluginControllerForBundleIdentifier:(id)arg1;	// IMP=0x000000010001f04c

@end

@interface PBAppTransitionViewController
@property(retain, nonatomic) UIView *toView;

@end

static char const * const kCurrentTextFieldID = "CurrentTextField";

@interface PBAppDelegate

+ (id)sharedApplicationDelegate;

@end



//use this method to figure out which characters are being sent for text entry in HIDEvents

static inline uint32_t hidUsageCodeForCharacter(NSString *key)
{
    const int uppercaseAlphabeticOffset = 'A' - kHIDUsage_KeyboardA;
    const int lowercaseAlphabeticOffset = 'a' - kHIDUsage_KeyboardA;
    const int numericNonZeroOffset = '1' - kHIDUsage_Keyboard1;
    if (key.length == 1) {
        // Handle alphanumeric characters and basic symbols.
        int keyCode = [key characterAtIndex:0];
        
        //NSLog(@"keyCode: %i", keyCode);
        
        if (97 <= keyCode && keyCode <= 122) // Handle a-z.
            return keyCode - lowercaseAlphabeticOffset;
        
        if (65 <= keyCode && keyCode <= 90) // Handle A-Z.
            return keyCode - uppercaseAlphabeticOffset;
        
        if (49 <= keyCode && keyCode <= 57) // Handle 1-9.
            return keyCode - numericNonZeroOffset;
        
        // Handle all other cases.
        switch (keyCode) {
            case '`':
            case '~':
                return kHIDUsage_KeyboardGraveAccentAndTilde;
            case '!':
                return kHIDUsage_Keyboard1;
            case '@':
                return kHIDUsage_Keyboard2;
            case '#':
                return kHIDUsage_Keyboard3;
            case '$':
                return kHIDUsage_Keyboard4;
            case '%':
                return kHIDUsage_Keyboard5;
            case '^':
                return kHIDUsage_Keyboard6;
            case '&':
                return kHIDUsage_Keyboard7;
            case '*':
                return kHIDUsage_Keyboard8;
            case '(':
                return kHIDUsage_Keyboard9;
            case ')':
            case '0':
                return kHIDUsage_Keyboard0;
            case '-':
            case '_':
                return kHIDUsage_KeyboardHyphen;
            case '=':
            case '+':
                return kHIDUsage_KeyboardEqualSign;
            case '\t':
                return kHIDUsage_KeyboardTab;
            case '[':
            case '{':
                return kHIDUsage_KeyboardOpenBracket;
            case ']':
            case '}':
                return kHIDUsage_KeyboardCloseBracket;
            case '\\':
            case '|':
                return kHIDUsage_KeyboardBackslash;
            case ';':
            case ':':
                return kHIDUsage_KeyboardSemicolon;
            case '\'':
            case '"':
                return kHIDUsage_KeyboardQuote;
            case '\r':
            case '\n':
                return kHIDUsage_KeyboardReturnOrEnter;
            case ',':
            case '<':
                return kHIDUsage_KeyboardComma;
            case '.':
            case '>':
                return kHIDUsage_KeyboardPeriod;
            case '/':
            case '?':
                return kHIDUsage_KeyboardSlash;
            case ' ':
                return kHIDUsage_KeyboardSpacebar;
        }
    }
    const int functionKeyOffset = kHIDUsage_KeyboardF1;
    for (int functionKeyIndex = 1; functionKeyIndex <= 12; ++functionKeyIndex) {
        if ([key isEqualToString:[NSString stringWithFormat:@"F%d", functionKeyIndex]])
            return functionKeyOffset + functionKeyIndex - 1;
    }
    if ([key isEqualToString:@"escape"])
        return kHIDUsage_KeyboardEscape;
    if ([key isEqualToString:@"return"] || [key isEqualToString:@"enter"])
        return kHIDUsage_KeyboardReturnOrEnter;
    if ([key isEqualToString:@"leftArrow"])
        return kHIDUsage_KeyboardLeftArrow;
    if ([key isEqualToString:@"rightArrow"])
        return kHIDUsage_KeyboardRightArrow;
    if ([key isEqualToString:@"upArrow"])
        return kHIDUsage_KeyboardUpArrow;
    if ([key isEqualToString:@"downArrow"])
        return kHIDUsage_KeyboardDownArrow;
    if ([key isEqualToString:@"delete"])
        return kHIDUsage_KeyboardDeleteOrBackspace;
    // The simulator keyboard interprets both left and right modifier keys using the left version of the usage code.
    if ([key isEqualToString:@"leftControl"] || [key isEqualToString:@"rightControl"])
        return kHIDUsage_KeyboardLeftControl;
    if ([key isEqualToString:@"leftShift"] || [key isEqualToString:@"rightShift"])
        return kHIDUsage_KeyboardLeftShift;
    if ([key isEqualToString:@"leftAlt"] || [key isEqualToString:@"rightAlt"])
        return kHIDUsage_KeyboardLeftAlt;
    
    return 0;
}

@implementation RemoteTestHelper

@synthesize httpServer, frontMostAppID, pbDelegateRef, ctfBackup;


/*
 
 #### touch event usagePage: 12 usage: 69 = right
 #### touch event usagePage: 12 usage: 68 = left
 #### touch event usagePage: 12 usage: 67 = down
 #### touch event usagePage: 12 usage: 66 = up
 #### touch event usagePage: 12 usage: 65 = (center button / select)
 #### touch event usagePage: 12 usage: 205 = play/pause
 #### touch event usagePage: 1 usage: 134 = menu
 
 */

/* all the navigation events go through here, when this method is called its inside PineBoard.app and not the tweak itself.
 */

- (void)performUserAction {
    
    //NSLog(@"[AirMagic] performUserAction");
    IOPMAssertionID assertionID;
    IOPMAssertionDeclareUserActivity(CFSTR(""), kIOPMUserActiveLocal, &assertionID);
    
}

- (void)handleNavigationNotification:(NSNotification *)note {
    
    NSDictionary *userInfo = [note userInfo];
    
    if (userInfo != nil)
    {
        
        [[RemoteTestHelper sharedInstance] performUserAction];
        
        BOOL holdTouch = false;
        NSString *event = userInfo[@"event"];
        if (!_ioSystemClient)
            _ioSystemClient = IOHIDEventSystemClientCreate(kCFAllocatorDefault);
        
        //id pbApp = [ objc_getClass("PBApplication") sharedApplication];
        
        NSInteger sender = 4294968875; //no idea what this is but it works?
        
        uint64_t abTime = mach_absolute_time();
        AbsoluteTime timeStamp;
        timeStamp.hi = (UInt32)(abTime >> 32);
        timeStamp.lo = (UInt32)(abTime);
        
        uint16_t usage = 0;
        uint16_t usagePage = 12;
        if ([event isEqualToString:@"right"]) usage = 69;
        else if ([event isEqualToString:@"left"]) usage = 68;
        else if ([event isEqualToString:@"down"]) usage = 67;
        else if ([event isEqualToString:@"up"]) usage = 66;
        else if ([event isEqualToString:@"tap"]) usage = 65;
        else if ([event isEqualToString:@"home"]) { usage = 134; holdTouch = true; usagePage = 1; }
        //else if ([event isEqualToString:@"home"]) { usage = 96; holdTouch = true; }
        else if ([event isEqualToString:@"vlup"]) { usage = 233; holdTouch = true; }
        else if ([event isEqualToString:@"vldwn"]){ usage = 234; holdTouch = true; }
        else if ([event isEqualToString:@"siri"]) usage = 4;
        else if ([event isEqualToString:@"play"]) usage = 205;
        else if ([event isEqualToString:@"select"]) usage = 128;
        else if ([event isEqualToString:@"selecth"]){ usage = 128; holdTouch = true; }
        else if ([event isEqualToString:@"menu"]){ usage = 134;  usagePage = 1; }
        else if ([event isEqualToString:@"share"]) usage = 521;
        else if ([event isEqualToString:@"options"]) usage = 516;
        else if ([event isEqualToString:@"special"]) usage = 547;
        
        IOHIDEventRef navDown = IOHIDEventCreateKeyboardEvent(kCFAllocatorDefault,
                                                              timeStamp,
                                                              usagePage,
                                                              usage,
                                                              1,
                                                              0);
        
        IOHIDEventRef navUp = IOHIDEventCreateKeyboardEvent(kCFAllocatorDefault,
                                                            timeStamp,
                                                            usagePage,
                                                            usage,
                                                            0,
                                                            0);
        
        if (holdTouch == true) { //emulating a press and hold
            
            if (usage == 134) //menu press and hold takes more events being sent to trigger for some reason
            {
                BKSHIDEventSendToFocusedProcess(navDown);
                BKSHIDEventSendToFocusedProcess(navDown);
                BKSHIDEventSendToFocusedProcess(navDown);
                BKSHIDEventSendToFocusedProcess(navDown);
                BKSHIDEventSendToFocusedProcess(navDown);
                BKSHIDEventSendToFocusedProcess(navDown);
                BKSHIDEventSendToFocusedProcess(navDown);
                BKSHIDEventSendToFocusedProcess(navDown);
                
                
            } else { //any other key press and hold
                
                BKSHIDEventSendToFocusedProcess(navDown);
                BKSHIDEventSendToFocusedProcess(navDown);
                
            }
            
            
            if ([self respondsToSelector:@selector(delayedRelease:)])
            {
                [self performSelector:@selector(delayedRelease:) withObject:event afterDelay:1.0];
                
            }
            
        } else { //normal event, no press and hold
            
            BKSHIDEventSendToFocusedProcess(navDown);
            BKSHIDEventSendToFocusedProcess(navUp);
            
        }
        
        
        
    }
    
}



//also called from Pineboard, this is to do press and hold events

- (void)delayedRelease:(NSString *)event
{
    
    if (!_ioSystemClient)
        _ioSystemClient = IOHIDEventSystemClientCreate(kCFAllocatorDefault);
    
    id processMan = [objc_getClass("TVSProcessManager") sharedInstance];
    uint64_t abTime = mach_absolute_time();
    AbsoluteTime timeStamp;
    timeStamp.hi = (UInt32)(abTime >> 32);
    timeStamp.lo = (UInt32)(abTime);
    
    uint16_t usage = 0;
    uint16_t usagePage = 12;
    if ([event isEqualToString:@"right"]) usage = 69;
    else if ([event isEqualToString:@"left"]) usage = 68;
    else if ([event isEqualToString:@"down"]) usage = 67;
    else if ([event isEqualToString:@"up"]) usage = 66;
    else if ([event isEqualToString:@"tap"]) usage = 65;
    //else if ([event isEqualToString:@"home"]) usage = 96;
    else if ([event isEqualToString:@"home"]) { usage = 134; usagePage = 1; }
    else if ([event isEqualToString:@"vlup"]) usage = 233;
    else if ([event isEqualToString:@"vldwn"]) usage = 234;
    else if ([event isEqualToString:@"siri"]) usage = 4;
    else if ([event isEqualToString:@"play"]) usage = 205;
    else if ([event isEqualToString:@"select"]) usage = 128;
    else if ([event isEqualToString:@"selecth"]) usage = 128;
    else if ([event isEqualToString:@"menu"]){ usage = 134;  usagePage = 1; }
    else if ([event isEqualToString:@"share"]) usage = 521;
    else if ([event isEqualToString:@"options"]) usage = 516;
    else if ([event isEqualToString:@"special"]) usage = 547;
    
    IOHIDEventRef navUp = IOHIDEventCreateKeyboardEvent(kCFAllocatorDefault,
                                                        timeStamp,
                                                        usagePage,
                                                        usage,
                                                        0,
                                                        0);
    if (usage == 134) {
        
        BKSHIDEventSendToFocusedProcess(navUp);
        BKSHIDEventSendToFocusedProcess(navUp);
        BKSHIDEventSendToFocusedProcess(navUp);
        BKSHIDEventSendToFocusedProcess(navUp);
        BKSHIDEventSendToFocusedProcess(navUp);
        BKSHIDEventSendToFocusedProcess(navUp);
        BKSHIDEventSendToFocusedProcess(navUp);
        BKSHIDEventSendToFocusedProcess(navUp);
        
    } else {
        BKSHIDEventSendToFocusedProcess(navUp);
        BKSHIDEventSendToFocusedProcess(navUp);
    }
}

//text entry all goes through here, also being called from within PineBoard.app

- (void)IOHIDTest:(NSNotification *)note
{
    
    NSString *theText = note.userInfo[@"text"];
    BOOL clear = [note.userInfo[@"shouldClear"] boolValue];
    
    if (!_ioSystemClient)
        _ioSystemClient = IOHIDEventSystemClientCreate(kCFAllocatorDefault);
    
    id processMan = [objc_getClass("TVSProcessManager") sharedInstance];
    uint64_t abTime = mach_absolute_time();
    AbsoluteTime timeStamp;
    timeStamp.hi = (UInt32)(abTime >> 32);
    timeStamp.lo = (UInt32)(abTime);
    
    
    NSString *stripped = [theText stringByRemovingPercentEncoding];
    //  NSLog(@"original string: %@ stripped: %@", theText, stripped);
    
    /*
     right now since all the text is sent at once I cycle through
     50 times (should be sufficient to clear all text) before entering
     any new text. this is definitely not ideal but it works for now.
     
     */
    
    
    //   if ([theText isEqualToString:@"DELETE_ALL_TEXT_NAOW"])
    // {
    
    id pbApp = [ objc_getClass("PBApplication") sharedApplication];
    
    //    IOHIDEventRef IOHIDEventCreateKeyboardEvent(CFAllocatorRef allocator, AbsoluteTime timeStamp, uint16_t usagePage, uint16_t usage, Boolean down, IOHIDEventOptionBits flags);
    
    NSInteger sender = 4294968875; //no idea what this is but it works?
    if (clear){
        NSInteger i = 0;
        NSInteger deleteInt = 50;
        for (i = 0; i < deleteInt; i++)
        {
            IOHIDEventRef deleteDown = IOHIDEventCreateKeyboardEvent(kCFAllocatorDefault,
                                                                     timeStamp,
                                                                     7,
                                                                     kHIDUsage_KeyboardDeleteOrBackspace,
                                                                     1,
                                                                     0);
            
            IOHIDEventRef deleteUp = IOHIDEventCreateKeyboardEvent(kCFAllocatorDefault,
                                                                   timeStamp,
                                                                   7,
                                                                   kHIDUsage_KeyboardDeleteOrBackspace,
                                                                   0,
                                                                   0);
            
            
            BKSHIDEventSendToFocusedProcess(deleteDown);
            BKSHIDEventSendToFocusedProcess(deleteUp);
            //[pbApp forwardHIDButtonEventWithUsagePage:7 usage:kHIDUsage_KeyboardDeleteOrBackspace type:3 senderID:sender];
            //[processMan sendHIDEventToTopApplication:deleteDown];
            //[processMan sendHIDEventToTopApplication:deleteUp];
        }
    }
    //   return;
    //}
    
    /*
     
     finished deleting text, now to split the text up into componenents
     and cycle through each character and sending its HID event equivalent.
     
     part of the process is checking to see if its an uppercase char
     or special char like ~!@#$%^&*()_+|}{<>:\"? to determine if we need
     to "hold" shift while sending the necessary HID event.
     
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSArray *split = [[stripped stringByRemovingPercentEncoding] splitString];
        
        for (NSString *item in split)
        {
            NSLog(@"[DEBUG AirMagic] item: %@", item);
            uint32_t usage = hidUsageCodeForCharacter(item);
            
            IOHIDEventRef eventRefDown = IOHIDEventCreateKeyboardEvent(kCFAllocatorDefault,
                                                                       timeStamp,
                                                                       7,
                                                                       usage,
                                                                       1,
                                                                       0);
            
            IOHIDEventRef eventRefUp = IOHIDEventCreateKeyboardEvent(kCFAllocatorDefault,
                                                                     timeStamp,
                                                                     7,
                                                                     usage,
                                                                     0,
                                                                     0);
            
            //create special chracter set with special chars and all uppercase letters
            NSMutableCharacterSet *uppercaseSpecialSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"~!@#$%^&*()_+}{<>:\\\"?"];
            [uppercaseSpecialSet formUnionWithCharacterSet:[NSCharacterSet uppercaseLetterCharacterSet]];
            
            //if its uppercase hold down shift while sending HID event.
            
            BOOL isUppercase = [uppercaseSpecialSet characterIsMember:[item characterAtIndex:0]];
            if (isUppercase == YES)
            {
                IOHIDEventRef shiftDown = IOHIDEventCreateKeyboardEvent(kCFAllocatorDefault,
                                                                        timeStamp,
                                                                        7,
                                                                        kHIDUsage_KeyboardLeftShift,
                                                                        1,
                                                                        0);
                
                IOHIDEventRef shiftUp = IOHIDEventCreateKeyboardEvent(kCFAllocatorDefault,
                                                                      timeStamp,
                                                                      7,
                                                                      kHIDUsage_KeyboardLeftShift,
                                                                      0,
                                                                      0);
                
                //how we actually "hold down" shift ;)
                
                BKSHIDEventSendToFocusedProcess(shiftDown);
                BKSHIDEventSendToFocusedProcess(eventRefDown);
                BKSHIDEventSendToFocusedProcess(eventRefUp);
                // [pbApp forwardHIDButtonEventWithUsagePage:7 usage:usage type:3 senderID:sender];
                BKSHIDEventSendToFocusedProcess(shiftUp);
                
                
                
                
                
            } else {
                
                //not an uppercase or special char, just send the event normally
                BKSHIDEventSendToFocusedProcess(eventRefDown);
                BKSHIDEventSendToFocusedProcess(eventRefUp);
                //[pbApp forwardHIDButtonEventWithUsagePage:7 usage:usage type:3 senderID:sender];
            }
        } //end of for statement
    });
}

//old relics when i was hooking notifications to try and figure out how to do text entry without HIDEvents

- (NSArray *)otherBlackList
{
    NSArray *blacklistNote = [NSArray arrayWithObjects:@"NSHTTPCookieManagerCookiesChangedNotification", nil];
    return blacklistNote;
    
}


- (void)startTextFieldNotifications
{
    //NSLog(@"start text field notes");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBeginEditing:) name:@"UITextFieldTextDidBeginEditingNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndEditing:) name:@"UITextFieldTextDidEndEditingNotification" object:nil];
}


- (void)startMonitoringNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hookNotifications:) name:nil object:nil];
}

- (void)stopWatchingNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSArray *)whiteList
{
    return [NSArray arrayWithObjects:@"UITextFieldTextDidBeginEditingNotification", @"UITextFieldTextDidEndEditingNotification", @"SBApplicationNotificationStateChanged", nil];
    
}

- (void)didBeginEditing:(NSNotification *)n
{
    
    /* NSLog(@"did begin editing: %@", n.object);
     id center = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"org.nito.test"];
     rocketbootstrap_distributedmessagingcenter_apply(center);
     NSMutableData *data = [[NSMutableData alloc] init];
     NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
     [archiver encodeObject:n.object forKey:@"object"];
     [archiver finishEncoding];
     [center sendMessageName:@"org.nito.test.doThings" userInfo:@{@"object": data}];
     */
    
}

- (void)didEndEditing:(NSNotification *)n
{
    NSLog(@"didEndEditing: %@", n);
    
}

- (void)doThings
{
    NSLog(@"dothings");
}

- (void)handleTextName:(NSString *)name userInfo:(NSDictionary *)userInfo
{
    [self IOHIDTest:userInfo[@"text"]];
}

//none of these special commands are supported by any of the clients yet, still on TODO list.

- (void)sendRebootCommand
{
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"org.nito.test.helperCommand" object:nil userInfo:@{@"command": @"reboot"}];
    //id center = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"org.nito.test"];
    //rocketbootstrap_distributedmessagingcenter_apply(center);
    //[center sendMessageName:@"org.nito.test.helperCommand" userInfo:@{@"command": @"reboot"}];
}

- (void)startScreensaver
{
    
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"org.nito.test.helperCommand" object:nil userInfo:@{@"command": @"activateScreenSaver"}];
}

- (void)launchKioskApp
{
    //id processMan = [objc_getClass("TVSProcessManager") sharedInstance];
    //NSLog(@"#### processMan: %@", processMan);
    //id center = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"org.nito.test"];
    //rocketbootstrap_distributedmessagingcenter_apply(center);
    //[center sendMessageName:@"org.nito.test.helperCommand" userInfo:@{@"command": @"relaunch"}];
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"org.nito.test.helperCommand" object:nil userInfo:@{@"command": @"launchKioskApp"}];
}

- (void)sendRespringCommand
{
    //id processMan = [objc_getClass("TVSProcessManager") sharedInstance];
    //NSLog(@"#### processMan: %@", processMan);
    //id center = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"org.nito.test"];
    //rocketbootstrap_distributedmessagingcenter_apply(center);
    //[center sendMessageName:@"org.nito.test.helperCommand" userInfo:@{@"command": @"relaunch"}];
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"org.nito.test.helperCommand" object:nil userInfo:@{@"command": @"respring"}];
}

- (void)handleHelperNotification:(NSNotification *)n {
    
    NSString *theCommand = [n userInfo][@"command"];
    id processMan = [objc_getClass("PBSSystemService") sharedInstance];
    if ([theCommand isEqualToString:@"reboot"]) {
        [processMan reboot];
    } else if ([theCommand isEqualToString:@"relaunch"]) {
        [processMan relaunch];
    }  else if ([theCommand isEqualToString:@"relaunchBackboardd"]) {
        [processMan relaunchBackboardd];
    } else if ([theCommand isEqualToString:@"activateScreenSaver"]) {
        [processMan activateScreenSaver];
    }  else if ([theCommand isEqualToString:@"launchKioskApp"]) {
        [processMan launchKioskApp];
    } else if ([theCommand isEqualToString:@"respring"]) {
        //[processMan launchKioskApp];
        
        [NSTask launchedTaskWithLaunchPath:@"/usr/bin/uicache" arguments:@[]];
        
    }
    
}

- (void)helperCommand:(NSString *)command withInfo:(NSDictionary *)info
{
    id processMan = [objc_getClass("TVSProcessManager") sharedInstance];
    NSString *theCommand = info[@"command"];
    if ([theCommand isEqualToString:@"reboot"])
    {
        [processMan reboot];
    } else if ([theCommand isEqualToString:@"relaunch"])
    {
        
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *whichKill = @"/tmp/usr/bin/killall";
        if (![manager fileExistsAtPath:whichKill])
        {
            whichKill = @"/usr/bin/killall";
        }
        id appDepot = [objc_getClass("PBAppDepot") sharedInstance];
        NSMutableDictionary *installedAppStates = [appDepot internalAppState];
        //  NSLog(@"installedAppStates: %@", installedAppStates);
        
        NSError *error = nil;
        if(NSArray *apps = [manager contentsOfDirectoryAtPath:@"/Applications" error:&error])
        {   for (NSString *app in apps)
            if ([app hasSuffix:@".app"]) {
                
                NSString *path = [@"/Applications" stringByAppendingPathComponent:app];
                NSString *newPl = [path stringByAppendingPathComponent:@"Info.plist"];
                // NSString *installPl = [path stringByAppendingPathComponent:@"Install.plist"];
                //NSLog(@"installPl: %@", installPl);
                //NSDictionary *install = [NSDictionary dictionaryWithContentsOfFile:installPl];
                // NSLog(@"install: %@", installPl);
                
                if (NSMutableDictionary *info = [NSMutableDictionary dictionaryWithContentsOfFile:newPl]) {
                    if (NSString *identifier = [info objectForKey:@"CFBundleIdentifier"]) {
                        
                        //NSLog(@"identifier: %@", identifier);
                        
                        id existingObject = [installedAppStates objectForKey:identifier];
                        if (existingObject != nil)
                        {
                            [installedAppStates setObject:existingObject forKey:identifier];
                            [appDepot _save];
                        } else {
                            
                            NSLog(@"didnt find object for key: %@, adding!", identifier);
                            
                            Class PBSMASC = objc_getClass("PBSMutableAppState");
                            id appState = [[PBSMASC alloc] initWithApplicationIdentifer:identifier];
                            [appState setEnabled:YES];
                            [appDepot _addAppStateForIdentifier:identifier];
                            
                            Class $LSApplicationWorkspace(objc_getClass("LSApplicationWorkspace"));
                            LSApplicationWorkspace *workspace($LSApplicationWorkspace == nil ? nil : [$LSApplicationWorkspace defaultWorkspace]);
                            
                            if ([workspace respondsToSelector:@selector(_LSPrivateSyncWithMobileInstallation)]){
                                
                                [workspace _LSPrivateSyncWithMobileInstallation];
                            } else {
                                
                                
                                
                                //NSArray *files = [manager contentsOfDirectoryAtPath:@"/var/mobile/Library/Caches/" error:&error];
                                
                                NSString *file = @"/var/mobile/Library/Caches/com.apple.LaunchServices-135.csstore";
                                
                                NSError *removeError = nil;
                                
                                [manager removeItemAtPath:file error:&removeError];
                                
                                
                                [workspace _LSClearSchemaCaches];
                                [workspace _LSPrivateRebuildApplicationDatabasesForSystemApps:YES internal:YES user:YES];
                                
                                
                                
                                
                                
                            }
                            
                            
                        }
                        
                        
                        
                    }
                    
                }
                
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [NSTask launchedTaskWithLaunchPath:whichKill arguments:@[@"-9", @"PineBoard", @"HeadBoard", @"lsd"]];
            });
            
            
            
        }
        
        
        
    }
}

- (void)handleRemoteEvent:(NSString *)event
{
    //id center = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"org.nito.test"];
    //rocketbootstrap_distributedmessagingcenter_apply(center);
    //[center sendMessageName:@"org.nito.test.doThings" userInfo:@{@"event": event}];
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"org.nito.test.doThings" object:nil userInfo:@{@"event": event}];
}

//was watching this to try to determine ways to get access to UITextFields and keep a reference
//to them before figuring out how to send keyboard HID events.
//no longer needed for now, but might be used later to better monitor events on atv for reporting

- (void)appWentFrontMost:(NSNotification *)n
{
    UIScreen *main = [UIScreen mainScreen];
    
    id focused = [main focusedView];
    //NSLog(@"#### appWentFrontMost mainScreen focusedVIew: %@", focused);
    //  NSLog(@"frontmost: %@", n.userInfo);
    self.frontMostAppID = [n.userInfo[@"SBApplicationStateDisplayIDKey"] copy];
    // NSLog(@"fmai: %@", self.frontMostAppID);
    id app = [objc_getClass("PBAppDelegate") sharedApplicationDelegate];
    //   id window = [app appSwitcherWindow];
    // id kwrvc = [[app keyWindow] rootViewController];
    // NSLog(@"sharedApplication: %@", self.frontMostAppID);
    //id center = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"org.nito.test"];
    //rocketbootstrap_distributedmessagingcenter_apply(center);
    //[center sendMessageName:@"org.nito.test.doThings" userInfo:nil];
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"org.nito.test.doThings" object:nil userInfo:nil];
}

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

- (NSInteger)portFromConfigFile:(NSString *)configFile {
    
    NSString *fileContents = [NSString stringWithContentsOfFile:configFile encoding:NSASCIIStringEncoding error:nil];
    NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
    
    __block NSInteger returnPort = 3073;
    
    [lines enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj containsString:@"Port"]) {
            
            //found the line with the port in it, now separate the line by spaces, the second space SHOULD be the port
            
            NSArray *portArray = [obj componentsSeparatedByString:@" "];
            if ([portArray count] > 1)
            {
                returnPort = [portArray[1] integerValue];
                *stop = TRUE;
                //return
            }
            
            
        }
        
    }];
    
    //NSLog(@"AirMagic problem parsing file at: %@ using default port of %lu", configFile, DEFAULT_PORT);
    return returnPort;
}

- (NSInteger)portFromConfigFiles {
    
    ///etc/airmagic/conf -/.airmagic/conf?
    NSFileManager *man = [NSFileManager defaultManager];
    NSString *etcFile = @"/etc/airmagic/conf";
    NSString *mobileConfig = @"/var/mobile/.airmagic/conf";
    NSString *rootConfig = @"/var/root/.airmagic/conf";
    if (![man fileExistsAtPath:etcFile] && ![man fileExistsAtPath:mobileConfig] && ![man fileExistsAtPath:rootConfig]) {
        
        return DEFAULT_PORT;
        
    }
    
    if ([man fileExistsAtPath:mobileConfig]) {
        
        return [self portFromConfigFile:mobileConfig];
        
    } else if ([man fileExistsAtPath:rootConfig]) {
        
        return [self portFromConfigFile:rootConfig];
        
    } else if ([man fileExistsAtPath:etcFile]){
        
        return [self portFromConfigFile:etcFile];
    }
    
    //we should NEVER get down here, but it cant hurt to return the port number here  too
    
    return DEFAULT_PORT;
}

- (void)startItUp
{
    // Configure our logging framework.
    // To keep things simple and fast, we're just going to log to the Xcode console.
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // Initalize our http server
    self.httpServer = [[HTTPServer alloc] init];
    
    // Tell server to use our custom MyHTTPConnection class.
    [httpServer setConnectionClass:[MyHTTPConnection class]];
    
    // Tell the server to broadcast its presence via Bonjour.
    // This allows browsers such as Safari to automatically discover our service.
    [httpServer setType:@"_airmagic._tcp."];
    
    // Normally there's no need to run our server on any specific port.
    // Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
    // However, for easy testing you may want force a certain port so you can just hit the refresh button.
    NSInteger configPort = [self portFromConfigFiles];
    [httpServer setPort:configPort];
    [httpServer setTXTRecordDictionary:[self txtRecordDictionary]];
    // Serve files from our embedded Web folder
    //	NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
    //	DDLogVerbose(@"Setting document root: %@", webPath);
    
    [httpServer setDocumentRoot:[MyHTTPConnection airControlRoot]];
    //
    // Start the server (and check for problems)
    NSError *error;
    BOOL success = [httpServer start:&error];
    
    
    if(!success)
    {
        NSLog(@"Error starting HTTP Server: %@", error);
        DDLogError(@"Error starting HTTP Server: %@", error);
    }
    
    //  [self startTextFieldNotifications];
}


- (NSDictionary *)systemDetails
{
    NSString *osversion = [[UIDevice currentDevice] systemVersion];
    NSString *osBuild = [[UIDevice currentDevice] buildVersion];
    //NSLog(@"osv: %@ osb: %@", osversion, osBuild);
    if (osBuild != nil && osversion != nil)
    {
        return @{@"osVersion": osversion, @"osBuild": osBuild};
    }
    return nil;
}


- (float)currentVersion
{
    return 1.0f;
}

- (NSDictionary *)txtRecordDictionary
{
    NSString *osversion = [[UIDevice currentDevice] systemVersion];
    NSString *osBuild = [[UIDevice currentDevice] buildVersion];
    NSString *currentVersionNumber = [NSString stringWithFormat:@"%.01f", [self currentVersion]];
    return [NSDictionary dictionaryWithObjectsAndKeys:currentVersionNumber, @"apiversion", osversion, @"osversion" , osBuild, @"osbuild", nil];
    
    
}


- (void)appendText:(NSString *)enterText {

    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"org.nito.test.setText" object:nil userInfo:@{@"text": enterText, @"shouldClear": [NSNumber numberWithBool:FALSE]}];
}

- (void)enterText:(NSString *)enterText
{
    //[self IOHIDTest:enterText];
    
    //id center = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"org.nito.test"];
    //rocketbootstrap_distributedmessagingcenter_apply(center);
    //[center sendMessageName:@"org.nito.test.setText" userInfo:@{@"text": enterText}];
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"org.nito.test.setText" object:nil userInfo:@{@"text": enterText, @"shouldClear": [NSNumber numberWithBool:TRUE]}];
}


- (void)hookNotifications:(NSNotification *)n
{
    return;
    //NSLog(@"%@", n);
    id object = [n object];
    NSString *name = [n name];
    NSDictionary *userInfo = [n userInfo];
    
    if (object != nil && name != nil)
    {
        if ([[self whiteList] containsObject:name])
            
        {
            
            Class cls = [object superclass];
            Class cls2 = [object class];
            NSString *objectSuperName = NSStringFromClass(cls);
            NSString *objectName = NSStringFromClass(cls2);
            // NSLog(@"NOTIFICATION_HOOK: %@ class: %@ superclass: %@", name, objectName, objectSuperName);
            NSString *notifcationLog = [NSString stringWithFormat:@"NOTIFICATION: name: %@ object: %@ class: %@ superclass: %@", name, object, objectName, objectSuperName];
            NSLog(@"%@", notifcationLog);
            
            if ([name isEqualToString:@"UITextFieldTextDidBeginEditingNotification"])
            {
                [self didBeginEditing:n];
            }
            
            if ([name isEqualToString:@"UITextFieldTextDidEndEditingNotification"])
            {
                [self didEndEditing:n];
            }
            
            
            
            
        }
        
        //LogIt(@"NOTIFICATION: name: %@", name);
    } else if (userInfo != nil)
    {
        if ([[self whiteList] containsObject:name])
            
        {
            
            //NSLog(@"NOTIFICATION_HOOK: %@ class: %@ superclass: %@", name, objectName, objectSuperName);
            NSString *notifcationLog = [NSString stringWithFormat:@"NOTIFICATION: name: %@ userInfo: %@", name, userInfo ];
            NSLog(@"%@", notifcationLog);
            
            if ([name isEqualToString:@"SBApplicationNotificationStateChanged"])
            {
                if ([userInfo[@"BKSApplicationStateAppIsFrontmost"] boolValue] == true)
                {
                    [self appWentFrontMost:n];
                }
            }
        }
    }
}



+ (id)sharedInstance {
    
    static dispatch_once_t onceToken;
    static RemoteTestHelper *shared;
    
    dispatch_once(&onceToken, ^{
        shared = [RemoteTestHelper new];
        // [[NSNotificationCenter defaultCenter] addObserver:shared selector:@selector(hookNotifications:) name:nil object:nil];
    });
    
    return shared;
    
}

@end
