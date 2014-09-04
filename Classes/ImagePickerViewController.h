//
//  ImagePickerViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 8/4/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImagePickerViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	UIImagePickerController* imagePickerController;
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;

@end
