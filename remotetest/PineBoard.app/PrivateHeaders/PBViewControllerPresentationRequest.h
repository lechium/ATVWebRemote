//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

@class NSDictionary, UIViewController;

@interface PBViewControllerPresentationRequest : NSObject
{
    UIViewController *_viewController;	// 8 = 0x8
    NSDictionary *_options;	// 16 = 0x10
    double _timeoutInSeconds;	// 24 = 0x18
}

+ (id)requestWithViewController:(id)arg1;	// IMP=0x000000010002aa2c
@property(nonatomic) double timeoutInSeconds; // @synthesize timeoutInSeconds=_timeoutInSeconds;
@property(copy, nonatomic) NSDictionary *options; // @synthesize options=_options;
@property(readonly, nonatomic) UIViewController *viewController; // @synthesize viewController=_viewController;
- (void).cxx_destruct;	// IMP=0x000000010002aae8

@end
