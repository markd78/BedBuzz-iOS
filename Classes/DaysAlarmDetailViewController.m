//
//  DaysAlarmDetailViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DaysAlarmDetailViewController.h"
#import "AlarmsModel.h"

@implementation DaysAlarmDetailViewController


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

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
    return 7;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	
	
	AlarmsModel *alarmsModel = [AlarmsModel sharedManager];

    // Configure the cell...
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"Sunday";
			if (alarmsModel.selectedAlarm.sunday) { 
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			break;
		case 1:
			cell.textLabel.text = @"Monday";
			if (alarmsModel.selectedAlarm.monday) { 
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			break;
		case 2:
			cell.textLabel.text = @"Tuesday";
			if (alarmsModel.selectedAlarm.tuesday) { 
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			break;
		case 3:
			cell.textLabel.text = @"Wednesday";
			if (alarmsModel.selectedAlarm.wednesday) { 
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			break;
		case 4:
			cell.textLabel.text = @"Thursday";
			if (alarmsModel.selectedAlarm.thursday) { 
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			break;
		case 5:
			cell.textLabel.text = @"Friday";
			if (alarmsModel.selectedAlarm.friday) { 
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			break;
		case 6:
			cell.textLabel.text = @"Saturday";
			if (alarmsModel.selectedAlarm.saturday) { 
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
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
    
	AlarmsModel *alarmsModel = [AlarmsModel sharedManager];
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	
	
	switch (indexPath.row) {
		case 0:
			// sunday
			alarmsModel.selectedAlarm.sunday = !alarmsModel.selectedAlarm.sunday;
			
			if (alarmsModel.selectedAlarm.sunday) { 
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			
			break;
		case 1:
			// monday
			alarmsModel.selectedAlarm.monday = !alarmsModel.selectedAlarm.monday;
			
			if (alarmsModel.selectedAlarm.monday) { 
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			
			break;
		case 2:
			// tuesday
			alarmsModel.selectedAlarm.tuesday = !alarmsModel.selectedAlarm.tuesday;
			
			if (alarmsModel.selectedAlarm.tuesday) { 
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			
			break;
		case 3:
			// wednesday
			alarmsModel.selectedAlarm.wednesday = !alarmsModel.selectedAlarm.wednesday;
			
			if (alarmsModel.selectedAlarm.wednesday) { 
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			
			break;
		case 4:
			// thursday
			alarmsModel.selectedAlarm.thursday = !alarmsModel.selectedAlarm.thursday;
			
			if (alarmsModel.selectedAlarm.thursday) { 
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			
			break;
		case 5:
			// friday
			alarmsModel.selectedAlarm.friday = !alarmsModel.selectedAlarm.friday;
			
			if (alarmsModel.selectedAlarm.friday) { 
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			
			break;
		case 6:
			// saturday
			alarmsModel.selectedAlarm.saturday = !alarmsModel.selectedAlarm.saturday;
			
			if (alarmsModel.selectedAlarm.saturday) { 
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			
			break;
		default:
			break;
	}
	
	[alarmsModel saveAlarms];
	
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

