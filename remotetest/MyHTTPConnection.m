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
    NSLog(@"in here: %@ uri: %@", method, path);
    
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



- (id)processURL:(NSString *)path
{
    [self frontMostScience];
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
