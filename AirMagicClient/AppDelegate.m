//
//  AppDelegate.m
//  AirMagicClient
//
//  Created by Kevin Bradley on 4/9/16.
//  Copyright © 2016 nito. All rights reserved.
//

#import "AppDelegate.h"
#import "ATVDeviceController.h"



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
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
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
