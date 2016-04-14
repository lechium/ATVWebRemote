//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

#import "PBSBulletinServiceInterface.h"

@class NSMapTable, NSMutableDictionary, NSString, PBSystemServiceConnection;

@interface PBBulletinService : NSObject <PBSBulletinServiceInterface>
{
    PBSystemServiceConnection *_remoteConnection;	// 8 = 0x8
    NSMapTable *_viewControllersByBulletin;	// 16 = 0x10
    NSMutableDictionary *_pendingBulletinsByRequestID;	// 24 = 0x18
    id <PBSBulletinServiceDelegate> _delegateProxy;	// 32 = 0x20
}

+ (void)_setBulletinService:(id)arg1 forViewController:(id)arg2;	// IMP=0x0000000100036ee8
+ (id)_bulletinServiceForViewController:(id)arg1;	// IMP=0x0000000100036e38
+ (void)applicationTerminateBulletinViewController:(id)arg1;	// IMP=0x00000001000353c0
+ (void)applicationRetireBulletinViewController:(id)arg1;	// IMP=0x0000000100035270
+ (void)applicationDismissBulletinViewController:(id)arg1;	// IMP=0x0000000100035120
+ (void)applicationActivateBulletinViewController:(id)arg1;	// IMP=0x0000000100034fd0
+ (void)windowManagerWillPresentBulletinViewController:(id)arg1;	// IMP=0x0000000100034e84
+ (id)_bulletinServicesByViewController;	// IMP=0x000000010003480c
@property(retain, nonatomic) id <PBSBulletinServiceDelegate> delegateProxy; // @synthesize delegateProxy=_delegateProxy;
@property(readonly, nonatomic) NSMutableDictionary *pendingBulletinsByRequestID; // @synthesize pendingBulletinsByRequestID=_pendingBulletinsByRequestID;
@property(readonly, nonatomic) NSMapTable *viewControllersByBulletin; // @synthesize viewControllersByBulletin=_viewControllersByBulletin;
@property(readonly, nonatomic) PBSystemServiceConnection *remoteConnection; // @synthesize remoteConnection=_remoteConnection;
- (void).cxx_destruct;	// IMP=0x0000000100037014
- (void)_setViewController:(id)arg1 forBulletin:(id)arg2;	// IMP=0x0000000100036d60
- (id)_viewControllerForBulletin:(id)arg1;	// IMP=0x0000000100036cb0
- (id)_bulletinForViewController:(id)arg1;	// IMP=0x0000000100036ae4
- (_Bool)_bulletinIsPending:(id)arg1;	// IMP=0x0000000100036a14
- (void)_updateRequestForBulletin:(id)arg1 withBulletin:(id)arg2;	// IMP=0x00000001000367f8
- (id)_bulletinForRequestID:(unsigned long long)arg1;	// IMP=0x0000000100036730
- (void)_setBulletin:(id)arg1 forRequestID:(unsigned long long)arg2;	// IMP=0x0000000100036608
- (void)_prepareToPresentViewController:(id)arg1;	// IMP=0x000000010003659c
- (void)_handleApplicationDismissalForViewController:(id)arg1 withReason:(unsigned long long)arg2;	// IMP=0x0000000100036160
- (void)_completeWithBulletin:(id)arg1 success:(_Bool)arg2 error:(id)arg3 completion:(CDUnknownBlockType)arg4;	// IMP=0x0000000100036098
- (void)setDelegate:(id)arg1;	// IMP=0x000000010003608c
- (void)dismissBulletin:(id)arg1;	// IMP=0x000000010003603c
- (id)updateBulletin:(id)arg1 withMessage:(id)arg2 withCompletion:(CDUnknownBlockType)arg3;	// IMP=0x0000000100035cc8
- (void)presentBulletin:(id)arg1 withCompletion:(CDUnknownBlockType)arg2;	// IMP=0x0000000100035510
- (void)invalidate;	// IMP=0x00000001000349b8
- (id)initWithRemoteConnection:(id)arg1;	// IMP=0x00000001000348b0
- (id)init;	// IMP=0x0000000100034898

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end
