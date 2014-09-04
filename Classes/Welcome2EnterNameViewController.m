//
//  Welcome2EnterNameViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 2/8/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import "Welcome2EnterNameViewController.h"
#import "iSpeechService.h"
#import "SoundDirector.h"
#import "UserModel.h"
#import "SpeakAlarmAppDelegate.h"
#import "WizardDelegate.h"
#import "ViewHelper.h"
#import "Flurry.h"

@implementation Welcome2EnterNameViewController
@synthesize morningString;
@synthesize afternoonString;
@synthesize eveningString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndReturnTo:(id <WizardDelegate>)delegateClass

{
    wizardDelegate = delegateClass;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Custom initialization.
		numberOfSpeechGenerated = 0;
		[spinner setHidden:YES];
		
		SoundDirector *soundDirector = [SoundDirector soundDirector];
		[soundDirector sayHello];
    }
    return self;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
   
        return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [submitBtn setEnabled:NO];
    [spinner setHidden:YES];
    
    [Flurry logEvent:@"wizard2"];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if((void *)UI_USER_INTERFACE_IDIOM() == NULL ||
       UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) 
    {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    
    self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -115);
    [UIView commitAnimations];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if((void *)UI_USER_INTERFACE_IDIOM() == NULL ||
       UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) 
    {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    
    self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, 115);
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
    }
}


-(void)startGeneratingSounds {
    
    [submitBtn setEnabled:NO];
    // and show spinny while they are generating
	[submitBtn setHidden:YES];
	[nameTxt setEnabled:NO];
	[spinner setHidden:NO];
	[spinner startAnimating];
    
	@autoreleasepool {
    
        morningString = [@"Good Morning " stringByAppendingString:nameTxt.text];
	afternoonString = [@"Good Afternoon " stringByAppendingString:nameTxt.text];
	eveningString = [@"Good Evening " stringByAppendingString:nameTxt.text];
        
        
	// generate the sounds	
	iSpeechService *iSpeechService1 = [[iSpeechService alloc] init];
	[iSpeechService1 startGenerateSpeech:self.morningString AndSaveToFileName:@"goodMorning.mp3"  withVoice:@"ukenglishfemale1" AndReturnTo:self];
	//[neoSpeechService autorelease];
	
	iSpeechService *iSpeechService2 = [[iSpeechService alloc] init];
	[iSpeechService2 startGenerateSpeech:self.afternoonString AndSaveToFileName:@"goodAfternoon.mp3"  withVoice:@"ukenglishfemale1" AndReturnTo:self];
	//[neoSpeechService2 autorelease];
	
	iSpeechService *iSpeechService3  = [[iSpeechService alloc] init];
	[iSpeechService3 startGenerateSpeech:self.eveningString AndSaveToFileName:@"goodEvening.mp3"  withVoice:@"ukenglishfemale1" AndReturnTo:self];
	//[neoSpeechService3 autorelease];
	
	
    
    }
    
}

- (void) fetchSoundsThread {
    
    
	// fetch the sounds in a new thread
    [NSThread detachNewThreadSelector:@selector(startGeneratingSounds) toTarget:self withObject:nil];
	
} 

- (IBAction)submitClicked:(id)sender {
    [spinner setHidden:NO];
    
    if (nameTxt!=nil)
    {
        [nameTxt resignFirstResponder];
    }
    
    [self fetchSoundsThread];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length > 0)
    {
        submitBtn.enabled = YES;
    }
    else
    {
        submitBtn.enabled = NO;
    }
    
    return YES;
}

- (IBAction)dismissKeyboard:(id)sender {
	
    [sender resignFirstResponder];
}

- (void)speechGenerated;
{
	numberOfSpeechGenerated++;
	if (numberOfSpeechGenerated == 3)
	{
		[spinner stopAnimating];
        
		// save the user's name
		UserModel *userModel = [UserModel userModel];
		userModel.userSettings.userFullName = nameTxt.text;
		userModel.userSettings.shouldGreetWithName = YES;
        userModel.userSettings.haveShownHelpScreen = NO;
		userModel.userSettings.themeName = @"Sunrise 1";
        if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
           UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            // add -ipad to the name
            userModel.userSettings.currentThemeImageName = @"sunrise-ipad.jpg";
            
        }
        else
        {
            userModel.userSettings.currentThemeImageName = @"sunrise.jpg";
        }
		
        userModel.userSettings.isKeepAwakeOn = YES;
        userModel.userSettings.hideFacebookBtn = NO;
		[userModel saveUserSettings];
		
        // dismiss the wizard
        ViewHelper *vh = [ViewHelper sharedManager];
        
        [vh moveToEndPosition:vh.currentView ForOrientation:[UIApplication sharedApplication].statusBarOrientation AndReturnTo:self];
		
	}
}

-(void)finishAnimationComplete
{
     [self.view removeFromSuperview];
    
    // tell delegate we're done
    [wizardDelegate showNextScreen:welcome3EnableFacebookScreen FromCurrentScreen:welcome2EnterNameScreen];
}


@end
