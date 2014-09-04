//
//  TimeDetail.m
//  SpeakAlarm
//
//  Created by Mark Davies on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimeDetail.h"
#import "AlarmsModel.h"

@implementation TimeDetail
@synthesize timePicker;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	AlarmsModel *sharedManager = [AlarmsModel sharedManager];
	
	NSDate *date = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
	NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
	[components setHour: sharedManager.selectedAlarm.hour];
	[components setMinute: sharedManager.selectedAlarm.mins];
	
	timePicker.date = [gregorian dateFromComponents: components];
    
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(IBAction) timechanged {
	AlarmsModel *sharedManager = [AlarmsModel sharedManager];
	
	NSDate *date = self.timePicker.date;
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	unsigned int unitFlags = NSHourCalendarUnit|NSMinuteCalendarUnit;
	NSDateComponents *comp = [calendar components:unitFlags fromDate:date];
	
	NSInteger hour = [comp hour];
	NSInteger minute = [comp minute];
	
	[sharedManager.selectedAlarm setHour:hour];
	[sharedManager.selectedAlarm setMins:minute];
	
	[sharedManager saveAlarms];
}




- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
