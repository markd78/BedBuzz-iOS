//
//  ThemeListTableViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ThemeListTableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	NSIndexPath *lastIndexPath;
	UIImagePickerController* imagePickerController;
     UIPopoverController *imagePopoverController;
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
-(NSString *)saveCopyOfChosenImage:(UIImage *)image WithFileName:(NSString *)fileName;
- (NSString*) stringWithUUID ;
- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize;
@property (nonatomic, strong) UIPopoverController *imagePopoverController; 

@end
