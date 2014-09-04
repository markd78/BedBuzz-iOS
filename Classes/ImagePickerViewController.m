//
//  ImagePickerViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 8/4/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import "ImagePickerViewController.h"


@implementation ImagePickerViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Set up the image picker controller and add it to the view
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = 
	UIImagePickerControllerSourceTypePhotoLibrary;
	
	[self.view addSubview:imagePickerController.view];
}


// from PickImageAppDelegate.m
- (void)imagePickerController:(UIImagePickerController *)picker 
		didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo
{
	
	// Dismiss the image selection, hide the picker and
	
	//show the image view with the picked image
	
	[picker dismissModalViewControllerAnimated:YES];
    imagePickerController.view.hidden = YES;
	
	// now go back
}

// from PickImageAppDelegate.m
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	
	// Dismiss the image selection 	
	[picker dismissModalViewControllerAnimated:YES];
	
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




@end
