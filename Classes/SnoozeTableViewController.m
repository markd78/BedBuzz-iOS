//
//  SnoozeTableViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SnoozeTableViewController.h"
#import "UserModel.h"

@implementation SnoozeTableViewController
@synthesize lastIndexPath;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    lastIndexPath = nil;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 8;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	UserModel *userModel = [UserModel userModel];
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryNone;
	
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"3 mins";
			if (userModel.userSettings.snoozeLength == 3)
			{
				cell.accessoryType = UITableViewCellAccessoryCheckmark;			
				
				self.lastIndexPath = indexPath;
			}
			break;
		case 1:
			cell.textLabel.text = @"5 mins";
			if (userModel.userSettings.snoozeLength == 5)
			{
				cell.accessoryType = UITableViewCellAccessoryCheckmark;	
				
				self.lastIndexPath = indexPath;
			}
			break;
		case 2:
			cell.textLabel.text = @"8 mins";
			if (userModel.userSettings.snoozeLength == 8)
			{
				cell.accessoryType = UITableViewCellAccessoryCheckmark;	
				self.lastIndexPath = indexPath;			
			}
			break;
		case 3:
			cell.textLabel.text = @"10 mins";
			if (userModel.userSettings.snoozeLength == 10)
			{
				cell.accessoryType = UITableViewCellAccessoryCheckmark;	
				self.lastIndexPath = indexPath;			
			}
			break;
		case 4:
			cell.textLabel.text = @"15 mins";
			if (userModel.userSettings.snoozeLength == 15)
			{
				cell.accessoryType = UITableViewCellAccessoryCheckmark;		
				self.lastIndexPath = indexPath;		
			}
			break;
		case 5:
			cell.textLabel.text = @"20 mins";
			if (userModel.userSettings.snoozeLength == 20)
			{
				cell.accessoryType = UITableViewCellAccessoryCheckmark;	
				self.lastIndexPath = indexPath;			
			}
			break;
		case 6:
			cell.textLabel.text = @"25 mins";
			if (userModel.userSettings.snoozeLength == 25)
			{
				cell.accessoryType = UITableViewCellAccessoryCheckmark;	
				self.lastIndexPath = indexPath;			
			}
			break;
		case 7:
			cell.textLabel.text = @"30 mins";
			if (userModel.userSettings.snoozeLength == 30)
			{
				cell.accessoryType = UITableViewCellAccessoryCheckmark;		
				self.lastIndexPath = indexPath;		
			}
			break;
		
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
    
	NSInteger newRow = [indexPath row];
	NSInteger oldRow = [self.lastIndexPath row];
	UserModel *userModel = [UserModel userModel];
	
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
			// @"3 mins";
			userModel.userSettings.snoozeLength = 3;
			
			break;
		case 1:
			// @"5 mins";
			userModel.userSettings.snoozeLength = 5;
			
			break;
		case 2:
			userModel.userSettings.snoozeLength = 8;
			
			break;
		case 3:
			//@"10 mins";
			userModel.userSettings.snoozeLength = 10;
			
			break;
		case 4:
			// @"15 mins";
			userModel.userSettings.snoozeLength = 15;
			
			break;
		case 5:
			// @"20 mins";
			userModel.userSettings.snoozeLength = 20;
			
			break;
		case 6:
			// @"25 mins";
			userModel.userSettings.snoozeLength = 25;
			
			break;
		case 7:
			// @"30 mins";
			userModel.userSettings.snoozeLength = 30;
			
			break;
		default:
			break;
	}
	
	[userModel saveUserSettings];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
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

