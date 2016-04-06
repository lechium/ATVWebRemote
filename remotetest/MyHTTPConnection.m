//
//  MyHTTPConnection.m
//  ATVWebRemote
//
//  Created by Kevin Bradley on 4/3/16.
//  Copyright © 2016 nito. All rights reserved.
//

#import "MyHTTPConnection.h"
#import "Core/HTTPDataResponse.h"
#import "RemoteTestHelper.h"
#import "SpringBoardServices.h"
#import "AppSupport/CPDistributedMessagingCenter.h"

@implementation MyHTTPConnection

+ (NSString *)airControlRoot
{
    NSString *airControlPath = @"/var/mobile/Library/Preferences/AirControl";
    if (![[NSFileManager defaultManager] fileExistsAtPath:airControlPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:airControlPath withIntermediateDirectories:TRUE attributes:nil error:nil];
    
    return airControlPath;
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
    NSString *pathFile = [path substringFromIndex:1];
    
    if ([pathFile isEqualToString:@""])
    {
        pathFile = @"index.html";
    }
    
    if ([[self defaultReturnArray] containsObject:pathFile])
    {
        return [super httpResponseForMethod:method URI:path];
    }
    
    
    return [self processURL:path];
    
    return [super httpResponseForMethod:method URI:path];
}

- (void)frontMostScience
{
    mach_port_t *p = (mach_port_t *)SBSSpringBoardServerPort();
    char frontmostAppS[256];
    memset(frontmostAppS,sizeof(frontmostAppS),0);
    SBFrontmostApplicationDisplayIdentifier(p,frontmostAppS);
    NSString * frontmostApp=[NSString stringWithFormat:@"%s",frontmostAppS];
    NSLog(@"Frontmost app is %@",frontmostApp);
    //get list of running apps from SpringBoard
   // NSArray *allApplications = SBSCopyApplicationDisplayIdentifiers(p,NO, NO);
    //for(NSString *identifier in allApplications)
    //{
      //  NSString *locName = SBSCopyLocalizedApplicationNameForDisplayIdentifier(identifier);
        //NSLog(@"identifier:%@, locName:%@",identifier,locName);
   // }
}


- (NSArray *)defaultReturnArray
{
    return [NSArray arrayWithObjects:@"coverart.png", @"index.html", @"remote.js", @"remote.css", nil];
}

- (NSString *)acHelpString
{
    return @"\nAircontrol Command Options:\n--------------------------\nenterText\t=\tsends text to a text entry view (ie enterText='my search')\nremoteCommand\t=\tsends a remote command to the AppleTV (menu, up, down, play, left, right, select)\n\n";
    
}

- (id)processURL:(NSString *)path
{
    //[self frontMostScience];
    NSArray *pathCommands = [[path substringFromIndex:1] componentsSeparatedByString:@"="];
    NSString *pathCommand = [pathCommands objectAtIndex:0];
    NSString *pathValue = nil;
    if ([pathCommands count] > 1)
    {
        pathValue = [pathCommands objectAtIndex:1];
    }
    NSLog(@"processURL path command: %@ pathValue: %@", pathCommand, pathValue);
    if ([pathCommand isEqualToString:@"enterText"])
    {
        [[RemoteTestHelper sharedInstance] enterText:pathValue];
    } else if ([pathCommand isEqualToString:@"remoteCommand"])
    {
        [[RemoteTestHelper sharedInstance] handleRemoteEvent:pathValue];
    } else if ([pathCommand isEqualToString:@"help"])
    {
        return [self failedWithMessage:[self acHelpString]];
    }
    
    return [self blankSuccessResponse];
    
}

- (NSObject *)failedWithMessage:(NSString *)message
{
    NSData *postData = [message dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [[HTTPDataResponse alloc] initWithData:postData];
}

- (NSObject *)blankSuccessResponse
{
    NSData *postData = [@"" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [[HTTPDataResponse alloc] initWithData:postData];
}


@end
