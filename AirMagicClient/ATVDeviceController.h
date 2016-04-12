/* ATVDeviceController */

#if TARGET_OS_OSX
//#import <Cocoa/Cocoa.h>
#endif

#import <Foundation/Foundation.h>

@protocol ATVDeviceControllerDelegate <NSObject>

- (void)servicesFound:(NSArray *)services;

@end

@interface ATVDeviceController : NSObject <NSNetServiceBrowserDelegate>
{
	
	IBOutlet id hostNameField;
	IBOutlet id deviceList;
	IBOutlet id apiVersionLabel;
	IBOutlet id osVersionLabel;
#if TARGET_OS_OSX
    IBOutlet NSWindow *myWindow;
	IBOutlet NSPopUpButton *theComboBox;
	IBOutlet NSArrayController *deviceController;
#else 
    NSMutableArray *deviceArray;
#endif
    BOOL searching;
    NSNetServiceBrowser * browser;
    NSMutableArray * services;
    NSMutableData * currentDownload;
	NSArray *receivedFiles;
    NSDictionary *deviceDictionary;
	
	
}

#if TARGET_OS_OSX

@property (nonatomic, retain) IBOutlet NSPopUpButton *theComboBox;
@property (nonatomic, retain) NSArrayController *deviceController;

#endif

@property (nonatomic, weak) id <ATVDeviceControllerDelegate> delegate;


- (NSDictionary *)deviceDictionary;

- (NSDictionary *)stringDictionaryFromService:(NSNetService *)theService;

#if TARGET_OS_OSX
- (IBAction)serviceClicked:(id)sender;
- (IBAction)menuItemSelected:(id)sender;
- (NSDictionary *)currentServiceDictionary;
#endif
@end
