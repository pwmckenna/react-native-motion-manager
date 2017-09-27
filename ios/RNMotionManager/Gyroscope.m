//
//  Gyroscope.m
//
//  Created by Patrick Williams in beautiful Seattle, WA.
//

#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "Gyroscope.h"

@interface Gyroscope()

@property (nonatomic, readonly, nonnull) CMMotionManager* motionManager;

+ (NSDictionary*) dictionaryFromGyroData:(CMGyroData*)gyroData;

@end


@implementation Gyroscope

@synthesize motionManager = _motionManager;

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (id) init {
    self = [super init];
    NSLog(@"Gyroscope");

    if (self) {
        self->_motionManager = [[CMMotionManager alloc] init];
        //Gyroscope
        if(self.motionManager.gyroAvailable)
        {
            NSLog(@"Gyroscope available");
            /* Start the gyroscope if it is not active already */
            if(self.motionManager.gyroActive)
            {
                NSLog(@"Gyroscope active");
            } else {
                NSLog(@"Gyroscope not active");
            }
        }
        else
        {
            NSLog(@"Gyroscope not Available!");
        }
    }
    return self;
}

RCT_EXPORT_METHOD(setGyroUpdateInterval:(double) interval) {
    NSLog(@"setGyroUpdateInterval: %f", interval);

    self.motionManager.gyroUpdateInterval = interval;
}

RCT_EXPORT_METHOD(getGyroUpdateInterval:(nonnull RCTResponseSenderBlock) cb) {
    double interval = self.motionManager.gyroUpdateInterval;
    NSLog(@"getGyroUpdateInterval: %f", interval);
    cb(@[[NSNull null], [NSNumber numberWithDouble:interval]]);
}

RCT_EXPORT_METHOD(getGyroData:(nonnull RCTResponseSenderBlock) cb) {
    CMGyroData* gyroData = self.motionManager.gyroData;
    
    NSLog(@"getGyroData: %f, %f, %f, %f", gyroData.rotationRate.x, gyroData.rotationRate.y, gyroData.rotationRate.z, gyroData.timestamp);

    cb(@[ [NSNull null], [Gyroscope dictionaryFromGyroData: gyroData] ]);
}

RCT_EXPORT_METHOD(startGyroUpdates:(nonnull RCTResponseSenderBlock) cb) {
    NSLog(@"startGyroUpdates");

    [self.motionManager startGyroUpdates];
    
    /* Receive the gyroscope data on this block */
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error)
    {
         NSLog(@"startGyroUpdates: %f, %f, %f, %f", gyroData.rotationRate.x, gyroData.rotationRate.y, gyroData.rotationRate.z, gyroData.timestamp);

         [self.bridge.eventDispatcher sendDeviceEventWithName:@"GyroData" body: [Gyroscope dictionaryFromGyroData: gyroData]];
    }];
    
    cb(@[[NSNull null]]);
}

RCT_EXPORT_METHOD(stopGyroUpdates) {
    NSLog(@"stopGyroUpdates");
    [self.motionManager stopGyroUpdates];
}

+ (NSDictionary*) dictionaryFromGyroData:(CMGyroData*)gyroData {
    return @{
             @"rotationRate": @{
                     @"x" : [NSNumber numberWithDouble:gyroData.rotationRate.x],
                     @"y" : [NSNumber numberWithDouble:gyroData.rotationRate.y],
                     @"z" : [NSNumber numberWithDouble:gyroData.rotationRate.z],
                     @"timestamp" : [NSNumber numberWithDouble:gyroData.timestamp]
                     }
             };
}

@end
