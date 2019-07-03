//
//  ViewController.m
//  TLClassifyingImagesExample
//
//  Created by lx on 2019/7/3.
//  Copyright © 2019 tinlin. All rights reserved.
//

#import "ViewController.h"

#import <CoreML/CoreML.h>
#import <ImageIO/ImageIO.h>
#import <Vision/Vision.h>
#import "ImageClassifier.h"

@interface ViewController ()

@property(nonatomic, strong) UILabel *textLabel;

@property(nonatomic, strong) VNCoreMLRequest *classificationRequest;

@property(nonatomic, strong) ImageClassifier *imageClassifier;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.f, 120.f, 200.f, 200)];
    textLabel.textColor = [UIColor blackColor];
    textLabel.numberOfLines = 0;
    [self.view addSubview:textLabel];
    self.textLabel = textLabel;
    
    // 方式一
//    NSError *error;
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"ImageClassifier" ofType:@"mlmodelc"];
//    MLModelConfiguration *configuration = [[MLModelConfiguration alloc] init];
//    MLModel *mlmodel = [MLModel modelWithContentsOfURL:[NSURL fileURLWithPath:path] configuration:configuration error:nil];
//    VNCoreMLModel *model = [VNCoreMLModel modelForMLModel:mlmodel error:&error];
//    __weak __typeof(self)weakSelf = self;
//    self.classificationRequest = [[VNCoreMLRequest alloc] initWithModel:model completionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        [strongSelf processClassificationsWithRequest:request error:error];
//    }];
//
//    [self updateClassificationsWithImage:[UIImage imageNamed:@"cat"]];
    
    // 方式二
    UIImage *image = [UIImage imageNamed:@"dog"];
    NSError *error;
    self.imageClassifier = [[ImageClassifier alloc] initWithConfiguration:[MLModelConfiguration new] error:&error];
    ImageClassifierOutput *output = [self.imageClassifier predictionFromImage:[self pixelBufferFromCGImage:image.CGImage] error:&error];
    self.textLabel.text = [output.classLabelProbs description];
}

- (void)updateClassificationsWithImage:(UIImage *)image {

//    CGImagePropertyOrientation orientation = image.imageOrientation;
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCIImage:ciImage orientation:kCGImagePropertyOrientationUp options:@{}];
        NSError *error;
        @try {
            [handler performRequests:@[self.classificationRequest] error:&error];
        } @catch (NSException *exception) {
            NSLog(@"%@", [NSString stringWithFormat:@"Failed to perform classification.\n %@",error.localizedDescription]);
        } @finally {
            
        }
    });
}

- (void)processClassificationsWithRequest:(VNRequest *)request error:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!request.results) {
            NSLog(@"%@", [NSString stringWithFormat:@"Unable to classify image.\n %@)",error.localizedDescription]);
            return;
        }
        NSString *text = @"";
        for (VNClassificationObservation *classification in request.results) {
            text = [NSString stringWithFormat:@"%@ \n  (%.2f) %@",text,classification.confidence,classification.identifier];
        }
        self.textLabel.text = text;
    });
}

- (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image
{
    NSDictionary *options = @{
                              (NSString*)kCVPixelBufferCGImageCompatibilityKey : @YES,
                              (NSString*)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES,
                              (NSString*)kCVPixelBufferIOSurfacePropertiesKey: [NSDictionary dictionary]
                              };
    CVPixelBufferRef pxbuffer = NULL;
    
    CGFloat frameWidth = CGImageGetWidth(image);
    CGFloat frameHeight = CGImageGetHeight(image);
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          frameWidth,
                                          frameHeight,
                                          kCVPixelFormatType_32BGRA,
                                          (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 frameWidth,
                                                 frameHeight,
                                                 8,
                                                 CVPixelBufferGetBytesPerRow(pxbuffer),
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    CGContextDrawImage(context, CGRectMake(0,
                                           0,
                                           frameWidth,
                                           frameHeight),
                       image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

@end
