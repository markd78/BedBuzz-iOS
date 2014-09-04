//
//  SettingsViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "AlarmsModel.h"
#import "AlarmDetailTableController.h"
#import "SnoozeTableViewController.h"
#import "TemperatureUnitTableViewController.h"
#import "SnoozeLengthCell.h"
#import "TemperatureScaleCustomCell.h"
#import "GreetWithNameCell.h"
#import "AlarmCustomCell.h"
#import "ThemeListTableViewController.h"
#import "VoiceSettingsViewController.h"
#import "RSSFeedsViewController.h"
#import "UserModel.h"
#import "BuyViewController.h"
#import "SettingsSliderHeader.h"
#import "KeepAwakeCustomCell.h"
#import "StoreKitModel.h"
#import "ShowFacebookBtnCell.h"
#import "ShowStatusBarCell.h"
#import "ReviewCodeCell.h"

@implementation SettingsViewController
@synthesize voiceSettingsViewController;
@synthesize themesTableViewController;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
    if((void *)UI_USER_INTERFACE_IDIOM() == NULL ||
       UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        //Add the done button.
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
											   target:self action:@selector(done_Clicked:)];
    }
	
   
        
        
    
    
    UserModel *userModel = [UserModel userModel];
    
    NSString *footerString = @"";
    
    if (userModel.userSettings.isPaidUser)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        NSString *dateString = [dateFormatter stringFromDate:userModel.userSettings.subscriberUntilDate];
        footerString = [footerString stringByAppendingString:[NSString stringWithFormat:@"\nYour subscription expires on %@\n\n",dateString]];
    }
    
    footerString = [footerString stringByAppendingString:[NSString stringWithFormat:@"Notification music provided by DanoSongs.com\nBed-Buzz version 1.4.0\nCopyright 2012 Comantis LLC \nYour user ID is %@",[userModel.userSettings.bedBuzzID stringValue]]] ;
    
   
    
	UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 320, 158)];
	label3.backgroundColor = [UIColor clearColor];
	label3.font = [UIFont systemFontOfSize:15];
	label3.shadowColor = [UIColor darkGrayColor];
	label3.textAlignment = NSTextAlignmentLeft;
	label3.textColor = [UIColor blackColor];
	label3.lineBreakMode = NSLineBreakByWordWrapping;
	label3.numberOfLines = 9;
	label3.text = footerString;
	self.tableView.tableFooterView = label3;
	
}

- (void) done_Clicked:(id)sender {
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *title;
	
    UserModel *userModel = [UserModel userModel];
    
	switch (section) {
		case 0:
			title = @"Alarms";
			break;
		case 1:
			title = @"Voices";
			break;
		case 2:
			title = @"Theme";
			break;
		case 3:
			title = @"Settings";
			break;
		case 4:
            if (userModel.userSettings.isPaidUser)
            {
                title = @"RSS Feeds";
            }
            else
            {
                title = @"Upgrade to premium";
            }
			break;
			
		default:
            title = @"";
			break;
	}
	
	return title;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
    SettingsSliderHeader *sliderView = [[SettingsSliderHeader alloc] initWithCallback:self];
    self.tableView.tableHeaderView = sliderView;
    
//	[self.navigationController setNavigationBarHidden:NO ];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	[alarmSettingsTableView reloadData];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait)
	|| (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    
            return 44;
   
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSInteger numberOfRows = 0;
	AlarmsModel *sharedManager = [AlarmsModel sharedManager];
	
	switch (section) {
		case 0:
			// Alarms
			// number of alarms + 1 for the 'add alarm' row
			numberOfRows = [[sharedManager alarms] count] + 1;
			break;
		case 1:
			// Voice
			numberOfRows= 1;
			break;
		case 2:
			// Theme
			numberOfRows= 1;
			break;
		case 3:
			// Settings
			numberOfRows = 6;
			break;
		case 4:
			// RSS Feeds or buy premium
			numberOfRows = 1;
			break;
		default:
			break;
	}
	
    return numberOfRows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    static NSString *SnoozeCellIdentifier = @"SnoozeCell";
	static NSString *TempCellIdentifier = @"TempCell";
	static NSString *GreetWithNameCellIdentifier = @"GreetWithNameCell";
    static NSString *KeepAwakeCustomCellIdentifier = @"KeepAwakeCell";
    static NSString *AlarmCustomCellIdentifier = @"AlarmCell";    
    static NSString *ShowStatusBarCustomCellIdentifier = @"ShowStatusBarCustomCellIdentifier";
    static NSString *ShowFacebookBtnCustomCellIdentifier = @"ShowFacebookBtnCustomCellIdentifier";
    //static NSString *ReviewCodeCustomCellIdentifier=@"ReviewCodeCustomCellIdentifier";
    
    // Configure the cell...
    if (indexPath.section == 0)
	{
		
		AlarmsModel *sharedManager = [AlarmsModel sharedManager];
		
		if (indexPath.row < sharedManager.alarms.count)
		{
            AlarmCustomCell *alarmCell = (AlarmCustomCell *)[tableView dequeueReusableCellWithIdentifier:AlarmCustomCellIdentifier];
            if (alarmCell == nil) {
                alarmCell = [[[NSBundle mainBundle] loadNibNamed:@"AlarmCustomCellRenderer" owner:self options:nil] lastObject];
            }
            
            
			Alarm *cellValue = [[sharedManager alarms] objectAtIndex:indexPath.row];
		
			alarmCell.nameLbl.text = cellValue.alarmName;
            alarmCell.timeLbl.text = [cellValue getTimeString];
            alarmCell.daysLbl.text = [cellValue getDaysString];
            
            if (cellValue.enabled)
            {
                alarmCell.nameLbl.textColor = [UIColor blueColor];
            }
            else
            {
                alarmCell.nameLbl.textColor = [UIColor grayColor];
            }
			return alarmCell;
		}
		else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
			cell.textLabel.text = @"Add Alarm...";
			cell.textLabel.textColor = [UIColor blueColor];	
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            return cell;
		}

		
		
	}
	
	if (indexPath.section == 1)
	{
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		cell.textLabel.text = @"Change Voice / Greeting";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		return cell;
	}
	
	if (indexPath.section == 2)
	{
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		cell.textLabel.text = @"Change Theme";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		return cell;
	}
	
	SnoozeLengthCell *snoozeLengthCell;
	TemperatureScaleCustomCell *temperatureScaleCustomCell;
	GreetWithNameCell *greetWithNameCell;
	KeepAwakeCustomCell *keepAwakeCell;
    ShowFacebookBtnCell *showFacebookBtnCell;
    ShowStatusBarCell *showStatusBarCell;
  //  ReviewCodeCell *reviewCodeCell;
    
	if (indexPath.section == 3)
	{
		switch (indexPath.row) {
			case 0:
				// snooze
				snoozeLengthCell = (SnoozeLengthCell *)[tableView dequeueReusableCellWithIdentifier:SnoozeCellIdentifier];
				if (snoozeLengthCell == nil) {
					snoozeLengthCell = [[[NSBundle mainBundle] loadNibNamed:@"SnoozeLengthCell" owner:self options:nil] lastObject];
				}
				
			//	snoozeLengthCell.textLabel.text  = @"Snooze Length";
				return snoozeLengthCell;
				break;
			case 1:
				// temp scale
				temperatureScaleCustomCell = (TemperatureScaleCustomCell *)[tableView dequeueReusableCellWithIdentifier:TempCellIdentifier];
				if (temperatureScaleCustomCell == nil) {
					temperatureScaleCustomCell = [[[NSBundle mainBundle] loadNibNamed:@"TemperatureScaleCustomCell" owner:self options:nil] lastObject];
				}
				
			//	temperatureScaleCustomCell.textLabel.text  = @"Temperature Scale";
				return temperatureScaleCustomCell;
				
				break;
			case 2:
				// Greet with name?
				greetWithNameCell = (GreetWithNameCell *)[tableView dequeueReusableCellWithIdentifier:GreetWithNameCellIdentifier];
				if (greetWithNameCell == nil) {
					greetWithNameCell = [[[NSBundle mainBundle] loadNibNamed:@"GreetWithNameCustomCell" owner:self options:nil] lastObject];
				}
                greetWithNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return greetWithNameCell;
				
				break;
            case 3:
				// Prevent Sleeping?
				keepAwakeCell = (KeepAwakeCustomCell *)[tableView dequeueReusableCellWithIdentifier:KeepAwakeCustomCellIdentifier];
				if (keepAwakeCell == nil) {
					keepAwakeCell = [[[NSBundle mainBundle] loadNibNamed:@"KeepAwakeCustomCell" owner:self options:nil] lastObject];
				}
				
				 keepAwakeCell.selectionStyle = UITableViewCellSelectionStyleNone;
				return keepAwakeCell;
				
				break;
            case 4:
                // show Facebook button?
				showFacebookBtnCell = (ShowFacebookBtnCell *)[tableView dequeueReusableCellWithIdentifier:ShowFacebookBtnCustomCellIdentifier];
				if (showFacebookBtnCell == nil) {
					showFacebookBtnCell = [[[NSBundle mainBundle] loadNibNamed:@"ShowFacebookBtnCustomCell" owner:self options:nil] lastObject];
				}
				
                showFacebookBtnCell.selectionStyle = UITableViewCellSelectionStyleNone;
				return showFacebookBtnCell;

            case 5:
                // show Status Bar ?
				showStatusBarCell = (ShowStatusBarCell *)[tableView dequeueReusableCellWithIdentifier:ShowStatusBarCustomCellIdentifier];
				if (showStatusBarCell == nil) {
					showStatusBarCell = [[[NSBundle mainBundle] loadNibNamed:@"ShowStatusBarCustomCell" owner:self options:nil] lastObject];
				}
				
                showStatusBarCell.selectionStyle = UITableViewCellSelectionStyleNone;
				return showStatusBarCell;
         /*   case 6:
                // review code ?
				reviewCodeCell = (ReviewCodeCell *)[tableView dequeueReusableCellWithIdentifier:ReviewCodeCustomCellIdentifier];
				if (reviewCodeCell == nil) {
					reviewCodeCell = [[[NSBundle mainBundle] loadNibNamed:@"EnterReviewCodeCustomCell" owner:self options:nil] lastObject];
				}
				
                reviewCodeCell.selectionStyle = UITableViewCellSelectionStyleNone;
				return reviewCodeCell;*/
			default:
				break;
		}
	}
	
	if (indexPath.section == 4)
	{
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
        UserModel *userModel = [UserModel userModel];
        if (userModel.userSettings.isPaidUser)
        {
            cell.textLabel.text = @"RSS feeds";
        }
        else
        {
            cell.textLabel.text = @"Upgrade to Unlimited!";
        }
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		return cell;
	}
	
    return nil;
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	AlarmsModel *sharedManager = [AlarmsModel sharedManager];
	
	NSLog(@"Index Path Section=%li",(long)indexPath.section);
	NSLog(@"Index Path Row=%li",(long)indexPath.row);
	if (indexPath.section == 0)
	{
		AlarmDetailTableController *detailViewController;
		
		if (indexPath.row < sharedManager.alarms.count)
		{
			Alarm *selectedAlarm = [[sharedManager alarms] objectAtIndex:indexPath.row]; 
			
			detailViewController = [[AlarmDetailTableController alloc] initWithNibName:@"AlarmDetailTable" bundle:[NSBundle mainBundle] alarm:selectedAlarm]; // creating new detail view controller instance  
		}
		else
		{
			// it is a new alarm.  Let's create a new default alarm and pass 
			Alarm *defaultAlarm = [sharedManager getDefaultAlarm];
			[sharedManager.alarms addObject:defaultAlarm];
			detailViewController = [[AlarmDetailTableController alloc] initWithNibName:@"AlarmDetailTable" bundle:[NSBundle mainBundle] alarm:defaultAlarm];
		}
		[self.navigationController pushViewController:detailViewController animated:YES]; // "Pushing the controller on the screen" 
	
		 // releasing controller from the memory  
		detailViewController = nil;  

	}
	else if (indexPath.section == 1)
	{
		// voices
		self.voiceSettingsViewController = [[VoiceSettingsViewController alloc] initWithNibName:@"VoicesSettings" bundle:[NSBundle mainBundle]];
		[self.navigationController pushViewController:voiceSettingsViewController animated:YES]; // "Pushing the controller on the screen" 
		
	}
	else if (indexPath.section == 2)
	{
		// themes
		self.themesTableViewController = [[ThemeListTableViewController alloc] initWithNibName:@"ThemeListTable" bundle:[NSBundle mainBundle]];
        
		[self.navigationController pushViewController:themesTableViewController animated:YES]; // "Pushing the controller on the screen" 
		
	}
	else if (indexPath.section == 3)
	{
		SnoozeTableViewController *snoozeTableViewController;
		TemperatureUnitTableViewController *tempUnitViewController;
		
		switch (indexPath.row) {
			case 0:
				// snooze
				snoozeTableViewController = [[SnoozeTableViewController alloc] initWithNibName:@"SnoozeTable" bundle:[NSBundle mainBundle]];
				[self.navigationController pushViewController:snoozeTableViewController animated:YES]; // "Pushing the controller on the screen" 
		
				break;
			case 1:
				// temp scale
				tempUnitViewController = [[TemperatureUnitTableViewController alloc] initWithNibName:@"TemperatureUnitTable" bundle:[NSBundle mainBundle]];
				[self.navigationController pushViewController:tempUnitViewController animated:YES]; // "Pushing the controller on the screen" 
				
				break;
			default:
				break;
		}
	}
	else if (indexPath.section == 4)
	{
        UserModel *userModel = [UserModel userModel];
        if (userModel.userSettings.isPaidUser)
        {
            RSSFeedsViewController *viewController = [[RSSFeedsViewController alloc] initWithNibName:@"RSSFeeds" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else
        {
             StoreKitModel *skModel = [StoreKitModel sharedManager];
            BuyViewController *buyViewController = [[BuyViewController alloc] initWithNibName:@"SubscribeToBedBuzz" bundle:[NSBundle mainBundle] AndProductID:skModel.productSubscribeID];
            
            [self.navigationController pushViewController:buyViewController animated:YES ]; // "Pushing the controller on the screen" 
            
        }
		
	}
   }


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}



-(void)popOverWasClosed
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)subscribeBtnPressed
{
        StoreKitModel *skModel = [StoreKitModel sharedManager];
        BuyViewController *buyViewController = [[BuyViewController alloc] initWithNibName:@"SubscribeToBedBuzz" bundle:[NSBundle mainBundle] AndProductID:skModel.productSubscribeID];
        
        [self.navigationController pushViewController:buyViewController animated:YES ]; // "Pushing the controller on the screen" 
        
    
}


@end

