//
//  RSSFeedsViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 9/21/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import "RSSFeedsViewController.h"
#import "RSSDetailViewController.h"
#import "RSSModel.h"
#import "RSSFeed.h"
#import "RSSFeedCell.h"

@implementation RSSFeedsViewController
@synthesize rssFeedsTableView;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFeedClicked)];
	self.navigationItem.rightBarButtonItem = addButton;	
	
	self.navigationController.title = @"RSS Feeds";
	
	self.rssFeedsTableView.rowHeight = 120;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (IBAction)editBtnClicked:(id)sender
{
	if (!self.rssFeedsTableView.editing)
	{
		[editButton setTitle:@"Done"  forState:UIControlStateNormal] ;
		
		[self.rssFeedsTableView setEditing: YES animated: YES];
	}
	else {
		[editButton setTitle:@"Edit"  forState:UIControlStateNormal] ;

		
		[self.rssFeedsTableView setEditing: NO animated: YES];
	}

}
	
-(void)addFeedClicked
{
	RSSFeed *newFeed = [[RSSFeed alloc] init];
	newFeed.voiceName = @"usenglishmale1";
	RSSDetailViewController *detailViewController = [[RSSDetailViewController alloc] initWithNibName:@"RSSDetail" bundle:nil andRSSFeed:newFeed isNew:YES];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
	
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self.rssFeedsTableView reloadData];
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
    return 1;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		// delete the alarm
		RSSModel *rssModel = [RSSModel sharedManager];
		RSSFeed *rssFeedCellValue = [[rssModel rssFeeds] objectAtIndex:indexPath.row];
		NSInteger index = [rssModel.rssFeeds indexOfObject:rssFeedCellValue];
		[rssModel.rssFeeds removeObjectAtIndex:index];
		[rssModel saveRSSFeeds];
		
		[self.rssFeedsTableView reloadData];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	RSSModel *rssModel = [RSSModel sharedManager];
	NSInteger numberOfRSSFeeds = [rssModel.rssFeeds count];
    return numberOfRSSFeeds;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *rssCellIdentifier = @"RSSCell";
	RSSModel *rssModel = [RSSModel sharedManager];
    RSSFeed *rssFeedCellValue = [[rssModel rssFeeds] objectAtIndex:indexPath.row];
	
    RSSFeedCell *rssFeedCell = (RSSFeedCell *)[tableView dequeueReusableCellWithIdentifier:rssCellIdentifier];
	
	if (rssFeedCell == nil) {
		rssFeedCell = [[[NSBundle mainBundle] loadNibNamed:@"RSSCellRenderer" owner:self options:nil] lastObject];
		rssFeedCell.nameLbl.text = rssFeedCellValue.feedName;
		rssFeedCell.linkLbl.text = rssFeedCellValue.feedLink;
        rssFeedCell.enabledSwitch.on = rssFeedCellValue.enabled;
	}
	
	
	return rssFeedCell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	RSSModel *rssModel = [RSSModel sharedManager];
    RSSFeed *selectedFeed = [[rssModel rssFeeds] objectAtIndex:indexPath.row]; 
	
    RSSDetailViewController *detailViewController = [[RSSDetailViewController alloc] initWithNibName:@"RSSDetail" bundle:nil andRSSFeed:selectedFeed isNew:NO];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    
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

