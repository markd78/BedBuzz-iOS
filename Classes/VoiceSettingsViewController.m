    //
//  VoiceSettingsViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 7/29/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import "VoiceSettingsViewController.h"
#import "UserModel.h"
#import "iSpeechService.h"
#import "SoundDirector.h"
#import "iToast.h"
#import "BuyViewController.h"
#import "StoreKitModel.h"

@implementation VoiceSettingsViewController
@synthesize voiceSettingsTableView;
@synthesize lastIndexPath;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        UserModel *userModel = [ UserModel userModel];
        currentVoiceName = userModel.userSettings.voiceName;
        currentUserName = userModel.userSettings.userFullName;
        
        if (currentVoiceName == nil)
        {
            currentVoiceName = @"ukenglishfemale1";
        }
        currentAdditionalMessage = userModel.userSettings.additionalMessage;
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    //[self retain];
    
	UserModel *userModel = [UserModel userModel];
	 [super viewDidLoad];
		
	nameTxt.text = userModel.userSettings.userFullName;
	messageTxt.text = userModel.userSettings.additionalMessage;
	
    [self refreshSaveBuybutton];
    
	[self enableDisableBuySaveButton];

}

-(void)refreshSaveBuybutton
{
    UserModel *userModel = [UserModel userModel];
    if (userModel.userSettings.isPaidUser || userModel.userSettings.changeVoiceNameCredits > 0)
	{
        [buySaveBtn setTitle:@"Save" forState:UIControlStateNormal];
		
		
	}
	else {
		 [buySaveBtn setTitle:@"Buy" forState:UIControlStateNormal];
	}

}

- (IBAction)buySavePressed:(id)sender
{
    UserModel *userModel = [UserModel userModel];
    if (userModel.userSettings.isPaidUser || userModel.userSettings.changeVoiceNameCredits > 0)
	{
        [self saveBtnClicked];
        
    }
    else
    {
        [self buyBtnClicked];
    }
}

-(void)enableDisableBuySaveButton
{
	
	if (currentVoiceName == nil || [currentUserName isEqualToString:@""] )
	{
		buySaveBtn.enabled = NO;
	}
    else
    {
        buySaveBtn.enabled = YES;
    }
}

-(void)saveBtnClicked {
    
    // do a save
	UserModel *userModel = [UserModel userModel];
	
	userModel.userSettings.userFullName = nameTxt.text;
	userModel.userSettings.additionalMessage = messageTxt.text;
	userModel.userSettings.voiceName = currentVoiceName;
    
    if (!userModel.userSettings.isPaidUser)
    {
        userModel.userSettings.changeVoiceNameCredits--;
        userModel.userSettings.userHasChangedVoice = YES;
    }
    
	[userModel saveUserSettings];
    
    [self generateSpeech:NO];
    
    [self refreshSaveBuybutton];
    
    [[[[iToast makeText:NSLocalizedString(@"Voice changes saved!", @"")] 
       setGravity:iToastGravityBottom] setDuration:1000] show];

}

-(void)buyBtnClicked {
	StoreKitModel *skModel = [StoreKitModel sharedManager];
	// GO TO Buy Page
	BuyViewController *buyViewController = [[BuyViewController alloc] initWithNibName:@"BuyView" bundle:[NSBundle mainBundle] AndProductID:skModel.productVoicesID];

	[self.navigationController pushViewController:buyViewController animated:YES ]; // "Pushing the controller on the screen" 

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	
	currentUserName = nameTxt.text;
	currentAdditionalMessage = messageTxt.text;
	
	return NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshSaveBuybutton];
}



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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return 3;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
	// Set up the cell...
	
	if (indexPath.row == 0)
	{
		cell.textLabel.text = @"US English Male";
		
		if ([currentVoiceName isEqualToString:@"usenglishmale1"])
		{
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			
			self.lastIndexPath = indexPath;
		}
		else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}

	}
	else if (indexPath.row == 1)
	{
		cell.textLabel.text = @"US English Female";
		
		if ([currentVoiceName isEqualToString:@"usenglishfemale1"])
		{
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			
			self.lastIndexPath = indexPath;
		}
		else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	else {
		cell.textLabel.text = @"UK English Female";
		
		if ([currentVoiceName isEqualToString:@"ukenglishfemale1"])
		{
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			
			self.lastIndexPath = indexPath;
		}
		else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger newRow = [indexPath row];
	NSInteger oldRow = [self.lastIndexPath row];
	
	if (newRow != oldRow)
	{
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:
									indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:
									self.lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
		
        self.lastIndexPath = indexPath;
	}
	
	switch (indexPath.row) {
		case 0:
			// @"US English Male";
			currentVoiceName = @"usenglishmale1";
			
			break;
		case 1:
			//@"US English Female";
			currentVoiceName = @"usenglishfemale1";
			
			break;
		case 2:
			//@"UK English Female";
			currentVoiceName = @"ukenglishfemale1";
			
			break;
		default:
			break;
	}
	
    currentUserName = nameTxt.text;
    currentAdditionalMessage = messageTxt.text;
    
    [self enableDisableBuySaveButton];
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];}


- (IBAction)dismissKeyboard:(id)sender {
	
    [sender resignFirstResponder];
	
	currentUserName = nameTxt.text;
	currentAdditionalMessage = messageTxt.text;
	
	[self enableDisableBuySaveButton];
}

-(void)generateSpeech:(BOOL)forTest
{
    if (forTest)
    {
        spinner.hidden = NO;
        [spinner startAnimating];
    }
	
	NSNumber *forTestnum = [NSNumber numberWithBool:forTest];
	
	// fetch the sounds in a new thread
	[NSThread detachNewThreadSelector:@selector(fetchSoundsThread:) toTarget:self withObject:forTestnum];	
	

	
	
}

- (void) fetchSoundsThread:(NSNumber *)forTestNum {
	
	BOOL forTest = [forTestNum boolValue];
	
	soundsReceived = 0;
	
	generatingSpeechForTest = forTest;	
	
	@autoreleasepool {
	
	/* Do your threaded code here */
	
	
				NSString *morningString = [@"Good Morning " stringByAppendingString:nameTxt.text];
				NSString *afternoonString = [@"Good Afternoon " stringByAppendingString:nameTxt.text];
				NSString *eveningString = [@"Good Evening " stringByAppendingString:nameTxt.text];
	
	
	NSString *morningFileName; 
	NSString *afternoonFileName; 
	NSString *eveningFileName; 
	NSString *addtionalMessageFileName; 
	
	if (!forTest)
	{
				morningFileName = @"goodMorning.mp3";
				afternoonFileName = @"goodAfternoon.mp3";
				eveningFileName = @"goodEvening.mp3";
				addtionalMessageFileName = @"additionalMessage.mp3";
	}
	else {
				morningFileName = @"goodMorningTest.mp3";
				afternoonFileName = @"goodAfternoonTest.mp3";
				eveningFileName = @"goodEveningTest.mp3";
				addtionalMessageFileName = @"additionalMessageTest.mp3";
	}

	
	// generate the sounds	
	iSpeechService *iSpeechService1 = [[iSpeechService alloc] init];
	[iSpeechService1 startGenerateSpeech:morningString AndSaveToFileName:morningFileName withVoice:currentVoiceName AndReturnTo:self];
	//[neoSpeechService autorelease];
	
	iSpeechService *iSpeechService2 = [[iSpeechService alloc] init];
	[iSpeechService2 startGenerateSpeech:afternoonString AndSaveToFileName:afternoonFileName withVoice:currentVoiceName  AndReturnTo:self];
	//[neoSpeechService2 autorelease];
	
	iSpeechService *iSpeechService3  = [[iSpeechService alloc] init];
	[iSpeechService3 startGenerateSpeech:eveningString AndSaveToFileName:eveningFileName withVoice:currentVoiceName  AndReturnTo:self];
	
	if ([messageTxt.text length] != 0 )
	{
				iSpeechService *iSpeechService4  = [[iSpeechService alloc] init];
				[iSpeechService4 startGenerateSpeech:messageTxt.text AndSaveToFileName:addtionalMessageFileName withVoice:currentVoiceName  AndReturnTo:self];
	}
	else {
				[self speechGenerated];
	}
	
	}
} 

- (void)speechGenerated;
{
	[spinner stopAnimating];
	spinner.hidden = YES;
	
	soundsReceived++;
	
	if (generatingSpeechForTest && soundsReceived == 4 )
	{
		SoundDirector *soundDirector = [SoundDirector soundDirector];
        
        BOOL includeAdditionalMessage = (messageTxt.text != nil && ![messageTxt.text isEqualToString:@""]);
        
		[soundDirector playTimeForTest:includeAdditionalMessage];
	}
	
}

- (IBAction)testSounds
{
	// and fetch the new voices
	[self generateSpeech:YES];

	
	
}

@end
