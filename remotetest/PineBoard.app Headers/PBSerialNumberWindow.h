//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "UIWindow.h"

@class UILabel;

@interface PBSerialNumberWindow : UIWindow
{
    UILabel *_deviceSerialNumberLabel;	// 8 = 0x8
    UILabel *_remoteSerialNumberLabel;	// 16 = 0x10
}

- (void).cxx_destruct;	// IMP=0x00000001000821e4
- (void)_updateConnectedPeripheralSerialNumber;	// IMP=0x00000001000820f0
- (void)_peripheralStateDidChangeNotification:(id)arg1;	// IMP=0x00000001000820e4
- (void)layoutSubviews;	// IMP=0x0000000100081f88
- (_Bool)_ignoresHitTest;	// IMP=0x0000000100081f80
- (_Bool)_canBecomeKeyWindow;	// IMP=0x0000000100081f78
- (void)dealloc;	// IMP=0x0000000100081eb4
- (id)initWithFrame:(struct CGRect)arg1;	// IMP=0x0000000100081a28

@end
