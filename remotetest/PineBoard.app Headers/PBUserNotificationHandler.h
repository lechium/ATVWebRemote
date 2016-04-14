//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

#import "PBUserNotificationViewControllerDelegate.h"
#import "TVSUserNotificationDelegate.h"

@class NSArray, NSMutableDictionary, NSString;

@interface PBUserNotificationHandler : NSObject <PBUserNotificationViewControllerDelegate, TVSUserNotificationDelegate>
{
    NSMutableDictionary *_displayedViewControllers;	// 8 = 0x8
    NSArray *_allowedSources;	// 16 = 0x10
}

@property(copy, nonatomic) NSArray *allowedSources; // @synthesize allowedSources=_allowedSources;
- (void).cxx_destruct;	// IMP=0x00000001000047ec
- (void)_performRestrictionsPasscodeValidationForNotification:(id)arg1;	// IMP=0x0000000100004738
- (void)_performRestrictionsEnabledCheckForNotification:(id)arg1;	// IMP=0x00000001000046cc
- (void)_dismissViewController:(id)arg1;	// IMP=0x00000001000044c0
- (void)didCancelUserNotificationViewController:(id)arg1;	// IMP=0x0000000100004440
- (void)userNotificationViewController:(id)arg1 didSelectButtonIndex:(unsigned long long)arg2;	// IMP=0x0000000100004318
- (id)_newViewControllerForNotification:(id)arg1;	// IMP=0x00000001000041e0
- (void)userNotificationCenterDidCancelCFNotification:(id)arg1;	// IMP=0x0000000100004134
- (void)userNotificationCenterDidReceiveCFNotification:(id)arg1;	// IMP=0x0000000100003c9c
- (id)init;	// IMP=0x0000000100003c18

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end
