//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "UIViewController.h"

#import "PBUserNotificationViewController.h"
#import "TextEntryButtonViewDelegate.h"
#import "UIGestureRecognizerDelegate.h"

@class NSMutableArray, NSString, TVSCFUserNotification, TVSStateMachine, UITapGestureRecognizer;

@interface PBUserNotificationTextEntryViewController : UIViewController <UIGestureRecognizerDelegate, TextEntryButtonViewDelegate, PBUserNotificationViewController>
{
    TVSCFUserNotification *_notification;	// 8 = 0x8
    id <PBUserNotificationViewControllerDelegate> _delegate;	// 16 = 0x10
    UIViewController *_childViewController;	// 24 = 0x18
    UITapGestureRecognizer *_menuRecognizer;	// 32 = 0x20
    TVSStateMachine *_stateMachine;	// 40 = 0x28
    long long _currentTextField;	// 48 = 0x30
    NSMutableArray *_userValues;	// 56 = 0x38
}

@property(retain, nonatomic) NSMutableArray *userValues; // @synthesize userValues=_userValues;
@property(nonatomic) long long currentTextField; // @synthesize currentTextField=_currentTextField;
@property(retain, nonatomic) TVSStateMachine *stateMachine; // @synthesize stateMachine=_stateMachine;
@property(retain, nonatomic) UITapGestureRecognizer *menuRecognizer; // @synthesize menuRecognizer=_menuRecognizer;
@property(retain, nonatomic) UIViewController *childViewController; // @synthesize childViewController=_childViewController;
@property(nonatomic) __weak id <PBUserNotificationViewControllerDelegate> delegate; // @synthesize delegate=_delegate;
@property(retain, nonatomic) TVSCFUserNotification *notification; // @synthesize notification=_notification;
- (void).cxx_destruct;	// IMP=0x000000010000efbc
- (id)_messageStringAttributes;	// IMP=0x000000010000ecb8
- (id)_titleStringAttributes;	// IMP=0x000000010000eb38
- (void)_menuButtonPressed:(id)arg1;	// IMP=0x000000010000ead4
- (void)buttonView:(id)arg1 didSelectButton:(id)arg2 atIndex:(long long)arg3;	// IMP=0x000000010000e9fc
- (id)textField;	// IMP=0x000000010000e960
- (void)_showChildViewController:(id)arg1;	// IMP=0x000000010000e7e0
- (id)_buttonsForTextField:(long long)arg1;	// IMP=0x000000010000e3f8
- (void)_showTextEntryViewControllerForTextField:(long long)arg1;	// IMP=0x000000010000de64
- (void)_configureStateMachine;	// IMP=0x000000010000d654
- (void)viewDidAppear:(_Bool)arg1;	// IMP=0x000000010000d5f0
- (void)loadView;	// IMP=0x000000010000d468
- (id)init;	// IMP=0x000000010000d2f4
- (id)initWithNibName:(id)arg1 bundle:(id)arg2;	// IMP=0x000000010000d268

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end
