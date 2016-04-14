//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "FBTransaction.h"

@class FBApplicationUpdateScenesTransaction, PBAppTransitionContext;

@interface PBAppTransitionTransaction : FBTransaction
{
    PBAppTransitionContext *_context;	// 8 = 0x8
    FBApplicationUpdateScenesTransaction *_updateScenesTransaction;	// 16 = 0x10
}

@property(retain, nonatomic) FBApplicationUpdateScenesTransaction *updateScenesTransaction; // @synthesize updateScenesTransaction=_updateScenesTransaction;
@property(readonly, nonatomic) PBAppTransitionContext *context; // @synthesize context=_context;
- (void).cxx_destruct;	// IMP=0x00000001000890ec
- (void)_handleUpdateScenesTransactionDidComplete;	// IMP=0x0000000100088fc4
- (void)_childTransactionDidComplete:(id)arg1;	// IMP=0x0000000100088f20
- (void)_willFailWithReason:(id)arg1;	// IMP=0x0000000100088ee8
- (void)_willComplete;	// IMP=0x0000000100088e34
- (_Bool)_shouldFailForChildTransaction:(id)arg1;	// IMP=0x0000000100088e2c
- (void)beginForegroundTransition;	// IMP=0x0000000100088db0
- (id)initWithTransaction:(id)arg1 context:(id)arg2;	// IMP=0x0000000100088ccc
- (id)init;	// IMP=0x0000000100088cb4

@end
