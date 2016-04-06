//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "_UIRemoteViewController.h"

#import "PBSViewServiceInterface.h"

@class NSMutableArray, NSString;

@interface PBRemoteViewController : _UIRemoteViewController <PBSViewServiceInterface>
{
    _Bool _dismissalInProgressFlag;	// 8 = 0x8
    NSMutableArray *_pendingDismissalCompletionBlocks;	// 16 = 0x10
    CDUnknownBlockType _dismissResultHandler;	// 24 = 0x18
}

+ (id)exportedInterface;	// IMP=0x00000001000911f8
+ (id)serviceViewControllerInterface;	// IMP=0x0000000100091094
@property(copy, nonatomic) CDUnknownBlockType dismissResultHandler; // @synthesize dismissResultHandler=_dismissResultHandler;
- (void).cxx_destruct;	// IMP=0x000000010009144c
- (void)_parentViewControllerDismissAnimated:(_Bool)arg1;	// IMP=0x0000000100091004
- (void)viewServiceDidTerminateWithError:(id)arg1;	// IMP=0x0000000100090ff4
- (void)dismissWithResult:(id)arg1;	// IMP=0x0000000100090df0
- (void)dismissViewControllerAnimated:(_Bool)arg1 completion:(CDUnknownBlockType)arg2;	// IMP=0x0000000100090908
- (void)_sendViewServiceEndPresentationWithOptions:(id)arg1 completion:(CDUnknownBlockType)arg2;	// IMP=0x00000001000904ec
- (void)prepareViewServiceWithOptions:(id)arg1;	// IMP=0x0000000100090480

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end
