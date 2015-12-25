//
//  CameraViewController.h
//  Project
//
//  Created by Adi Azarya on 23/12/2015.
//  Copyright © 2015 Adi Azarya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController


- (IBAction)takePhoto:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *FramForCapture;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
