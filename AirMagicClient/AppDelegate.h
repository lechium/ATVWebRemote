//
//  AppDelegate.h
//  AirMagicClient
//
//  Created by Kevin Bradley on 4/9/16.
//  Copyright © 2016 nito. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AMCButton: NSButton

@property (nonatomic, strong) NSString *normalCommand;
@property (nonatomic, strong) NSString *holdCommand;

@end

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, weak) IBOutlet AMCButton *selectButton;

- (void)sendCommand:(NSString *)theCommand;

@end

