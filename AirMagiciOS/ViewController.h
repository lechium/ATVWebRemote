//
//  ViewController.h
//  AirMagiciOS
//
//  Created by Kevin Bradley on 4/11/16.
//  Copyright © 2016 nito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATVDeviceController.h"

@interface ViewController : UIViewController <ATVDeviceControllerDelegate>
{
    NSString *repeatingCommand;
    NSTimer *repeatingTimer;
}
@property (strong, nonatomic) NSArray *services;
@property (nonatomic, weak) IBOutlet UIButton *selectedATV;
@property (nonatomic, weak) IBOutlet UILabel *ipAddressLabel;
@property (nonatomic, weak) IBOutlet UILabel *apiVLabel;
@property (nonatomic, weak) IBOutlet UILabel *iosVLabel;
@property (nonatomic, weak) IBOutlet UILabel *amVersion;

@end

