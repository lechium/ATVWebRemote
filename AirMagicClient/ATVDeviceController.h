/* ATVDeviceController */

#import <Cocoa/Cocoa.h>


@interface ATVDeviceController : NSObject
{
	IBOutlet NSWindow *myWindow;
	IBOutlet id hostNameField;
	IBOutlet id deviceList;
	IBOutlet id apiVersionLabel;
	IBOutlet id osVersionLabel;
	IBOutlet NSPopUpButton *theComboBox;
	IBOutlet NSArrayController *deviceController;
	BOOL searching;
    NSNetServiceBrowser * browser;
    NSMutableArray * services;
    NSMutableData * currentDownload;
	NSArray *receivedFiles;
    NSDictionary *deviceDictionary;
	
	
}

@property (nonatomic, retain) IBOutlet NSPopUpButton *theComboBox;
@property (nonatomic, retain) NSArrayController *deviceController;

- (NSDictionary *)deviceDictionary;

- (NSDictionary *)stringDictionaryFromService:(NSNetService *)theService;

- (IBAction)serviceClicked:(id)sender;
- (IBAction)menuItemSelected:(id)sender;
- (NSDictionary *)currentServiceDictionary;
@end
