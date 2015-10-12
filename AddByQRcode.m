//
//  AddByQRcode.m
//  TeamFive
//
//  Created by yishain chen on 2015/10/10.
//  Copyright © 2015年 yishain. All rights reserved.
//

#import "AddByQRcode.h"
#import <AVFoundation/AVFoundation.h>
@interface AddByQRcode () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation AddByQRcode

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isReading = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadBeepSound{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        [_audioPlayer prepareToPlay];
    }
}

- (AVCaptureSession *)captureSession
{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer
{
    if (!_videoPreviewLayer) {
        _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession: self.captureSession];
        [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [_videoPreviewLayer setFrame:_PreviewView.layer.bounds];
    }
    return _videoPreviewLayer;
}
- (IBAction)startStopReading:(UIBarButtonItem *)sender {
    if (!_isReading) {
        if ([self startReading]) {
            [_startBarItem setTitle:@"Stop"];
            [_statusLabel setText:@"Scanning for QR Code..."];
        }
    }
    else{
        [self stopReading];
        [_startBarItem setTitle:@"Start!"];
    }
    _isReading = !_isReading;
}

- (BOOL)startReading {
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    [self.captureSession addInput:input];
    [self.captureSession addOutput:captureMetadataOutput];
    
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    [self.PreviewView.layer addSublayer:self.videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [_statusLabel performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [_startBarItem performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
            _isReading = NO;
            
            if (_audioPlayer) {
                [_audioPlayer play];
            }
        }
    }
}

@end
