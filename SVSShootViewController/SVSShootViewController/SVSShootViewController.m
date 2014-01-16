//
//  ViewController.m
//  SVSShootViewController
//
//  1/8/14.
//
//

#define LOG_VISION 1

@import AssetsLibrary;

#import <PBJVision/PBJVision.h>

#import "SVSShootViewController.h"

@interface SVSShootViewController () <PBJVisionDelegate>
@property(nonatomic) PBJVision *camera;
@property(nonatomic) BOOL isSaveSession;
@property(nonatomic, weak) IBOutlet UIProgressView *progressView;
@property(nonatomic, weak) IBOutlet UIView *previewView;
@end

float const SVSShootViewControllerDefaultRecordingSeconds = 6.0f;

@implementation SVSShootViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if(!self){
    return nil;
  }
  
  _maxRecoringSeconds = SVSShootViewControllerDefaultRecordingSeconds;
  
  _camera = [[PBJVision alloc] init];
  _camera.cameraMode = PBJCameraModeVideo;
  // Front Cam
  //_camera.cameraDevice = PBJCameraDeviceFront;
  _camera.delegate = self;
  
  _isSaveSession = NO;
  
  return self;
}

- (void)dealloc
{
  [_camera stopPreview];
  [_camera endVideoCapture];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	
  [self startCamera];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Camera

- (void)startCamera
{
  [self.camera endVideoCapture];
  [self.camera stopPreview];
  
  [self.camera startPreview];
  
  self.progressView.progress = 0;
}

#pragma mark - PBJVisionDelegate

- (void)visionSessionDidStart:(PBJVision *)vision
{
  if(CGRectEqualToRect(vision.previewLayer.frame, CGRectZero)){
    vision.previewLayer.frame = self.previewView.frame;
    vision.previewLayer.videoGravity = AVLayerVideoGravityResize;
    [self.previewView.layer addSublayer:vision.previewLayer];
  }
}

- (void)vision:(PBJVision *)vision capturedVideo:(NSDictionary *)videoDict error:(NSError *)error
{
  NSString *path = videoDict[PBJVisionVideoPathKey];
  if(self.isSaveSession && path){
    [self pushVideoViewControllerWithPath:path];
    
    // 自動保存
    /*
    [[ALAssetsLibrary new] writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:path] completionBlock:^(NSURL *assetURL, NSError *error) {
      NSLog(@"Save : %@", assetURL);
    }];
     */
  }
  
  self.isSaveSession = NO;
}

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)gesture
{
  if(gesture.state == UIGestureRecognizerStateBegan){
    if(!self.camera.isRecording){
      [self.camera startVideoCapture];
    }else{
      [self.camera resumeVideoCapture];
    }
  }else if(gesture.state == UIGestureRecognizerStateEnded){
    [self.camera pauseVideoCapture];
  }
  

  float progress = (self.camera.capturedVideoSeconds >= self.maxRecoringSeconds)? 1.0: self.camera.capturedVideoSeconds/self.maxRecoringSeconds;
  [self.progressView setProgress:progress animated:YES];
}

- (IBAction)onSaveButton:(id)sender
{
  self.isSaveSession = YES;
  [self.camera endVideoCapture];
}

- (IBAction)onFlushButton:(id)sender
{
  [self startCamera];
}

#pragma mark - App Sequense

- (void)pushVideoViewControllerWithPath:(NSString *)path
{
  UIVideoEditorController *controller = [[UIVideoEditorController alloc] init];
  controller.videoPath = path;
  [self presentViewController:controller animated:YES completion:nil];
}

@end