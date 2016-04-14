//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

#import "FBUIApplicationServiceDelegate.h"
#import "PBSAppDepotProxyProtocol.h"

@class NSArray, NSDictionary, NSMutableDictionary, NSString;

@interface PBAppDepot : NSObject <FBUIApplicationServiceDelegate, PBSAppDepotProxyProtocol>
{
    _Bool _needsReload;	// 8 = 0x8
    _Bool _needsNotifyAppStateDidChange;	// 9 = 0x9
    _Bool _enforceProvisioningOnSystemAppsEnabled;	// 10 = 0xa
    NSMutableDictionary *_internalAppState;	// 16 = 0x10
    NSArray *_internalProvisionedAppIdentifiers;	// 24 = 0x18
}

+ (id)_appStateURL;	// IMP=0x0000000100047e6c
+ (id)sharedInstance;	// IMP=0x000000010004502c
+ (void)setupAppDepot;	// IMP=0x0000000100044e58
@property(nonatomic) _Bool enforceProvisioningOnSystemAppsEnabled; // @synthesize enforceProvisioningOnSystemAppsEnabled=_enforceProvisioningOnSystemAppsEnabled;
@property(nonatomic) _Bool needsNotifyAppStateDidChange; // @synthesize needsNotifyAppStateDidChange=_needsNotifyAppStateDidChange;
@property(copy, nonatomic) NSArray *internalProvisionedAppIdentifiers; // @synthesize internalProvisionedAppIdentifiers=_internalProvisionedAppIdentifiers;
@property(retain, nonatomic) NSMutableDictionary *internalAppState; // @synthesize internalAppState=_internalAppState;
- (void).cxx_destruct;	// IMP=0x00000001000485e0
- (id)_reversedDictionaryWithDictionary:(id)arg1;	// IMP=0x000000010004839c
- (id)_systemAppBundleIdentifiers;	// IMP=0x0000000100048130
- (void)_save;	// IMP=0x0000000100047cd0
- (void)_notifyAppStateDidChange;	// IMP=0x0000000100047bc0
- (void)_setNeedsNotifyAppStateDidChange;	// IMP=0x0000000100047ae8
- (void)_updateAppInfo;	// IMP=0x0000000100047294
- (void)setNeedsReload;	// IMP=0x00000001000471c8
- (void)_appStateDidChange:(id)arg1;	// IMP=0x00000001000471bc
- (void)_removeAppStateForIdentifier:(id)arg1;	// IMP=0x0000000100047128
- (id)_addAppStateForIdentifier:(id)arg1;	// IMP=0x000000010004705c
- (id)_appStateForIdentifier:(id)arg1;	// IMP=0x0000000100046fd4
- (void)clearUserNotificationsForBundleIdentifier:(id)arg1;	// IMP=0x0000000100046e64
- (void)enqueueUserNotification:(id)arg1 forBundleIdentifier:(id)arg2;	// IMP=0x0000000100046cb4
- (void)decrementCacheDeletingForBundleIdentifier:(id)arg1;	// IMP=0x0000000100046b54
- (void)incrementCacheDeletingForBundleIdentifier:(id)arg1;	// IMP=0x00000001000469f4
- (void)setRecentlyUpdated:(_Bool)arg1 forBundleIdentifier:(id)arg2;	// IMP=0x0000000100046888
- (void)applicationService:(id)arg1 suspendApplicationWithBundleIdentifier:(id)arg2;	// IMP=0x0000000100046810
- (void)applicationService:(id)arg1 getBadgeValueForBundleIdentifier:(id)arg2 withCompletion:(CDUnknownBlockType)arg3;	// IMP=0x00000001000464d0
- (void)applicationService:(id)arg1 setBadgeValue:(id)arg2 forBundleIdentifier:(id)arg3;	// IMP=0x00000001000462fc
- (void)removeAppStateForApplicationProxies:(id)arg1;	// IMP=0x0000000100046080
- (void)addAppStateForApplicationProxies:(id)arg1;	// IMP=0x0000000100045cb8
@property(readonly, copy) NSArray *provisionedAppIdentifiers;
@property(readonly, copy) NSDictionary *appState;
- (id)_appDepotQueue;	// IMP=0x0000000100045870
- (void)dealloc;	// IMP=0x00000001000457bc
- (id)init;	// IMP=0x0000000100045080

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end
