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

IOHIDEventSystemClientRef IOHIDEventSystemClientCreate(CFAllocatorRef);

@interface NSString (SplitString)

- (NSArray *)splitString;

@end

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


@interface TVSProcessManager : NSObject
+ (id)sharedInstance;
- (id)_foregroundScene;
- (void)sendHIDEventToTopApplication:(struct __IOHIDEvent *)arg1;
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

@interface PBApplication
- (id)FocusedProcessBinding;
+ (id)sharedApplication;
- (id)appSwitcherWindow;
@end

static inline uint32_t hidUsageCodeForCharacter(NSString *key)
{
    const int uppercaseAlphabeticOffset = 'A' - kHIDUsage_KeyboardA;
    const int lowercaseAlphabeticOffset = 'a' - kHIDUsage_KeyboardA;
    const int numericNonZeroOffset = '1' - kHIDUsage_Keyboard1;
    if (key.length == 1) {
        // Handle alphanumeric characters and basic symbols.
        int keyCode = [key characterAtIndex:0];
        
        NSLog(@"keyCode: %i", keyCode);
        
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



- (void)IOHIDTest:(NSString *)theText
{
    if (!_ioSystemClient)
        _ioSystemClient = IOHIDEventSystemClientCreate(kCFAllocatorDefault);

    id processMan = [objc_getClass("TVSProcessManager") sharedInstance];
    uint64_t abTime = mach_absolute_time();
    AbsoluteTime timeStamp;
    timeStamp.hi = (UInt32)(abTime >> 32);
    timeStamp.lo = (UInt32)(abTime);
   
    
    NSString *stripped = [theText stringByRemovingPercentEncoding];
    NSLog(@"original string: %@ stripped: %@", theText, stripped);
    
    
 //   if ([theText isEqualToString:@"DELETE_ALL_TEXT_NAOW"])
   // {
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
            [processMan sendHIDEventToTopApplication:deleteDown];
            [processMan sendHIDEventToTopApplication:deleteUp];
        }
     //   return;
    //}
    
    NSArray *split = [[stripped stringByRemovingPercentEncoding] splitString];
    
    for (NSString *item in split)
    {
        NSLog(@"item: %@", item);
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
        
        //
        NSMutableCharacterSet *uppercaseSpecialSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"~!@#$%^&*()_+|}{<>:\"?"];
        [uppercaseSpecialSet formUnionWithCharacterSet:[NSCharacterSet uppercaseLetterCharacterSet]];
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
            
            [processMan sendHIDEventToTopApplication:shiftDown];
            [processMan sendHIDEventToTopApplication:eventRefDown];
            [processMan sendHIDEventToTopApplication:eventRefUp];
            [processMan sendHIDEventToTopApplication:shiftUp];

            
        } else {
            
            [processMan sendHIDEventToTopApplication:eventRefDown];
            [processMan sendHIDEventToTopApplication:eventRefUp];
            
        }
       
        
    }
}

- (NSArray *)otherBlackList
{
    NSArray *blacklistNote = [NSArray arrayWithObjects:@"NSHTTPCookieManagerCookiesChangedNotification", nil];
    return blacklistNote;

}

- (UITextField *)ctf
{
    return [self associatedValueForKey:(void*)kCurrentTextFieldID];
}
    
- (void)setCTF:(id)value
{
    id _tempTextField = value;
    if ([value isKindOfClass:[NSData class]])
    {
        NSLog(@"is data!! UNARCHIVE");
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:value];
        _tempTextField = [unarchiver decodeObjectForKey:@"object"];
        [unarchiver finishDecoding];
        NSLog(@"tempTextField: %@", _tempTextField);
    }
    
    [self associateValue:_tempTextField withKey:(void*)kCurrentTextFieldID];
}

- (void)startTextFieldNotifications
{
    NSLog(@"start text field notes");
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
    NSLog(@"did begin editing: %@", n.object);
    
    watchObject(n.object);
    
   /* NSLog(@"did begin editing: %@", n.object);
    id center = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"org.nito.test"];
    rocketbootstrap_distributedmessagingcenter_apply(center);
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:n.object forKey:@"object"];
    [archiver finishEncoding];
    [center sendMessageName:@"org.nito.test.doThings" userInfo:@{@"object": data}];
    */
    /*
     dispatch_async(dispatch_get_main_queue(), ^{
       self.currentTextField = n.object;
       [self setCTF:n.object];
       NSLog(@"self.currentTextField: %@ ctf: %@", self.currentTextField, [self ctf]);
   });
    self.ctfBackup = [self currentTextField];
    NSLog(@"ctf backup: %@", self.ctfBackup);
     
     */
    
    __block id field = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // code below is executed synchronously
        // access to UI is safe is its a main thread
        field = [n object];
        NSLog(@"field async: %@", field);

        @synchronized(self) {
        [self setCurrentTextField:field];
        [self setCTF:field];
        [self setCtfBackup:field];
        
        }
    });
    
    NSLog(@"field: %@", field);
    //@synchronized(self) {
        [self setCurrentTextField:field];
        [self setCTF:field];
        [self setCtfBackup:field];
        
    //}

    
}

- (void)didEndEditing:(NSNotification *)n
{
    NSLog(@"didEndEditing: %@", n);
    self.currentTextField = nil;
}

- (void)doThings
{
    NSLog(@"dothings");
}

- (void)handleTextName:(NSString *)name userInfo:(NSDictionary *)userInfo
{
    
    [self IOHIDTest:userInfo[@"text"]];
    /*
    NSLog(@"text name: %@ info: %@", name, userInfo);
    UITextField *ctf = [self ctf];
    NSLog(@"ctf: %@", ctf);
    NSString *text = userInfo[@"text"];
      dispatch_async(dispatch_get_main_queue(), ^{
         
          if (ctf != nil)
          {
              [ctf setText:text];
              [ctf endEditing:true];
          }
          
      });
     
     */
}

- (void)handleMessageName:(NSString *)name userInfo:(NSDictionary *)userInfo
{
    if (userInfo != nil)
    {
        id object = userInfo[@"object"];
        [self setCTF:object];
      
        return;
    }
    NSLog(@"messageNAme: %@ userInfo: %@", name, userInfo);
    
     // [self IOHIDTest];
    /*
   // id keyWindow = [UIWindow keyWindow];
    id keyExWindow = [UIWindow _externalKeyWindow];
    UIScreen *main = [UIScreen mainScreen];
    id focused = [main focusedView];
    NSLog(@"#### mainScreen focusedVIew: %@", focused);
    NSArray *allScreens = [UIScreen screens];
    NSLog(@"allScreens: %@", allScreens);
    NSLog(@"keyExWindow: %@", keyExWindow);
    NSArray *allWindows = [UIWindow allWindowsIncludingInternalWindows:true onlyVisibleWindows:false forScreen:main];
    NSLog(@"all windows: %@", allWindows);
    
    
    for (UIWindow *window in allWindows)
    {
        
        //NSLog(@"window: %@ recurse: %@", window, rd);
        if ([window respondsToSelector:@selector(sceneContainerView)])
        {
            id scv = [window performSelector:@selector(sceneContainerView)];
            id window = [scv windowWithSceneID:@"com.nito.tuyuTV"];
            NSLog(@"######## found window!!!: %@", window);
            // NSString *rd = [scv performSelector:@selector(recursiveDescription)];
            //NSLog(@"scv: %@ recurse: %@", scv, rd);
          
            
        }
    }
     */
    
    id processMan = [objc_getClass("FBProcessManager") sharedInstance];
    id fap = [processMan valueForKey:@"_foregroundAppProcess"];
    NSLog(@"processMan: %@ fap: %@", processMan, fap);
    //_foregroundAppProcess
    
    id lib = [objc_getClass("FBApplicationLibrary") sharedInstance];
    
    id tuyuapp = [lib installedApplicationWithBundleIdentifier:@"com.nito.tuyuTV"];
    id allApps = [lib allInstalledApplications];
    NSLog(@"tuyutv: %@ allApps: %@", tuyuapp, allApps);
    
    
    id app = [objc_getClass("PBAppDelegate") sharedApplicationDelegate];
    NSLog(@"appDel: %@", app);
    app = [objc_getClass("PBApplication") sharedApplication];
    NSLog(@"app: %@", app);
    id focusedBind = [app FocusedProcessBinding];
    NSLog(@"focused bind: %@", focusedBind);
    /*id window = [app appSwitcherWindow];
    id kwrvc = [[app keyWindow] rootViewController];
    NSLog(@"window: %@ kwrvc: %@", window, kwrvc);
    
    id bl = [objc_getClass("PBBundleLoader") sharedInstance];
    NSLog(@"bl: %@", bl);
    id object = [bl pluginControllerForBundleIdentifier:userInfo[@"SBApplicationStateDisplayIDKey"]];
    NSLog(@"object: %@", object);
    
    id hpw = [[objc_getClass("PBWindowManager") sharedInstance]_highestPriorityWindow];
    id rvc = [hpw rootViewController];
    NSString *recursiveDesc = [[rvc view] performSelector:@selector(recursiveDescription)];
    NSLog(@"recurse: %@", recursiveDesc);
    //
  id foundView =  [[rvc view] recursiveSubviewWithClass:NSClassFromString(@"FBContextLayerHostView") ];
    NSLog(@"###### FOUND VIEW: %@", foundView);
    if (foundView != nil)
    {
        NSString *recursiveDesc = [foundView performSelector:@selector(recursiveDescription)];
        NSLog(@"foundView recurse: %@", recursiveDesc);
    }
    */
    
}

- (void)appWentFrontMost:(NSNotification *)n
{
    UIScreen *main = [UIScreen mainScreen];

    id focused = [main focusedView];
    NSLog(@"#### appWentFrontMost mainScreen focusedVIew: %@", focused);
  //  NSLog(@"frontmost: %@", n.userInfo);
    self.frontMostAppID = [n.userInfo[@"SBApplicationStateDisplayIDKey"] copy];
   // NSLog(@"fmai: %@", self.frontMostAppID);
    id app = [objc_getClass("PBAppDelegate") sharedApplicationDelegate];
 //   id window = [app appSwitcherWindow];
   // id kwrvc = [[app keyWindow] rootViewController];
   // NSLog(@"sharedApplication: %@", self.frontMostAppID);
    id center = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"org.nito.test"];
    rocketbootstrap_distributedmessagingcenter_apply(center);
    [center sendMessageName:@"org.nito.test.doThings" userInfo:nil];

}

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

- (void)startItUp
{
    NSLog(@"pbdelegateref: %@", self.pbDelegateRef);
    // Configure our logging framework.
    // To keep things simple and fast, we're just going to log to the Xcode console.
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // Initalize our http server
    self.httpServer = [[HTTPServer alloc] init];
    
    // Tell server to use our custom MyHTTPConnection class.
    [httpServer setConnectionClass:[MyHTTPConnection class]];
    
    // Tell the server to broadcast its presence via Bonjour.
    // This allows browsers such as Safari to automatically discover our service.
    [httpServer setType:@"_aircontrol._tcp."];
    
    // Normally there's no need to run our server on any specific port.
    // Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
    // However, for easy testing you may want force a certain port so you can just hit the refresh button.
    [httpServer setPort:80];
//    [httpServer setTXTRecordDictionary:[self txtRecordDictionary]];
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
        DDLogError(@"Error starting HTTP Server: %@", error);
    }
    
  //  [self startTextFieldNotifications];
}



- (void)enterText:(NSString *)enterText
{

    
    id center = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"org.nito.test"];
    rocketbootstrap_distributedmessagingcenter_apply(center);
    [center sendMessageName:@"org.nito.test.setText" userInfo:@{@"text": enterText}];

    
    dispatch_async(dispatch_get_main_queue(), ^{
    id tf = [self ctf];

    NSLog(@"#### TF: %@ ctf: %@ ctfb: %@", tf, [self currentTextField], [self ctfBackup]);
    
    NSLog(@"enterText: %@ currentTextField: %@ fmai: %@", enterText, self.currentTextField, self.frontMostAppID);
    
    if (self.frontMostAppID.length > 0)
    {
        NSLog(@"app bundle: %@", [NSBundle bundleWithIdentifier:self.frontMostAppID]);
    }
    

    if (self.currentTextField != nil)
    {
       
            
            NSLog(@"attempting to enter text: %@", enterText);
            [self.currentTextField setText:enterText];
            [self.currentTextField endEditing:true];
            
        
    }
        });
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

- (void)setCurrentTextField:(UITextField *)ctf
{
    _currentTextField = ctf;
}

- (UITextField *)currentTextField
{
    return _currentTextField;
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