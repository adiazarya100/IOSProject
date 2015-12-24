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
    session =[[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    if([session canAddInput:deviceInput]){
        [session addInput:deviceInput];
    }
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [[self view]layer];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = self.FramForCapture.frame;
    
    [previewLayer setFrame:frame];
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    
    //create stills image
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outPutSetting = [[NSDictionary alloc]initWithObjectsAndKeys:AVVideoCodecJPEG , AVVideoCodecKey,nil];
    [stillImageOutput setOutputSettings:outPutSetting];
    
    [session addOutput:stillImageOutput];
    [session startRunning];
    
    

}


- (IBAction)takePhoto:(id)sender {
    AVCaptureConnection *videoConnection =  nil;
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
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if(imageDataSampleBuffer!= NULL){
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            self.imageView.image = image;
            
        }
    }];
}
@end
