//
//  ThemeListTableViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ThemeListTableViewController.h"
#import "ImagePickerViewController.h"
#import "ThemesModel.h"
#import "ThemeListCell.h"
#import "Theme.h"
#import "UserModel.h"
#import "SpeakAlarmAppDelegate.h"
#import "Utilities.h"

@implementation ThemeListTableViewController
@synthesize imagePopoverController;
#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *addButton;
	
    if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
       addButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddThemeClickedIPad)];
    }
    else
    {
        addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addThemeClicked)];
    }
	self.navigationItem.rightBarButtonItem = addButton;	
	
	self.tableView.rowHeight = 120;
	
	
}

-(void)addThemeClicked
{
	// Set up the image picker controller and add it to the view
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self; 
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.navigationBar.tintColor =  self.navigationController.navigationBar.tintColor;
    imagePickerController.navigationBar.barStyle =self.navigationController.navigationBar.barStyle; 
	 [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
	
}

-(void)AddThemeClickedIPad
{
    SpeakAlarmAppDelegate *appDelegate = (SpeakAlarmAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // Set up the image picker controller and add it to the view
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.navigationBar.tintColor =  self.navigationController.navigationBar.tintColor;
    imagePickerController.navigationBar.barStyle =self.navigationController.navigationBar.barStyle; 
    
    
    [appDelegate.clockViewController.settingsPopoverController dismissPopoverAnimated:NO];
    
    imagePickerController.delegate = self; 
   
    UIPopoverController *controller2 = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
    
    
    self.imagePopoverController = controller2; 
    
    /*CGRect popoverRect = [self.view convertRect:[appDelegate.clockViewController.settingsBtn frame] 
                                       fromView:[appDelegate.clockViewController.settingsBtn superview]];*/
    
    CGRect popoverRect = CGRectMake(0, 0, 80, 80);
    
    // Specify the size of the popover
    CGSize MySize = CGSizeMake(400, 700);
    
    [imagePopoverController setPopoverContentSize:MySize animated:YES];
    
    
    popoverRect.size.width = MIN(popoverRect.size.width, 100); 
    [self.imagePopoverController 
     presentPopoverFromRect:popoverRect 
     inView:appDelegate.clockViewController.view
     permittedArrowDirections:UIPopoverArrowDirectionLeft 
     animated:YES];   
}

- (void)imagePickerController:(UIImagePickerController *)picker 
		didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo
{
	
	// Dismiss the image selection, hide the picker and
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
    [NSThread detachNewThreadSelector:@selector(saveImageThread:) toTarget:self withObject:image];
    
    if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [imagePopoverController dismissPopoverAnimated:NO];    
        SpeakAlarmAppDelegate *appDelegate = (SpeakAlarmAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.clockViewController showSettingsforIPad:none];
    }
}

-(void)saveImageThread:(UIImage *)image
{
    
	@autoreleasepool {
    
	// save the image
		NSString *fileName = [NSString stringWithFormat:@"userTheme-%@.png",
							  [self stringWithUUID]];
		NSString *fileNameOfImage = [self saveCopyOfChosenImage:image WithFileName:fileName];
		
		// save a thumbnail of the image
		CGSize sz = CGSizeMake(300, 163);
		NSString *fileNameThumb = [NSString stringWithFormat:@"userThemeThumb-%@.png",
							  [self stringWithUUID]];
		UIImage *thumbImage =  [self imageWithImage:image scaledToSize:sz];
		NSString *fileNameOfThumbImage = [self saveCopyOfChosenImage:thumbImage WithFileName:fileNameThumb];
		
		//add the theme to the list
		ThemesModel *themesModel = [ThemesModel sharedInstance];
		
		NSInteger numberOfCustomThemes = [themesModel.userThemes count]+1;
		
		Theme *theme1 = [[Theme alloc] init];
		theme1.themeName = [NSString stringWithFormat:@"User Added %li",(long)numberOfCustomThemes ];
		theme1.imageDescription = @"";
		theme1.imageName=fileNameOfImage;
		theme1.thumbnailImage = fileNameOfThumbImage;
		theme1.style = @"normal";
		theme1.textColor = @"0xffffff";
		theme1.isUserTheme = YES;
		
		[themesModel addNewUserTheme:theme1];
		
		//reload the table data
		[self.tableView reloadData];
    
    }
}

- (NSString*) stringWithUUID {
	CFUUIDRef	uuidObj = CFUUIDCreate(nil);//create a new UUID
	//get the string representation of the UUID
	NSString	*uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
	CFRelease(uuidObj);
	return uuidString;
}

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize
{
    CGFloat targetWidth = newSize.width;
    CGFloat targetHeight = newSize.height;
	
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
	
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
	
    CGContextRef bitmap;
	
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		
    }   
	
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, DEGREES_TO_RADIANS(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
		
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, DEGREES_TO_RADIANS(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
		
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, DEGREES_TO_RADIANS(-180.));
    }
	
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
	
    CGContextRelease(bitmap);
    CGImageRelease(ref);
	
    return newImage; 
}

-(NSString *)saveCopyOfChosenImage:(UIImage *)image WithFileName:(NSString *)fileName
{
	
	NSData *imageData = UIImagePNGRepresentation(image);
	
    NSString *imageName = fileName;
	
    // Find the path to the documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
    // Now we get the full path to the file
    NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
	
    // Write out the data.
    [imageData writeToFile:fullPathToFile atomically:NO];
	
	
	return fullPathToFile;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	
	// Dismiss the image selection
	
	[imagePickerController dismissViewControllerAnimated:YES completion:nil];
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
	ThemesModel *themesModel = [ThemesModel sharedInstance];
	NSInteger numberOfThemes = [themesModel.themes count];
    return numberOfThemes;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	ThemesModel *themesModel = [ThemesModel sharedInstance];
	Theme *theme = [themesModel.themes objectAtIndex:indexPath.row];
	
	
    ThemeListCell *cell =(ThemeListCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"ThemeListCustomCell" owner:self options:nil] lastObject];
	}
	
   
    
    // Configure the cell...
	if (theme.isUserTheme)
	{
         NSString *thumbnailImageFile = [Utilities GetDoucmentsPathForFile:theme.thumbnailImage];
		cell.thumbnail.image =  [UIImage imageWithContentsOfFile:thumbnailImageFile];
	}
	else {
		cell.thumbnail.image =  [UIImage imageNamed:theme.thumbnailImage];

	}

	cell.titleLbl.text = theme.themeName;
	cell.descriptionLbl.text = theme.imageDescription;
	cell.theme = theme;
	
	UserModel *userModel = [UserModel userModel];
	
	if ([userModel.userSettings.themeName isEqualToString:theme.themeName])
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		lastIndexPath = indexPath;
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
	NSInteger oldRow = [lastIndexPath row];
	
	if (lastIndexPath == nil)
	{
		oldRow = -1;
	}
	
	if (newRow != oldRow)
	{
        ThemeListCell *newCell = (ThemeListCell *)[tableView cellForRowAtIndexPath:
									indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:
									lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
		
        lastIndexPath = indexPath;
		
		UserModel *userModel = [UserModel userModel];
		userModel.userSettings.themeName = newCell.theme.themeName;
		userModel.userSettings.currentThemeImageName = newCell.theme.imageName;
		
		if (newCell.theme.isUserTheme)
		{
			userModel.userSettings.isUserTheme = YES;
		}
		else {
			userModel.userSettings.isUserTheme = NO;
            
            if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
               UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
             
                // add -ipad to the name
                userModel.userSettings.currentThemeImageName = [userModel.userSettings.currentThemeImageName stringByReplacingOccurrencesOfString:@".jpg" withString:@"-ipad.jpg"];
                
            }
		}

		
		[userModel saveUserSettings];
        
        if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
           UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
         
            // need to refresh the screen
             SpeakAlarmAppDelegate *appDelegate = (SpeakAlarmAppDelegate*)[[UIApplication sharedApplication] delegate];
            
            [appDelegate.clockViewController drawScreen];
        }
	}
	
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

