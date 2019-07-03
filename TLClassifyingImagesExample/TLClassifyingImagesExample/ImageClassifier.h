//
// ImageClassifier.h
//
// This file was automatically generated and should not be edited.
//

#import <Foundation/Foundation.h>
#import <CoreML/CoreML.h>
#include <stdint.h>

NS_ASSUME_NONNULL_BEGIN


/// Model Prediction Input Type
API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0)) __attribute__((visibility("hidden")))
@interface ImageClassifierInput : NSObject<MLFeatureProvider>

/// Input image to be classified as color (kCVPixelFormatType_32BGRA) image buffer, 299 pixels wide by 299 pixels high
@property (readwrite, nonatomic) CVPixelBufferRef image;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithImage:(CVPixelBufferRef)image;
@end


/// Model Prediction Output Type
API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0)) __attribute__((visibility("hidden")))
@interface ImageClassifierOutput : NSObject<MLFeatureProvider>

/// Probability of each category as dictionary of strings to doubles
@property (readwrite, nonatomic, strong) NSDictionary<NSString *, NSNumber *> * classLabelProbs;

/// Most likely image category as string value
@property (readwrite, nonatomic, strong) NSString * classLabel;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithClassLabelProbs:(NSDictionary<NSString *, NSNumber *> *)classLabelProbs classLabel:(NSString *)classLabel;
@end


/// Class for model loading and prediction
API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0)) __attribute__((visibility("hidden")))
@interface ImageClassifier : NSObject
@property (readonly, nonatomic, nullable) MLModel * model;
- (nullable instancetype)init;
- (nullable instancetype)initWithContentsOfURL:(NSURL *)url error:(NSError * _Nullable * _Nullable)error;
- (nullable instancetype)initWithConfiguration:(MLModelConfiguration *)configuration error:(NSError * _Nullable * _Nullable)error API_AVAILABLE(macos(10.14), ios(12.0), watchos(5.0), tvos(12.0)) __attribute__((visibility("hidden")));
- (nullable instancetype)initWithContentsOfURL:(NSURL *)url configuration:(MLModelConfiguration *)configuration error:(NSError * _Nullable * _Nullable)error API_AVAILABLE(macos(10.14), ios(12.0), watchos(5.0), tvos(12.0)) __attribute__((visibility("hidden")));

/**
    Make a prediction using the standard interface
    @param input an instance of ImageClassifierInput to predict from
    @param error If an error occurs, upon return contains an NSError object that describes the problem. If you are not interested in possible errors, pass in NULL.
    @return the prediction as ImageClassifierOutput
*/
- (nullable ImageClassifierOutput *)predictionFromFeatures:(ImageClassifierInput *)input error:(NSError * _Nullable * _Nullable)error;

/**
    Make a prediction using the standard interface
    @param input an instance of ImageClassifierInput to predict from
    @param options prediction options
    @param error If an error occurs, upon return contains an NSError object that describes the problem. If you are not interested in possible errors, pass in NULL.
    @return the prediction as ImageClassifierOutput
*/
- (nullable ImageClassifierOutput *)predictionFromFeatures:(ImageClassifierInput *)input options:(MLPredictionOptions *)options error:(NSError * _Nullable * _Nullable)error;

/**
    Make a prediction using the convenience interface
    @param image Input image to be classified as color (kCVPixelFormatType_32BGRA) image buffer, 299 pixels wide by 299 pixels high:
    @param error If an error occurs, upon return contains an NSError object that describes the problem. If you are not interested in possible errors, pass in NULL.
    @return the prediction as ImageClassifierOutput
*/
- (nullable ImageClassifierOutput *)predictionFromImage:(CVPixelBufferRef)image error:(NSError * _Nullable * _Nullable)error;

/**
    Batch prediction
    @param inputArray array of ImageClassifierInput instances to obtain predictions from
    @param options prediction options
    @param error If an error occurs, upon return contains an NSError object that describes the problem. If you are not interested in possible errors, pass in NULL.
    @return the predictions as NSArray<ImageClassifierOutput *>
*/
- (nullable NSArray<ImageClassifierOutput *> *)predictionsFromInputs:(NSArray<ImageClassifierInput*> *)inputArray options:(MLPredictionOptions *)options error:(NSError * _Nullable * _Nullable)error API_AVAILABLE(macos(10.14), ios(12.0), watchos(5.0), tvos(12.0)) __attribute__((visibility("hidden")));
@end

NS_ASSUME_NONNULL_END
