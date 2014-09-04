//
//  RSSDetailViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 9/21/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import "RSSDetailViewController.h"
#import "RSSFeed.h"
#import "SoundDirector.h"
#import "FetchRSSClipsService.h"
#import "RSSModel.h"
#import "iToast.h"

@implementation RSSDetailViewController
@synthesize rssFeed;
@synthesize isNew;
@synthesize voiceSettingsTableView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andRSSFeed:(RSSFeed *)rssFeedToShow isNew:(BOOL)isNewFeed {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.rssFeed = rssFeedToShow;
		self.isNew = isNewFeed;
        
        if (!isNewFeed)
        {
            saveButton.titleLabel.text = @"Save";
        }
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	rssNameTextField.text = rssFeed.feedName;
	rssLinkTextField.text = rssFeed.feedLink;
    
    testButton.enabled = NO;
    testButton.alpha = 0.3;
    saveButton.enabled = NO;
    saveButton.alpha = 0.3;
    spinner.hidden = YES;
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



-(void)setRSSDetails
{
    rssFeed.feedName = rssNameTextField.text;
	rssFeed.feedLink = rssLinkTextField.text;
    
    if (![rssFeed.feedName isEqualToString:@""] && rssFeed.feedLink!=nil && ![rssFeed.feedLink isEqualToString:@""])
    {
        testButton.enabled = YES;
        testButton.alpha = 1;
        saveButton.enabled = NO;
        saveButton.alpha = 0.3;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([rssNameTextField isFirstResponder] && [touch view] != rssNameTextField) {
        [rssNameTextField resignFirstResponder];
        [self setRSSDetails];
    }
    else if ([rssLinkTextField isFirstResponder] && [touch view] != rssLinkTextField) {
        [rssLinkTextField resignFirstResponder];
        [self setRSSDetails];
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)dismissKeyboard:(id)sender {
	
    [sender resignFirstResponder];
	[self setRSSDetails];
	
}

- (IBAction)saveRSSFeed
{
	RSSModel *rssModel = [RSSModel sharedManager];
	
	if (isNew)
	{
		[rssModel.rssFeeds addObject:rssFeed];
	}
	
	[rssModel saveRSSFeeds];
	
	 [self.navigationController popViewControllerAnimated: YES];
    
    SoundDirector *soundDirector = [SoundDirector soundDirector];
    [soundDirector stopPlayingRSS];
}

- (IBAction)testRSSFeed
{
	FetchRSSClipsService *rssService = [[FetchRSSClipsService alloc] init];
	[rssService getRSSClips:rssFeed.feedLink withVoiceName:rssFeed.voiceName AndReturnTo:self];
    spinner.hidden = NO;
    testButton.enabled = NO;
    testButton.alpha = 0.3;
    [spinner startAnimating];
}

-(void) rssClipsFetchingError
{	
    [[[[iToast makeText:NSLocalizedString(@"There was an error parsing the feed.  Please check the URL and try again", @"")] 
       setGravity:iToastGravityBottom] setDuration:3000] show];
}

-(void) rssClipsHaveBeenFetched
{
	SoundDirector *soundDirector = [SoundDirector soundDirector];
	[soundDirector addRSSClipsToPlayQueueAndPlay];
    
    testButton.enabled = NO;
    testButton.alpha = 0.3;
    saveButton.enabled = YES;
    saveButton.alpha = 1;
    
    spinner.hidden = YES;
    [spinner stopAnimating];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return 4;
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
		
		if ([rssFeed.voiceName isEqualToString:@"usenglishmale1"])
		{
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			
			lastIndexPath = indexPath;
		}
		else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
	}
	else if (indexPath.row == 1)
	{
		cell.textLabel.text = @"US English Female (best for non-serious stuff)";
		
		if ([rssFeed.voiceName isEqualToString:@"usenglishfemale1"])
		{
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			
			lastIndexPath = indexPath;
		}
		else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	else if (indexPath.row == 2) {
		cell.textLabel.text = @"UK English Female";
		
		if ([rssFeed.voiceName isEqualToString:@"ukenglishfemale1"])
		{
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			
			lastIndexPath = indexPath;
		}
		else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	else {
		cell.textLabel.text = @"UK English Male (best for news)";
		
		if ([rssFeed.voiceName isEqualToString:@"ukenglishmale1"])
		{
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			
			lastIndexPath = indexPath;
		}
		else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	int newRow = [indexPath row];
	int oldRow = [lastIndexPath row];
	
	if (newRow != oldRow)
	{
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:
									indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:
									lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
		
        lastIndexPath = indexPath;
	}
	
	switch (indexPath.row) {
		case 0:
			// @"US English Male";
			rssFeed.voiceName = @"usenglishmale1";
			
			break;
		case 1:
			//@"US English Female";
			rssFeed.voiceName = @"usenglishfemale1";
			
			break;
		case 2:
			//@"UK English Female";
			rssFeed.voiceName = @"ukenglishfemale1";
			
			break;
		case 3:
			// @"UK English Male";
			rssFeed.voiceName = @"ukenglishmale1";
			
			break;
		default:
			break;
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self setRSSDetails];
}


@end
