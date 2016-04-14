//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

#import "PBSystemServiceInterface.h"

@class NSString, NSXPCConnection, PBAirPlayService, PBBulletinService, PBDiagnosticLogsService, PBOSUpdateService;

@interface PBSystemServiceConnection : NSObject <PBSystemServiceInterface>
{
    PBBulletinService *_bulletinService;	// 8 = 0x8
    PBDiagnosticLogsService *_diagnosticLogsService;	// 16 = 0x10
    PBOSUpdateService *_osUpdateService;	// 24 = 0x18
    PBAirPlayService *_airPlayService;	// 32 = 0x20
    NSXPCConnection *_remoteConnection;	// 40 = 0x28
    NSString *_clientBundleIdentifier;	// 48 = 0x30
    id <PBSystemServiceNowPlayingDelegate> _nowPlayingPresentationDelegate;	// 56 = 0x38
}

+ (id)systemServiceConnectionForProcessIdentifier:(int)arg1;	// IMP=0x0000000100071110
+ (void)_registerConnection:(id)arg1;	// IMP=0x0000000100070f78
+ (id)_activeConnectionsByProcessIdentifier;	// IMP=0x0000000100070ef8
@property(retain, nonatomic) id <PBSystemServiceNowPlayingDelegate> nowPlayingPresentationDelegate; // @synthesize nowPlayingPresentationDelegate=_nowPlayingPresentationDelegate;
@property(readonly, copy, nonatomic) NSString *clientBundleIdentifier; // @synthesize clientBundleIdentifier=_clientBundleIdentifier;
@property(readonly, nonatomic) NSXPCConnection *remoteConnection; // @synthesize remoteConnection=_remoteConnection;
- (void).cxx_destruct;	// IMP=0x00000001000762f4
- (id)_clientBundleIdentifierFromConnection;	// IMP=0x0000000100076218
- (_Bool)sendMessagePresentNowPlayingUI;	// IMP=0x00000001000761d0
- (void)prepareForKioskAppTransitionWithCompletion:(CDUnknownBlockType)arg1;	// IMP=0x0000000100076140
- (void)sharedAppStateDidChange;	// IMP=0x00000001000760dc
- (void)startIdleScreenAppTransitionForType:(long long)arg1 animationDuration:(double)arg2 animationFence:(id)arg3 currentTime:(double)arg4;	// IMP=0x000000010007602c
- (void)startKioskAppTransitionForType:(long long)arg1 animationDuration:(double)arg2 animationFence:(id)arg3 currentTime:(double)arg4;	// IMP=0x0000000100075f7c
- (void)kioskAppPurgeTopShelfContentForApplicationIdentifiers:(id)arg1;	// IMP=0x0000000100075eec
- (void)kioskAppHandleHomeButtonWithCompletion:(CDUnknownBlockType)arg1;	// IMP=0x0000000100075e5c
- (void)listen;	// IMP=0x0000000100075e58
- (void)getAirPlayServiceProxyWithReply:(CDUnknownBlockType)arg1;	// IMP=0x0000000100075be8
- (void)getOSUpdateServiceProxyWithReply:(CDUnknownBlockType)arg1;	// IMP=0x0000000100075978
- (void)getDiagnosticLogsServiceProxyWithReply:(CDUnknownBlockType)arg1;	// IMP=0x0000000100075708
- (void)getBulletinServiceProxyWithReply:(CDUnknownBlockType)arg1;	// IMP=0x0000000100075498
- (void)endpointForProviderType:(id)arg1 withIdentifier:(id)arg2 responseBlock:(CDUnknownBlockType)arg3;	// IMP=0x00000001000753e8
- (void)registerServiceProviderEndpoint:(id)arg1 forProviderType:(id)arg2;	// IMP=0x0000000100075324
- (void)cancelScheduledAppActivation;	// IMP=0x0000000100075240
- (void)activateAppIfPlayingMusicAfterIdleTime:(double)arg1 openURL:(id)arg2;	// IMP=0x00000001000750bc
- (void)performBluetoothRemoteFirmwareCheck;	// IMP=0x0000000100074ef8
- (void)pairAppleRemote:(_Bool)arg1 withReply:(CDUnknownBlockType)arg2;	// IMP=0x0000000100074c50
- (void)fetchPairedAppleRemoteStateWithReply:(CDUnknownBlockType)arg1;	// IMP=0x00000001000749d0
- (void)fetchProvisionAppIdentifiersWithReply:(CDUnknownBlockType)arg1;	// IMP=0x00000001000747c4
- (void)fetchSharedAppStateWithReply:(CDUnknownBlockType)arg1;	// IMP=0x00000001000745b8
- (void)launchKioskApp;	// IMP=0x00000001000743d0
- (void)sendMenuButtonEvent;	// IMP=0x000000010007416c
- (void)performScreenActionWithName:(id)arg1 forItemIdentifier:(id)arg2 parameters:(id)arg3 reply:(CDUnknownBlockType)arg4;	// IMP=0x0000000100073aa4
- (void)setNextAssistantRecognitionStrings:(id)arg1;	// IMP=0x0000000100073840
- (void)setNextVoiceRecognitionAudioInputPaths:(id)arg1;	// IMP=0x00000001000735dc
- (void)topActiveOrActivatingApplicationIdentifierWithReply:(CDUnknownBlockType)arg1;	// IMP=0x0000000100073374
- (void)recentApplicationBundleIdentifiersWithReply:(CDUnknownBlockType)arg1;	// IMP=0x0000000100073168
- (void)purgeTopShelfContentForApplicationIdentifiers:(id)arg1;	// IMP=0x0000000100072f9c
- (void)setIgnoresAvailableDisplayModesChanges:(_Bool)arg1;	// IMP=0x0000000100072d24
- (void)setAirPlayActive:(_Bool)arg1;	// IMP=0x0000000100072b04
- (void)deactivateScreenSaver;	// IMP=0x00000001000728a0
- (void)activateScreenSaver;	// IMP=0x000000010007263c
- (void)sleepTimeoutWithReply:(CDUnknownBlockType)arg1;	// IMP=0x00000001000723a8
- (void)setSleepTimeout:(double)arg1;	// IMP=0x0000000100072128
- (void)reboot;	// IMP=0x0000000100071ec4
- (void)relaunch;	// IMP=0x0000000100071c60
- (void)relaunchBackboardd;	// IMP=0x0000000100071a70
- (void)wakeSystemForReason:(unsigned long long)arg1;	// IMP=0x00000001000717fc
- (void)sleepSystemForReason:(unsigned long long)arg1;	// IMP=0x0000000100071588
- (void)deactivateApplication;	// IMP=0x0000000100071534
- (void)registerNowPlayingDelegate:(id)arg1;	// IMP=0x0000000100071528
- (id)airPlayService;	// IMP=0x0000000100071518
- (id)osUpdateService;	// IMP=0x0000000100071508
- (id)diagnosticLogsService;	// IMP=0x00000001000714f8
- (void)invalidate;	// IMP=0x0000000100071218
- (void)resume;	// IMP=0x0000000100071200
- (void)dealloc;	// IMP=0x0000000100070e4c
- (id)init;	// IMP=0x0000000100070e34
- (id)initWithConnection:(id)arg1;	// IMP=0x00000001000708c8

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end
