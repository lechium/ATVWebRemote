//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

@class FBUIApplicationSceneDeactivationAssertion, NSMutableArray, NSObject<OS_dispatch_source>, PBOSUpdateWindow, PBRemoteBulletinViewController, PBWindow, UIViewController, _PBWindowManagerAppTransitionHelper;

@interface PBWindowManager : NSObject
{
    _Bool _hasScheduledPresentDialog;	// 8 = 0x8
    _Bool _hasScheduledPresentBulletin;	// 9 = 0x9
    _Bool _siriIsFullscreen;	// 10 = 0xa
    _Bool _dialogHiddenForScreenSaver;	// 11 = 0xb
    PBRemoteBulletinViewController *_presentedBulletinViewController;	// 16 = 0x10
    PBOSUpdateWindow *_softwareUpdateWindow;	// 24 = 0x18
    PBWindow *_criticalAlertWindow;	// 32 = 0x20
    PBWindow *_airPlayWindow;	// 40 = 0x28
    PBWindow *_bulletinWindow;	// 48 = 0x30
    PBWindow *_playbackLaunchShroudWindow;	// 56 = 0x38
    PBWindow *_dialogWindow;	// 64 = 0x40
    PBWindow *_siriWindow;	// 72 = 0x48
    PBWindow *_nowPlayingWindow;	// 80 = 0x50
    PBWindow *_restrictionPINWindow;	// 88 = 0x58
    PBWindow *_screenSaverWindow;	// 96 = 0x60
    PBWindow *_appSwitcherWindow;	// 104 = 0x68
    PBWindow *_appTransitionWindow;	// 112 = 0x70
    PBWindow *_wallpaperWindow;	// 120 = 0x78
    PBWindow *_radioAdWindow;	// 128 = 0x80
    PBWindow *_blackScreenRecoveryWindow;	// 136 = 0x88
    UIViewController *_presentedScreenSaverViewController;	// 144 = 0x90
    NSObject<OS_dispatch_source> *_bulletinDismissalTimer;	// 152 = 0x98
    NSMutableArray *_pendingDialogRequests;	// 160 = 0xa0
    NSMutableArray *_pendingBulletinRequests;	// 168 = 0xa8
    NSMutableArray *_pendingTransitionTransactions;	// 176 = 0xb0
    FBUIApplicationSceneDeactivationAssertion *_airPlayAssertion;	// 184 = 0xb8
    FBUIApplicationSceneDeactivationAssertion *_appSwitcherAssertion;	// 192 = 0xc0
    FBUIApplicationSceneDeactivationAssertion *_dialogAssertion;	// 200 = 0xc8
    FBUIApplicationSceneDeactivationAssertion *_screenSaverAssertion;	// 208 = 0xd0
    FBUIApplicationSceneDeactivationAssertion *_siriAssertion;	// 216 = 0xd8
    FBUIApplicationSceneDeactivationAssertion *_siriFullscreenAssertion;	// 224 = 0xe0
    _PBWindowManagerAppTransitionHelper *_appTransitionHelper;	// 232 = 0xe8
}

+ (void)_registerWindowNotificationHandlers;	// IMP=0x0000000100029d38
+ (id)_rootNavigationViewControllerForWindow:(id)arg1;	// IMP=0x0000000100029cb8
+ (id)sharedInstance;	// IMP=0x0000000100021de8
@property(retain, nonatomic) _PBWindowManagerAppTransitionHelper *appTransitionHelper; // @synthesize appTransitionHelper=_appTransitionHelper;
@property(retain, nonatomic) FBUIApplicationSceneDeactivationAssertion *siriFullscreenAssertion; // @synthesize siriFullscreenAssertion=_siriFullscreenAssertion;
@property(retain, nonatomic) FBUIApplicationSceneDeactivationAssertion *siriAssertion; // @synthesize siriAssertion=_siriAssertion;
@property(retain, nonatomic) FBUIApplicationSceneDeactivationAssertion *screenSaverAssertion; // @synthesize screenSaverAssertion=_screenSaverAssertion;
@property(retain, nonatomic) FBUIApplicationSceneDeactivationAssertion *dialogAssertion; // @synthesize dialogAssertion=_dialogAssertion;
@property(retain, nonatomic) FBUIApplicationSceneDeactivationAssertion *appSwitcherAssertion; // @synthesize appSwitcherAssertion=_appSwitcherAssertion;
@property(retain, nonatomic) FBUIApplicationSceneDeactivationAssertion *airPlayAssertion; // @synthesize airPlayAssertion=_airPlayAssertion;
@property(readonly, nonatomic) NSMutableArray *pendingTransitionTransactions; // @synthesize pendingTransitionTransactions=_pendingTransitionTransactions;
@property(readonly, nonatomic) NSMutableArray *pendingBulletinRequests; // @synthesize pendingBulletinRequests=_pendingBulletinRequests;
@property(readonly, nonatomic) NSMutableArray *pendingDialogRequests; // @synthesize pendingDialogRequests=_pendingDialogRequests;
@property(readonly, nonatomic) NSObject<OS_dispatch_source> *bulletinDismissalTimer; // @synthesize bulletinDismissalTimer=_bulletinDismissalTimer;
@property(nonatomic) _Bool dialogHiddenForScreenSaver; // @synthesize dialogHiddenForScreenSaver=_dialogHiddenForScreenSaver;
@property(retain, nonatomic) UIViewController *presentedScreenSaverViewController; // @synthesize presentedScreenSaverViewController=_presentedScreenSaverViewController;
@property(retain, nonatomic) PBWindow *blackScreenRecoveryWindow; // @synthesize blackScreenRecoveryWindow=_blackScreenRecoveryWindow;
@property(retain, nonatomic) PBWindow *radioAdWindow; // @synthesize radioAdWindow=_radioAdWindow;
@property(retain, nonatomic) PBWindow *wallpaperWindow; // @synthesize wallpaperWindow=_wallpaperWindow;
@property(retain, nonatomic) PBWindow *appTransitionWindow; // @synthesize appTransitionWindow=_appTransitionWindow;
@property(retain, nonatomic) PBWindow *appSwitcherWindow; // @synthesize appSwitcherWindow=_appSwitcherWindow;
@property(retain, nonatomic) PBWindow *screenSaverWindow; // @synthesize screenSaverWindow=_screenSaverWindow;
@property(retain, nonatomic) PBWindow *restrictionPINWindow; // @synthesize restrictionPINWindow=_restrictionPINWindow;
@property(retain, nonatomic) PBWindow *nowPlayingWindow; // @synthesize nowPlayingWindow=_nowPlayingWindow;
@property(retain, nonatomic) PBWindow *siriWindow; // @synthesize siriWindow=_siriWindow;
@property(retain, nonatomic) PBWindow *dialogWindow; // @synthesize dialogWindow=_dialogWindow;
@property(retain, nonatomic) PBWindow *playbackLaunchShroudWindow; // @synthesize playbackLaunchShroudWindow=_playbackLaunchShroudWindow;
@property(retain, nonatomic) PBWindow *bulletinWindow; // @synthesize bulletinWindow=_bulletinWindow;
@property(retain, nonatomic) PBWindow *airPlayWindow; // @synthesize airPlayWindow=_airPlayWindow;
@property(retain, nonatomic) PBWindow *criticalAlertWindow; // @synthesize criticalAlertWindow=_criticalAlertWindow;
@property(retain, nonatomic) PBOSUpdateWindow *softwareUpdateWindow; // @synthesize softwareUpdateWindow=_softwareUpdateWindow;
@property(nonatomic) _Bool siriIsFullscreen; // @synthesize siriIsFullscreen=_siriIsFullscreen;
@property(retain, nonatomic) PBRemoteBulletinViewController *presentedBulletinViewController; // @synthesize presentedBulletinViewController=_presentedBulletinViewController;
- (void).cxx_destruct;	// IMP=0x000000010002a7e4
- (void)_updateKeyWindow;	// IMP=0x0000000100029c78
- (id)_highestPriorityWindow;	// IMP=0x0000000100029550
- (id)_lazyWallpaperWindow;	// IMP=0x0000000100029454
- (id)_lazyAppTransitionWindow;	// IMP=0x0000000100029350
- (id)_lazyAppSwitcherWindow;	// IMP=0x00000001000291bc
- (id)_lazyBulletinWindow;	// IMP=0x00000001000290d4
- (id)_lazyDialogWindow;	// IMP=0x0000000100028ee0
- (id)_lazySiriWindow;	// IMP=0x0000000100028d44
- (id)_lazyBlackScreenRecoveryWindow;	// IMP=0x0000000100028ae0
- (id)_lazyRadioAdWindow;	// IMP=0x0000000100028884
- (id)_lazyRestrictionPINWindow;	// IMP=0x00000001000285f8
- (id)_lazyNowPlayingWindow;	// IMP=0x0000000100028388
- (id)_lazyAirPlayWindow;	// IMP=0x0000000100028174
- (id)_lazyScreenSaverWindow;	// IMP=0x0000000100027f1c
- (id)_lazyPlaybackLaunchShroudWindow;	// IMP=0x0000000100027d74
- (void)dismissWallpaperWindow;	// IMP=0x0000000100027d30
- (void)presentWallpaperWindow;	// IMP=0x0000000100027c50
- (void)_dismissAppTransitionWindow:(id)arg1;	// IMP=0x0000000100027b8c
- (void)_dismissWindowsForAppLaunch:(id)arg1;	// IMP=0x0000000100027afc
- (_Bool)cancelCurrentAppTransition;	// IMP=0x0000000100027a64
- (void)_cancelPendingTransitionTransactions;	// IMP=0x0000000100027908
- (void)_beginPendingTransitionTransaction;	// IMP=0x00000001000274ec
- (void)_beginAppTransitionTransaction:(id)arg1 withCompletionHandler:(CDUnknownBlockType)arg2;	// IMP=0x0000000100026eb4
- (void)beginAppTransitionWithTransaction:(id)arg1;	// IMP=0x0000000100026a2c
@property(readonly, nonatomic) _Bool presentingAppTransition;
- (void)_dismissAppSwitcherWindow;	// IMP=0x00000001000268ec
- (_Bool)_shouldActivateAppSwitcher;	// IMP=0x0000000100026718
- (_Bool)dismissAppSwitcher;	// IMP=0x000000010002666c
- (_Bool)presentAppSwitcher;	// IMP=0x00000001000265a8
@property(readonly, nonatomic) _Bool presentingAppSwitcher;
- (void)_dismissAirPlayWindow;	// IMP=0x00000001000264a8
- (_Bool)dismissAirPlayWindow;	// IMP=0x00000001000263f4
- (void)presentAirPlayViewController:(id)arg1;	// IMP=0x0000000100026278
- (_Bool)presentingAirPlay;	// IMP=0x0000000100026210
- (void)dismissThermalWarningWindow;	// IMP=0x000000010002619c
- (void)presentThermalWarningWindow;	// IMP=0x00000001000260c8
- (void)dismissSoftwareUpdateWindow;	// IMP=0x0000000100026054
- (void)presentSoftwareUpdateWindow;	// IMP=0x0000000100025f50
- (void)_cancelBulletinTimer;	// IMP=0x0000000100025f0c
- (void)_presentNextBulletin;	// IMP=0x0000000100025aec
- (void)_schedulePresentBulletin;	// IMP=0x00000001000259d0
- (void)_enqueueBulletinPresentationRequest:(id)arg1;	// IMP=0x0000000100025924
- (_Bool)dismissBulletinWindow;	// IMP=0x000000010002583c
- (_Bool)dismissBulletinViewController:(id)arg1;	// IMP=0x000000010002568c
- (void)updateBulletinViewControllerTimeout:(id)arg1 timeoutInSeconds:(double)arg2;	// IMP=0x00000001000255a8
- (void)presentBulletinViewController:(id)arg1 withTimeoutInSeconds:(double)arg2;	// IMP=0x0000000100025538
- (void)_presentNextDialog;	// IMP=0x0000000100024f84
- (void)_schedulePresentDialog;	// IMP=0x0000000100024eb0
- (void)_enqueueDialogPresentationRequest:(id)arg1;	// IMP=0x0000000100024e14
- (_Bool)_dismissDialogWindow;	// IMP=0x0000000100024d4c
- (_Bool)_dismissDialogViewController:(id)arg1;	// IMP=0x0000000100024b9c
- (_Bool)hideDialogWindow;	// IMP=0x00000001000249ac
- (_Bool)unhideDialogWindow;	// IMP=0x0000000100024834
- (void)presentDialogViewController:(id)arg1 options:(id)arg2;	// IMP=0x0000000100024774
- (void)presentDialogViewController:(id)arg1;	// IMP=0x0000000100024764
- (_Bool)dismissSiriWindow;	// IMP=0x0000000100024540
- (void)presentSiriViewController:(id)arg1;	// IMP=0x00000001000243d4
@property(readonly, nonatomic) _Bool presentingSiriSession;
- (void)_dismissBlackScreenRecoveryWindow:(id)arg1;	// IMP=0x00000001000242d4
- (_Bool)dismissBlackScreenRecoveryWindow;	// IMP=0x000000010002421c
- (_Bool)presentBlackScreenRecoveryViewController;	// IMP=0x0000000100024078
- (void)_dismissRadioAdWindow:(id)arg1;	// IMP=0x0000000100023fe0
- (_Bool)dismissRadioAdWindow;	// IMP=0x0000000100023f28
- (_Bool)presentRadioAdViewController:(id)arg1;	// IMP=0x0000000100023e74
- (void)_dismissRestrictionPINWindow:(id)arg1;	// IMP=0x0000000100023ddc
- (_Bool)dismissRestrictionPINWindow;	// IMP=0x0000000100023d24
- (void)presentRestrictionPINWindow:(CDUnknownBlockType)arg1;	// IMP=0x00000001000239dc
@property(readonly, nonatomic) _Bool presentingPINRequest;
- (void)_dismissNowPlayingWindow:(id)arg1;	// IMP=0x00000001000237e8
- (_Bool)dismissNowPlayingWindow;	// IMP=0x0000000100023730
- (_Bool)presentNowPlayingViewController:(id)arg1;	// IMP=0x0000000100023640
@property(readonly, nonatomic) _Bool presentingNowPlaying;
- (_Bool)dismissScreenSaverWindowWithCompletionBlock:(CDUnknownBlockType)arg1;	// IMP=0x000000010002345c
- (void)_destroyScreenSaverWindow:(id)arg1;	// IMP=0x0000000100023370
- (_Bool)_dismissScreenSaverWindow;	// IMP=0x0000000100022ba4
- (void)presentScreenSaverViewController:(id)arg1 userInitiated:(_Bool)arg2 withCompletion:(CDUnknownBlockType)arg3;	// IMP=0x0000000100022484
- (_Bool)shouldForwardSystemAppEvent;	// IMP=0x0000000100021fb4
- (id)init;	// IMP=0x0000000100021ebc

@end

