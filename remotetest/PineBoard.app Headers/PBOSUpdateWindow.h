//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "PBWindow.h"

@class TVOSUpdateViewController;

@interface PBOSUpdateWindow : PBWindow
{
    TVOSUpdateViewController *_controller;	// 8 = 0x8
}

- (void).cxx_destruct;	// IMP=0x000000010009b34c
- (_Bool)_ignoresHitTest;	// IMP=0x000000010009b344
- (void)didEncounterSlowUpdate;	// IMP=0x000000010009b2dc
- (void)setProgressPercentage:(float)arg1;	// IMP=0x000000010009b2c4
- (id)initWithFrame:(struct CGRect)arg1;	// IMP=0x000000010009b1c8

@end
