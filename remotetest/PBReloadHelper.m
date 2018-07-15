//
//  PBReloadHelper.m
//  ATVWebRemote
//
//  Created by Kevin Bradley on 3/21/17.
//  Copyright © 2017 nito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSTask.h"
#import <objc/runtime.h>

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


#import "PBReloadHelper.h"

@implementation PBReloadHelper

+ (void)reloadApplications
{
    NSLog(@"### inside reload applications!");
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
    NSArray *apps = [manager contentsOfDirectoryAtPath:@"/Applications" error:&error];
    if (apps != nil)
    {   for (NSString *app in apps)
        if ([app hasSuffix:@".app"]) {
            
            NSString *path = [@"/Applications" stringByAppendingPathComponent:app];
            NSString *newPl = [path stringByAppendingPathComponent:@"Info.plist"];
            // NSString *installPl = [path stringByAppendingPathComponent:@"Install.plist"];
            //NSLog(@"installPl: %@", installPl);
            //NSDictionary *install = [NSDictionary dictionaryWithContentsOfFile:installPl];
            // NSLog(@"install: %@", installPl);
            
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithContentsOfFile:newPl];
            
            if (info != nil) {
                NSString *identifier = [info objectForKey:@"CFBundleIdentifier"];
                if(identifier != nil)  {
                    
                    NSLog(@"identifier: %@", identifier);
                    
                    id existingObject = [installedAppStates objectForKey:identifier];
                    if (existingObject != nil)
                    {
                        [installedAppStates setObject:existingObject forKey:identifier];
                        [appDepot _save];
                    } else {
                        
                        NSLog(@"didnt find object for key: %@, adding!", identifier);
                        
                        Class PBSMASC = objc_getClass("PBSMutableAppState");
                        Class WSCLASS = objc_getClass("LSApplicationWorkspace");
                        id appState = [[PBSMASC alloc] initWithApplicationIdentifer:identifier];
                        [appState setEnabled:YES];
                        [appDepot _addAppStateForIdentifier:identifier];
                        id workspace = nil;
                        //Class $LSApplicationWorkspace(objc_getClass("LSApplicationWorkspace"));
                        if (WSCLASS != nil)
                        {
                            workspace = [WSCLASS defaultWorkspace];
                        }
                      //  id workspace(WSCLASS == nil ? nil : [WSCLASS defaultWorkspace]);
                        
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

@end
