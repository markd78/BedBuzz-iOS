//
//  GeneratingSpeechViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 8/14/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import "GeneratingSpeechViewController.h"
#import "AmazonPoly.h"
#import "SoundDirector.h"
#import "UserModel.h"
#import "SpeakAlarmAppDelegate.h"

@implementation GeneratingSpeechViewController
@synthesize name;

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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



- (void)generateSpeech:(id)sender ForName:(NSString *)nameOfUser {
	
	self.name = nameOfUser;
	
	NSString *morningString = [@"Good Morning " stringByAppendingString:nameOfUser];
	NSString *afternoonString = [@"Good Afternoon " stringByAppendingString:nameOfUser];
	NSString *eveningString = [@"Good Evening " stringByAppendingString:nameOfUser];
	
	// generate the sounds	
	AmazonPoly *AmazonPoly1 = [[AmazonPoly alloc] init];
	[AmazonPoly1 startGenerateSpeech:morningString AndSaveToFileName:@"goodMorning.mp3"  withVoice:@"ukenglishfemale" AndReturnTo:self];
	//[neoSpeechService autorelease];
	
	AmazonPoly *AmazonPoly2 = [[AmazonPoly alloc] init];
	[AmazonPoly2 startGenerateSpeech:afternoonString AndSaveToFileName:@"goodAfternoon.mp3"  withVoice:@"ukenglishfemale" AndReturnTo:self];
	//[neoSpeechService2 autorelease];
	
	AmazonPoly *AmazonPoly3  = [[AmazonPoly alloc] init];
	[AmazonPoly3 startGenerateSpeech:eveningString AndSaveToFileName:@"goodEvening.mp3"  withVoice:@"ukenglishfemale" AndReturnTo:self];
	//[neoSpeechService3 autorelease];
	
}

- (void)speechGenerated;
{
	numberOfSpeechGenerated++;
	if (numberOfSpeechGenerated == 3)
	{
		
		// save the user's name
		UserModel *userModel = [UserModel userModel];
		userModel.userSettings.userFullName = name;
		userModel.userSettings.shouldGreetWithName = YES;
        userModel.userSettings.haveShownHelpScreen = NO;
		userModel.userSettings.themeName = @"Sunrise 1";
		userModel.userSettings.currentThemeImageName = @"sunrise";
		[userModel saveUserSettings];
		
		// say the welcome message
		SoundDirector *soundDirector = [SoundDirector soundDirector];
		[soundDirector sayWelcome];
		
		
		
		// and get rid of this screen
		[self.view removeFromSuperview];
		
		SpeakAlarmAppDelegate *appDelegate = (SpeakAlarmAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		[appDelegate showScreen];
		
		
	}
}

@end
