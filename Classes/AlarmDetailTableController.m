//
//  AlarmDetailTableController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlarmDetailTableController.h"
#import "Alarm.h"
#import "AlarmNameCustomCell.h"
#import "EnabledCustomCell.h"
#import "DaysAlarmDetailViewController.h"
#import "TimeDetail.h"
#import "AlarmsModel.h"
#import "TimeCustomCell.h"
#import "AlarmMusicCustomCell.h"
#import "DaysCustomCell.h"
#import "SpeakAlarmAppDelegate.h"

@implementation AlarmDetailTableController
@synthesize popOverController;

#pragma mark -
#pragma mark View lifecycle

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarm:(Alarm *)alarm {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        
		AlarmsModel *sharedManager = [AlarmsModel sharedManager];
		[sharedManager setSelectedAlarm:alarm];
		
    }
    return self;
}

/*
 - (void)viewDidLoad {
 [super viewDidLoad];
 
 // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
 // self.navigationItem.rightBarButtonItem = self.editButtonItem;
 }
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section) {
		case 0:
			return 44;
			break;
		case 1:
			switch (indexPath.row) {
				case 0:
					return 44;
					break;
				case 1:
					return 44;
					break;
				case 2:
					return 44;
					break;
				case 3:
					return 60;
					break;
				default:
					break;
			}
	}
	
	return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 1)
    {
        //allocate the view if it doesn't exist yet
        UIView *view  = [[UIView alloc] init];
        view.userInteractionEnabled = YES;
        
        //create the button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [button setFrame:CGRectMake(10, 20, 300, 44)];
        
        //set title, font size and font color
        [button setTitle:@"Delete Alarm" forState:UIControlStateNormal];
        [button setBackgroundImage:[[UIImage imageNamed:@"buttonRed.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        
        //set action of the button
        [button addTarget:self action:@selector(deletePressed)
         forControlEvents:UIControlEventTouchUpInside];
        
        //add the button to the view
        [view addSubview:button];
        
        UILabel *warningLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 100)];
        [warningLbl setText:@"If BedBuzz is not active when the alarm activates, a local notification will show.  Please make sure that BedBuzz has Alert style notifications (with sound) enabled in your 'Settings' app"];
        [warningLbl setNumberOfLines:6];
        [warningLbl setFont:[UIFont systemFontOfSize:12]];
        [warningLbl setBackgroundColor:[UIColor clearColor]];
        [view addSubview:warningLbl];
        return view;
    }
    
    return nil;
}

// specify the height of your footer section
- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    //differ between your sections or if you
    //have only on section return a static value
    if (section == 1)
    {
        return 80;
    }
    else
    {
        return 10;
    }
    
}

-(void)deletePressed
{
    UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Delete Alarm"];
	[alert setMessage:@"Are you sure you want to delete this alarm?"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Yes"];
	[alert addButtonWithTitle:@"No"];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		AlarmsModel *alarmModel = [AlarmsModel sharedManager];
        [alarmModel.alarms removeObject:alarmModel.selectedAlarm];
        [alarmModel saveAlarms];
        
        [self.navigationController popViewControllerAnimated:YES];
	}
	else if (buttonIndex == 1)
	{
		// No
	}
}

// this can be called from the 'alarm name custom cell' when you click back
- (IBAction)dismissKeyboard:(id)sender {
	
    [sender resignFirstResponder];
	
	AlarmsModel *sharedManager = [AlarmsModel sharedManager];
	[[sharedManager selectedAlarm] setAlarmName:[sender text]];
	[sharedManager saveAlarms];
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[alarmDetailTableView reloadData];
}

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	switch (section) {
		case 0:
			return 1;
			break;
		case 1:
			return 4;
			break;
		default:
			break;
	}
	
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	AlarmNameCustomCell *alarmNameCustomCell;
	EnabledCustomCell *alarmEnabledCell;
	TimeCustomCell *timeCustomCell;
	AlarmMusicCustomCell *alarmMusicCustomCell;
	DaysCustomCell *daysCustomCell;
	AlarmsModel *alarmModel = [AlarmsModel sharedManager];
	
    // Configure the cell...
	switch (indexPath.section) {
		case 0:
			// this is the 'enabled' seciton
			alarmEnabledCell = (EnabledCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (alarmEnabledCell == nil) {
				alarmEnabledCell = [[[NSBundle mainBundle] loadNibNamed:@"AlarmEnabledCell" owner:self options:nil] lastObject];
			}
			
			
			return alarmEnabledCell;
			break;
		case 1: { {
			// this is the main 'detail' section
			switch (indexPath.row) {
				case 0:
					alarmNameCustomCell = (AlarmNameCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
					if (alarmNameCustomCell == nil) {
						alarmNameCustomCell = [[[NSBundle mainBundle] loadNibNamed:@"AlarmNameCellRenderer" owner:self options:nil] lastObject];
					}
					
                    
					return alarmNameCustomCell;
					break;
				case 1:
					// Time
					timeCustomCell = (TimeCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
					if (timeCustomCell == nil) {
						timeCustomCell = [[[NSBundle mainBundle] loadNibNamed:@"TimeCustomCell" owner:self options:nil] lastObject];
					}
					
					timeCustomCell.timeLbl.text = [timeCustomCell getTimeString];
					//[alarmModel autorelease];
					//[minsStr release];
					return timeCustomCell;
					break;
				case 2:
					// Days
					cell.textLabel.text = @"Days";
					
					daysCustomCell = (DaysCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
					if (daysCustomCell == nil) {
						daysCustomCell = [[[NSBundle mainBundle] loadNibNamed:@"DaysCustomCell" owner:self options:nil] lastObject];
					}
					
					daysCustomCell.sundayLbl.hidden = !alarmModel.selectedAlarm.sunday;
					daysCustomCell.mondayLbl.hidden = !alarmModel.selectedAlarm.monday;
					daysCustomCell.tuesdayLbl.hidden = !alarmModel.selectedAlarm.tuesday;
					daysCustomCell.wednesdayLbl.hidden = !alarmModel.selectedAlarm.wednesday;
					daysCustomCell.thursdayLbl.hidden = !alarmModel.selectedAlarm.thursday;
					daysCustomCell.fridayLbl.hidden = !alarmModel.selectedAlarm.friday;
					daysCustomCell.saturdayLbl.hidden = !alarmModel.selectedAlarm.saturday;
					
					return daysCustomCell;
					break;
				case 3:
                {
					// Music
					alarmMusicCustomCell = (AlarmMusicCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
					if (alarmMusicCustomCell == nil) {
						alarmMusicCustomCell = [[[NSBundle mainBundle] loadNibNamed:@"AlarmMusicCustomCell" owner:self options:nil] lastObject];
					}
					
					NSArray *allTracks = [alarmModel.selectedAlarm.alarmMusic items];
					if ([allTracks count] < 1)
					{
						alarmMusicCustomCell.trackNameLbl.text = @"No Music";
						
                        
					}
					else {
						MPMediaItem *item = [allTracks objectAtIndex:0];
						
						NSString *trackName = [item valueForProperty:MPMediaItemPropertyTitle];
						NSString *artist = [item valueForProperty:MPMediaItemPropertyArtist];
						alarmMusicCustomCell.trackNameLbl.text = trackName;
						alarmMusicCustomCell.artistLbl.text = artist;
						
					}
					
					
					return alarmMusicCustomCell;
					break;
                }
				default:
                {
					break;
                }
			}
			break;
		}
		}
		default:
			break;
	}
    return cell;
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
    // Navigation logic may go here. Create and push another view controller.
    
	if (indexPath.section == 1)
	{
		DaysAlarmDetailViewController *daysViewController;
		TimeDetail *timeDetail;
		
		switch (indexPath.row) {
			case 1:
				timeDetail = [[TimeDetail alloc] initWithNibName:@"TimeDetail" bundle:nil];
				[self.navigationController pushViewController:timeDetail animated:YES];
				
				break;
			case 2:
				daysViewController = [[DaysAlarmDetailViewController alloc] initWithNibName:@"Days" bundle:nil];
				[self.navigationController pushViewController:daysViewController animated:YES];
				
				break;
			case 3:
				// go directly to media picker
                
                if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
                   UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    [self selectSongOnIPad];
                    //[self selectSong];+
                    
                }
                else
                {
                    [self selectSong];
				}
                
				break;
			default:
				break;
		}
		
	}
	
    
}

- (void) selectSong {  
	MPMediaPickerController  *picker =
	[[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
	
	picker.delegate                                         = self;
	picker.allowsPickingMultipleItems       = NO;
	picker.prompt                                           = NSLocalizedString (@"Select any song from the list", @"Select a song for the alarm...");
	
    [self presentViewController:picker animated:YES completion:nil];
}


-(void)selectSongOnIPad {
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    picker.delegate = self;
    picker.allowsPickingMultipleItems       = NO;
	picker.prompt    = NSLocalizedString (@"Select any song from the list", @"Select a song for the alarm...");
    // [self presentModalViewController:picker animated:YES];
    // [picker release];
    
    // Init a Navigation Controller, using the MediaPicker as its root view controller
    UINavigationController *theNavController = [[UINavigationController alloc] initWithRootViewController:picker];
    [theNavController setNavigationBarHidden:YES];
    
    // Init the Popover Controller, using the navigation controller as its root view controller
    popOverController = [[UIPopoverController alloc] initWithContentViewController:theNavController];
    
    // dismiss the main popup (can only have 1 popup visible)
    SpeakAlarmAppDelegate *appDelegate = (SpeakAlarmAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.clockViewController.settingsPopoverController dismissPopoverAnimated:NO];
    
    // Make a rect at the size and location of the button I use to invoke the popover
    CGRect popoverRect = CGRectMake(0, 0, 80, 80);
    
    // Specify the size of the popover
    CGSize MySize = CGSizeMake(400, 700);
    
    [popOverController setPopoverContentSize:MySize animated:YES];
    
    // Display the popover
    if (appDelegate.clockViewController.view.window != nil)
        [popOverController presentPopoverFromRect:popoverRect inView:appDelegate.clockViewController.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
}

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
	
    AlarmsModel *sharedManager = [AlarmsModel sharedManager];
	
	[[sharedManager selectedAlarm] setAlarmMusic:mediaItemCollection];
	
	
	[sharedManager saveAlarms];
    
    if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
    {
        [popOverController dismissPopoverAnimated:YES];
        [self.tableView reloadData];
        
        SpeakAlarmAppDelegate *appDelegate = (SpeakAlarmAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.clockViewController showSettingsforIPad:none];
        
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
	
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
	
    if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
    {
        [popOverController dismissPopoverAnimated:YES];
        
        SpeakAlarmAppDelegate *appDelegate = (SpeakAlarmAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.clockViewController showSettingsforIPad:none];
        
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
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




@end

