//
//  ViewController.m
//  AirMagiciOS
//
//  Created by Kevin Bradley on 4/11/16.
//  Copyright © 2016 nito. All rights reserved.
//

#import "ViewController.h"
#import "ATVDeviceController.h"
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import "KxMenu.h"

@interface ViewController ()

@property (nonatomic, strong) ATVDeviceController *deviceController;

@end

@implementation ViewController

static NSString *appleTVAddress = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.deviceController = [[ATVDeviceController alloc] init];
    self.deviceController.delegate = self;
    [DEFAULTS setValue:@"atvjb.local" forKey:ATV_HOST];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)atvButtonSelected:(UIButton *)sender
{
    NSMutableArray *serviceArray = [NSMutableArray new];
    NSInteger index = 0;
    for (NSDictionary *service in self.services)
    {
        KxMenuItem *item = [KxMenuItem menuItem:service[@"hostname"] image:nil target:self action:@selector(menuItemAction:) index:index];
        [serviceArray addObject:item];
        index++;
        
    }
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:serviceArray];
}

- (void)menuItemAction:(id)sender
{
    //NSLog(@"sender: %lu", (long)[sender index]);
    [self selectDeviceAtIndex:[sender index]];
}

- (void)selectDeviceAtIndex:(NSInteger)theIndex
{
    NSDictionary *firstObject = self.services[theIndex];
    [DEFAULTS setObject:firstObject[@"fullIP"] forKey:ATV_HOST];
    [self.selectedATV setTitle:firstObject[@"hostname"] forState:UIControlStateNormal];
    self.ipAddressLabel.text = firstObject[@"fullIP"];
    self.apiVLabel.text = firstObject[@"apiversion"];
    self.iosVLabel.text = [NSString stringWithFormat:@"%@ (%@)", firstObject[@"osversion"], firstObject[@"osbuild"]];
}

- (void)servicesFound:(NSArray *)services
{
    self.services = services;
    [self selectDeviceAtIndex:0];
}

- (IBAction)touchUp:(id)sender;
{
    if (repeatingTimer !=nil)
    {
        if ([repeatingTimer isValid])
        {
            [repeatingTimer invalidate];
            repeatingTimer = nil;
            repeatingCommand = nil;
        }
    }
}

- (void)repeatAction:(id)sender
{
    if (repeatingCommand == nil)
    {
        return;
    }
    [self sendNavCommand:repeatingCommand];
}

- (void)startRepeatTimerWithAction:(NSString *)theAction
{
    [self sendNavCommand:theAction];
    repeatingCommand = theAction;
    repeatingTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(repeatAction:) userInfo:nil repeats:true];
}

- (IBAction)upAction:(id)sender
{
    [self startRepeatTimerWithAction:@"remoteCommand=up"];
}

- (IBAction)downAction:(id)sender
{
    [self startRepeatTimerWithAction:@"remoteCommand=down"];
}

- (IBAction)playAction:(id)sender
{
    [self sendNavCommand:@"remoteCommand=play"];
}


- (IBAction)selectAction:(id)sender
{
    [self sendNavCommand:@"remoteCommand=select"];
}

- (IBAction)leftAction:(id)sender
{
     [self startRepeatTimerWithAction:@"remoteCommand=left"];
   // [self sendNavCommand:@"remoteCommand=left"];
}

- (IBAction)rightAction:(id)sender
{
     [self startRepeatTimerWithAction:@"remoteCommand=right"];
    //[self sendNavCommand:@"remoteCommand=right"];
}

- (IBAction)menuAction:(id)sender
{
    [self sendNavCommand:@"remoteCommand=menu"];
}

- (IBAction)enterTextAction:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter text" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       
        [textField setReturnKeyType:UIReturnKeyDone];
    
        UIAlertAction *inputAndSubmitAction = [UIAlertAction
                                               actionWithTitle:@"Done"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action)
                                               {
                                                   UITextField *inputViewTextField = alertController.textFields[0];
                                                   [self sendNavCommand:[NSString stringWithFormat:@"enterText=%@", [inputViewTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                                                   
                                               }];
        
        [alertController addAction:inputAndSubmitAction];
        [self showViewController:alertController sender:nil];
        
    }];
    
    
}

- (BOOL)hostAvailable
{
    NSMutableURLRequest *request = [self hostAvailableRequest];
    NSHTTPURLResponse * theResponse = nil;
    NSError *theError = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
    if (theError != nil)
    {
        NSLog(@"theResponse: %li theError; %@", (long)[theResponse statusCode], theError);
        return (FALSE);
    }
    
    return (TRUE);
    
}

- (void)sendNavCommand:(NSString *)navCommand
{
    NSMutableURLRequest *request = [self requestForAction:navCommand];
    NSHTTPURLResponse * theResponse = nil;
    NSError *theError = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
}


- (NSMutableURLRequest *)requestForAction:(NSString *)theAction // theres gotta be a more elegant way to do this
{
    NSString *httpCommand = [NSString stringWithFormat:@"http://%@/%@", APPLE_TV_ADDRESS, theAction];
   // NSLog(@"httpCommand: %@", httpCommand);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setTimeoutInterval:2];
    [request setURL:[NSURL URLWithString:httpCommand]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"X-User-Agent" forHTTPHeaderField:@"User-Agent"];
    [request setValue:nil forHTTPHeaderField:@"X-User-Agent"];
    return request;
}


- (NSMutableURLRequest *)hostAvailableRequest // theres gotta be a more elegant way to do this
{
    NSString *httpCommand = [NSString stringWithFormat:@"http://%@/ap", APPLE_TV_ADDRESS];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setTimeoutInterval:2];
    [request setURL:[NSURL URLWithString:httpCommand]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"X-User-Agent" forHTTPHeaderField:@"User-Agent"];
    [request setValue:nil forHTTPHeaderField:@"X-User-Agent"];
    return request;
}

@end
