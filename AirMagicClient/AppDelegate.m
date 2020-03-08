//
//  AppDelegate.m
//  AirMagicClient
//
//  Created by Kevin Bradley on 4/9/16.
//  Copyright © 2016 nito. All rights reserved.
//

#import "AppDelegate.h"
#import "ATVDeviceController.h"

@interface AMCPanel: NSPanel
@end
@interface AMCWindow: NSWindow
@end

@implementation AMCWindow
- (void)keyDown:(NSEvent *)theEvent
{
    unsigned short key = [theEvent keyCode];
    if (key == 4)
    {
        [(AppDelegate*)[NSApp delegate] sendCommand:@"selecth"];
        return;
    }
    [super keyDown:theEvent];
}

- (void)keyUp:(NSEvent *)theEvent
{
    [super keyUp:theEvent];
}
@end

@implementation AMCPanel
- (void)keyDown:(NSEvent *)theEvent
{
    //124 = right
    //123 = left
    //36 = return
    //126 = up
    //125 = down
    //53 = esc
    unsigned short key = [theEvent keyCode];
    switch(key){
        case 124: //right
            [(AppDelegate*)[NSApp delegate] sendCommand:@"right"];
            return;
            
        case 123: //left
            [(AppDelegate*)[NSApp delegate] sendCommand:@"left"];
            return;
        
        case 126: //up
            [(AppDelegate*)[NSApp delegate] sendCommand:@"up"];
            return;
            
        case 125: //down
            [(AppDelegate*)[NSApp delegate] sendCommand:@"down"];
            return;
            
        case 53: //esc
            [(AppDelegate*)[NSApp delegate] sendCommand:@"menu"];
            return;
            
        case 36: //return
            [(AppDelegate*)[NSApp delegate] sendCommand:@"play"];
            return;
    }
    NSLog(@"code: %hu", key);
    if (key == 4)
    {
        [(AppDelegate*)[NSApp delegate] sendCommand:@"selecth"];
        return;
    }
    [super keyDown:theEvent];
}

- (void)keyUp:(NSEvent *)theEvent
{
    [super keyUp:theEvent];
}
@end


@implementation AMCButton

- (void)performHoldCommand
{
    AppDelegate *delegate = [NSApp delegate];
    [delegate sendCommand:self.holdCommand];
}

- (void)performNormalCommand
{
    AppDelegate *delegate = [NSApp delegate];
    [delegate sendCommand:self.normalCommand];
}

- (BOOL)performKeyEquivalent:(NSEvent *)theEvent
{
    BOOL orig = [super performKeyEquivalent:theEvent];
    if (orig == true)
    {
        [self performNormalCommand];
    }
    return orig;
}



- (void)mouseDown:(NSEvent *) event
{
    self.buttonType = self.tag;
    if ([self isEnabled] == FALSE)
    {
        return;
    }
    [self highlight:YES];
    
    //this code below is an example of how you call different methods based on whether or not your holding down the button.
    
    NSEvent *newEvent = [[self window] nextEventMatchingMask:(NSLeftMouseUp | NSLeftMouseUpMask) untilDate:[NSDate dateWithTimeIntervalSinceNow:.5] inMode:NSEventTrackingRunLoopMode dequeue:YES];
    if(newEvent != nil) {
        NSLog(@"not holding");
        [self performNormalCommand];
        [self highlight:NO];
    } else {
        NSLog(@"holding");
        [self performHoldCommand];
        
    }

}

- (void)mouseUp:(NSEvent *)event
{
    [super mouseUp:event];
    [self highlight:NO];
}
@end



@interface AppDelegate ()

@property (nonatomic, strong) ATVDeviceController *deviceController;
@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) NSTimer *nowPlayingTimer;
@property (nonatomic, strong) NSTimer *dateTimeTimer;
@property (nonatomic, strong) NSDateFormatter *timeFormat;
@end

@implementation AppDelegate

@synthesize deviceController;

static NSString *appleTVAddress = nil;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    self.selectButton.normalCommand = @"select";
    self.selectButton.holdCommand = @"selecth";
    deviceController = [[ATVDeviceController alloc] init];
    appleTVAddress = [DEFAULTS stringForKey:@"appleTVHost"];
    
    if ([[appleTVAddress componentsSeparatedByString:@":"] count] < 2)
    {
        [self resetServerSettings];
        
    }
    
    if (appleTVAddress != nil)
    {
        if (![self hostAvailable])
        {
            NSLog(@"host not available? resetting!");
            [self resetServerSettings];
        }
    }
    self.window.level = NSStatusWindowLevel;
    [self startNowPlayingTimer];
    [self startDateTimer];
}

- (void)updateTime {
    if (!_timeFormat) {
        _timeFormat = [[NSDateFormatter alloc] init];
        [_timeFormat setDateFormat:@"hh:mm:ss"];
    }
    self.timeLabel.stringValue = [_timeFormat stringFromDate:[ NSDate date]];
}

- (void)startDateTimer {
    self.dateTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:true block:^(NSTimer * _Nonnull timer) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [self updateTime];
        });
    }];
}

- (void)startNowPlayingTimer {
    self.nowPlayingTimer = [NSTimer scheduledTimerWithTimeInterval:5 repeats:true block:^(NSTimer * _Nonnull timer) {
       
        [self nowPlayingInfo:nil];
    }];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)nowPlayingInfo:(id)sender {
  
    [self fetchJSONInfoWithCompletion:^(NSDictionary *json) {
       
        NSLog(@"GOT IM!!!: %@", json);
        if (json){
              [self.keynoteWindow orderFront:nil];
            NSString *ipBare = [self ipBare];
            if (ipBare){
                NSString *prev = json[@"previousSlide"];
                NSString *next = json[@"nextSlide"];
                NSString *currentSlide = json[@"currentSlide"];
                NSInteger slideIndex = [json[@"slideIndex"] integerValue];
                NSInteger slideTotal = [json[@"slideTotal"] integerValue];
                NSString *slideString = [NSString stringWithFormat:@"Slide %lu of %lu", slideIndex, slideTotal];
                __block BOOL refresh = true;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([slideString isEqualToString:self.slideLabel.stringValue]){
                        refresh = false;
                    }
                    self.slideLabel.stringValue = slideString;
                });
                
                if (refresh == true){
                    if (prev){
                        NSString *fullPath = [NSString stringWithFormat:@"http://%@:8080/%@", ipBare, prev];
                        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:fullPath]];
                        NSImage *image = [[NSImage alloc] initWithData:data];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.previousImageSlide.image = image;
                        });
                        
                    }
                    if (next){
                        NSString *fullPath = [NSString stringWithFormat:@"http://%@:8080/%@", ipBare, next];
                        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:fullPath]];
                        NSImage *image = [[NSImage alloc] initWithData:data];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.nextImageSlide.image = image;
                        });
                    }
                    if (currentSlide){
                        NSString *fullPath = [NSString stringWithFormat:@"http://%@:8080/%@", ipBare, currentSlide];
                        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:fullPath]];
                        NSImage *image = [[NSImage alloc] initWithData:data];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.currentImageSlide.image = image;
                        });
                    }
                }
                
              
                
            }
        } else {
            [self.keynoteWindow close];
        }
     
        
    }];
}

- (NSString *)input: (NSString *)prompt defaultValue: (NSString *)defaultValue {
    NSAlert *alert = [NSAlert alertWithMessageText: prompt
                                     defaultButton:@"OK"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@""];
    
    NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
    [input setStringValue:defaultValue];
    [alert setAccessoryView:input];
    [input becomeFirstResponder];
    
    NSInteger button = [alert runModal];
    if (button == NSAlertDefaultReturn) {
        [input validateEditing];
        NSString *inputString = [input stringValue];
        return inputString;
    } else if (button == NSAlertAlternateReturn) {
        return nil;
    } else {
        
        NSAssert1(NO, @"Invalid input dialog button %d", button);
        return nil;
    }
}



- (void)sendCommand:(NSString *)theCommand
{
    NSString *httpCommand = [NSString stringWithFormat:@"http://%@/remoteCommand=%@", APPLE_TV_ADDRESS, theCommand];
    [NSTask launchedTaskWithLaunchPath:@"/usr/bin/curl" arguments:[NSArray arrayWithObject:httpCommand]];
}

- (IBAction)killLowtide:(id)sender
{
    NSString *httpCommand = [NSString stringWithFormat:@"http://%@/kf=1", APPLE_TV_ADDRESS];
    [NSTask launchedTaskWithLaunchPath:@"/usr/bin/curl" arguments:[NSArray arrayWithObject:httpCommand]];
}

- (IBAction)upAction:(id)sender
{
    [self sendCommand:@"up"];
}

- (IBAction)downAction:(id)sender
{
    [self sendCommand:@"down"];
}



- (IBAction)leftAction:(id)sender
{
   [self sendCommand:@"left"];
}

- (IBAction)rightAction:(id)sender
{
    [self sendCommand:@"right"];
}

- (IBAction)menuAction:(id)sender
{
    [self sendCommand:@"menu"];
}



- (IBAction)selectAction:(id)sender
{
    NSButton *theButton;
    NSString *httpCommand = [NSString stringWithFormat:@"http://%@/remoteCommand=select", APPLE_TV_ADDRESS];
    [NSTask launchedTaskWithLaunchPath:@"/usr/bin/curl" arguments:[NSArray arrayWithObject:httpCommand]];
}

- (IBAction)playAction:(id)sender
{
    [self sendCommand:@"play"];
}


- (IBAction)sendText:(id)sender
{
    NSString *output = [self input:@"Enter Text" defaultValue:@""];
    if ([output length] == 0)
    {
        NSLog(@"no text to send!! return!");
        return;
    }
    NSString *httpCommand = [NSString stringWithFormat:@"http://%@/enterText=%@", APPLE_TV_ADDRESS, output];
    [NSTask	launchedTaskWithLaunchPath:@"/usr/bin/curl" arguments:[NSArray arrayWithObject:httpCommand]];
}

- (NSString *)ipBare {
    return [[APPLE_TV_ADDRESS componentsSeparatedByString:@":"] firstObject];
}

- (void)fetchJSONInfoWithCompletion:(void(^)(NSDictionary *json))block {
    NSString *ipBare = [self ipBare];
    if (ipBare){
        NSString *httpCommand = [NSString stringWithFormat:@"http://%@:8080/info", ipBare];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setTimeoutInterval:2];
        [request setURL:[NSURL URLWithString:httpCommand]];
        [request setHTTPMethod:@"GET"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURLResponse *theResponse = nil;
            NSError *theError  = nil;
            NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
            
            if (returnData){
                NSError *jsonError = nil;
                id jsonData = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:&jsonError];
                if (jsonData){
                    if (block){
                        block(jsonData);
                    }
                } else {
                    if (block){
                        block(nil);
                    }
                }
                
            } else { // no return data
                block(nil);
            }
        });
        
    } else {
        block(nil);
    }
  
   // return request;
    
    
}

- (BOOL)hostAvailable
{
    NSMutableURLRequest *request = [self hostAvailableRequest];
    NSHTTPURLResponse * theResponse = nil;
    NSError *theError = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
    if (theError != nil)
    {
        NSLog(@"theResponse: %i theError; %@", [theResponse statusCode], theError);
        return (FALSE);
    }
    
    return (TRUE);
    
}

- (NSMutableURLRequest *)hostAvailableRequest // theres gotta be a more elegant way to do this
{
    NSString *httpCommand = [NSString stringWithFormat:@"http://%@/ap", APPLE_TV_ADDRESS];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setTimeoutInterval:2];
    [request setURL:[NSURL URLWithString:httpCommand]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"X-User-Agent" forHTTPHeaderField:@"User-Agent"];
    [request setValue:nil forHTTPHeaderField:@"X-User-Agent"];
    return request;
}

- (void)resetServerSettings
{
    [DEFAULTS removeObjectForKey:@"appleTVHost"];
    [DEFAULTS removeObjectForKey:ATV_OS];
    [DEFAULTS removeObjectForKey:ATV_API];
    [DEFAULTS setObject:@"Choose Apple TV" forKey:@"selectedValue"];
    appleTVAddress = nil;
}


@end
