//
//  SelectFriendsForMessageViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 8/18/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import "SelectFriendsForMessageViewController.h"
#import "FacebookModel.h"
#import "FriendsListCell.h"
#import "FacebookUser.h"
#import "MessagingModel.h"
#import "ComposeMessageViewController.h"
#import "UIImageView+WebCache.h"
#import "UserModel.h"
#import "SoundDirector.h"

@implementation SelectFriendsForMessageViewController
@synthesize segmentedControl;
@synthesize tableView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        MessagingModel *messagingModel = [MessagingModel sharedManager];
        [messagingModel.targetFriends removeAllObjects];        
    }
    return self;
}

-(void)reloadFriendData
{
    [self.tableView reloadData];
}

-(IBAction)cancel:(id)sender{
	[self.navigationController dismissModalViewControllerAnimated:YES];
} 

-(IBAction)nextBtnClicked:(id)sender{
	[self.navigationController pushViewController: [[ComposeMessageViewController alloc] initWithNibName:@"ComposeMessage" bundle:nil]  animated:YES];
	
} 

- (void)viewWillAppear:(BOOL)animated {
    
    [self addOrRemoveNextButton];
    
    [self reloadFriendData];
}

-(void)popOverWasClosed
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationItem.title = @"Select friends";
    
	isBedBuzzFriendsMode = NO;
	isRecentlyUsedMode = NO;
    
    UserModel *um = [UserModel userModel];
    if (!um.userSettings.heardSelectFriendsMessage)
    {
        SoundDirector *sd = [SoundDirector soundDirector];
        [sd saySelectFriendsHelp];
         
         um.userSettings.heardSelectFriendsMessage = YES;
         [um saveUserSettings];
    }

	if((void *)UI_USER_INTERFACE_IDIOM() == NULL ||
       UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) 
    {

        // Initialize the UIBarButtonItem
        UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                            style: self.navigationController.navigationItem.leftBarButtonItem.style
                                                                           target: self
                                                                           action: @selector(cancel:)];
        
        // Then you can add the aBarButtonItem to the UIToolbar
        self.navigationItem.leftBarButtonItem = aBarButtonItem; 
	}
 /*   
	UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Compose"
																		style: self.navigationController.navigationItem.rightBarButtonItem.style
																	   target: self
																		  action: @selector(nextBtnClicked:)] autorelease];
	
	
	self.navigationItem.rightBarButtonItem = rightBarButtonItem; 	*/
	
}




-(void)addOrRemoveNextButton {
	MessagingModel *messagingModel = [MessagingModel sharedManager];
	
	if ([messagingModel.targetFriends count] > 0  )
	{
		self.navigationItem.rightBarButtonItem.enabled = YES;		
        
        if (composeBtn!=nil)
        {
            composeBtn.enabled = YES;
        }
	}
	else {
		self.navigationItem.rightBarButtonItem.enabled = NO;
        
        if (composeBtn!=nil)
        {
            composeBtn.enabled = NO;
        }
	}
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

// specify the height of your footer section
- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    //differ between your sections or if you
    //have only on section return a static value
    if (section == 0)
    {
        return 45;
    }
    else
    {
        return 10;
    }
    
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 0)
    {
        //allocate the view if it doesn't exist yet
      //  UIView *view  = [[[UIView alloc] init] autorelease];
      //  view.userInteractionEnabled = YES;
        
        UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
        but.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        but.titleLabel.shadowColor = [UIColor blackColor];
        but.titleLabel.shadowOffset = CGSizeMake(0, -1);
        [but setTitle:@"Compose" forState:UIControlStateNormal];
        [but setBackgroundImage:[UIImage imageNamed:@"buttonRed.png"] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        tableView.tableFooterView.contentMode = UIViewContentModeScaleToFill;
        tableView.tableFooterView = but;
        [but release];
        
        //create the button
       /* UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [button setFrame:CGRectMake(10, 20, 300, 44)];
        
        //set title, font size and font color
        [button setTitle:@"Compose Message" forState:UIControlStateNormal];
        [button setBackgroundImage:[[UIImage imageNamed:@"buttonRed.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        
        //set action of the button
        [button addTarget:self action:@selector(nextBtnClicked)
         forControlEvents:UIControlEventTouchUpInside];
        
        //add the button to the view
        [view addSubview:button];
        return view;
    }
    
    return nil;

}*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	
	FacebookModel *fbModel = [FacebookModel sharedManager];
	
	int numberOfFriends;
	
	if (isBedBuzzFriendsMode)
	{
		numberOfFriends= fbModel.friendsListWithBedBuzz.count;
	}
    else if (isRecentlyUsedMode)
    {
        numberOfFriends= fbModel.friendsListRecentlyUsed.count;
    }
	else
	{
		numberOfFriends= fbModel.friendsList.count;
	}
	
	return numberOfFriends;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	FriendsListCell *cell = (FriendsListCell *)[tv dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendsListCell" owner:self options:nil] lastObject];
	}
	
    // Configure the cell...
	// Set up the cell...
	
	FacebookModel *facebookModel = [FacebookModel sharedManager];
	FacebookUser *cellValue;
	
	if (isBedBuzzFriendsMode)
	{
		if ([facebookModel.friendsListWithBedBuzz count]==0)
		{
			return cell;
		}
		cellValue = [facebookModel.friendsListWithBedBuzz objectAtIndex:indexPath.row];
	}
    else if (isRecentlyUsedMode)
    {
		if ([facebookModel.friendsListRecentlyUsed count]==0)
		{
			return cell;
		}
		cellValue = [facebookModel.friendsListRecentlyUsed objectAtIndex:indexPath.row];
        
    }
	else {
		if ([facebookModel.friendsList count]==0)
		{
			return cell;
		}
		cellValue = [facebookModel.friendsList objectAtIndex:indexPath.row];
	}

	
	/*
	NSURL * imageURL = [NSURL URLWithString:cellValue.picSmallURL];
	NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
	UIImage *tableImage = [[UIImage alloc] initWithData:imageData]; */
   /* UIImage *tableImage = [facebookModel.friendsPicsDict objectForKey:cellValue.uid];
	[cell.imageView setImage:tableImage]; 
	cell.imageView.image = tableImage ;*/
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:cellValue.picSmallURL]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    
	cell.nameLbl.text = cellValue.name;
	
	if (cellValue.isTargetForMessage)
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	FacebookModel *facebookModel = [FacebookModel sharedManager]; 
	FacebookUser *fbUserClickedOn;
	
	if (isBedBuzzFriendsMode)
	{
		fbUserClickedOn = [facebookModel.friendsListWithBedBuzz objectAtIndex:indexPath.row];
	}
    else if (isRecentlyUsedMode)
    {
        fbUserClickedOn = [facebookModel.friendsListRecentlyUsed objectAtIndex:indexPath.row];

    }
	else {
		fbUserClickedOn  = [facebookModel.friendsList objectAtIndex:indexPath.row];

	}
	
		
	MessagingModel *messagingModel = [MessagingModel sharedManager];
	
	UITableViewCell *cell = [tv cellForRowAtIndexPath:indexPath];
	
	if (fbUserClickedOn.isTargetForMessage)
	{
		NSUInteger index = [messagingModel.targetFriends indexOfObject:fbUserClickedOn];
		[messagingModel.targetFriends removeObjectAtIndex:index];
		fbUserClickedOn.isTargetForMessage = NO;
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
								
	else {
		[messagingModel.targetFriends addObject:fbUserClickedOn];
		fbUserClickedOn.isTargetForMessage = YES;
		
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	[self addOrRemoveNextButton];
	
	
}

-(IBAction) segmentedControlIndexChanged{
    
    // reset the target friends
    MessagingModel *messagingModel = [MessagingModel sharedManager];
    [messagingModel.targetFriends removeAllObjects];
    
    FacebookModel *fbModel = [FacebookModel sharedManager];
	[fbModel clearTargetFriends];
    
	[self addOrRemoveNextButton];
    
	switch (self.segmentedControl.selectedSegmentIndex) {
		case 0:
			isBedBuzzFriendsMode = NO;
            isRecentlyUsedMode = NO;
			break;
		case 1:
			isBedBuzzFriendsMode = YES;
             isRecentlyUsedMode = NO;
			break;
		/*case 2:
			isBedBuzzFriendsMode = NO;
             isRecentlyUsedMode = YES;
			break;*/
		default:
			break;
			
	}
	
	[self.tableView reloadData];
	
}


@end
