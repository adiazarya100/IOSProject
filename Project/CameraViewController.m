//
//  CameraViewController.m
//  Project
//
//  Created by Adi Azarya on 23/12/2015.
//  Copyright © 2015 Adi Azarya. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation CameraViewController
AVCaptureSession *session;
AVCaptureStillImageOutput *stillImageOutput;

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    //all the things that belong to the backend!
    session =[[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    //represent the camera device- that able to take photos.
    //AVMediaTypeVideo -  control front/back camera.
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    //create the input-for recognizing by frontend.
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    if([session canAddInput:deviceInput]){
        [session addInput:deviceInput];
    }
    
    //actually what you see on the display from the camera.
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [[self view]layer];
    [rootLayer setMasksToBounds:YES];
    
    //FramForCapture- is the gray rectangle we made on the story borad.
    CGRect frame = self.FramForCapture.frame;
    
    [previewLayer setFrame:frame];
    //rootLayer - represent the layer for display.
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    //create stills image
    stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    //setting for capturing phtos.
    NSDictionary *outPutSetting = [[NSDictionary alloc]initWithObjectsAndKeys:AVVideoCodecJPEG , AVVideoCodecKey,nil];
    // set the settings.
    [stillImageOutput setOutputSettings:outPutSetting];
    
    //add the session to the code above(jsut the camera stills image code)
    [session addOutput:stillImageOutput];
    [session startRunning];

}


- (IBAction)takePhoto:(id)sender {
    AVCaptureConnection *videoConnection =  nil;
    //how many outputs do we have.(validation)
    for(AVCaptureConnection *connection in stillImageOutput.connections){
        for(AVCaptureInputPort *port in [connection inputPorts]){
            if([[port mediaType]isEqual:AVMediaTypeVideo]){
                videoConnection = connection;
                break;
            }
        }
        if(videoConnection){
            break;
        }
    }
    //capture the image in the backround without interrupt.
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if(imageDataSampleBuffer!= NULL){
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            //this will set the image on the small rectangle that we made on the storyboard.
            self.imageView.image = image;
            
        }
    }];
}
@end
