//
//  Gyroscope.m
//
//  Created by Patrick Williams in beautiful Seattle, WA.
//

#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import "Gyroscope.h"

@implementation Gyroscope

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (id) init {
    self = [super init];
    NSLog(@"Gyroscope");

    if (self) {
        self->_motionManager = [[CMMotionManager alloc] init];
        //Gyroscope
        if([self->_motionManager isGyroAvailable])
        {
            NSLog(@"Gyroscope available");
            /* Start the gyroscope if it is not active already */
            if([self->_motionManager isGyroActive] == NO)
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

    [self->_motionManager setGyroUpdateInterval:interval];
}

RCT_EXPORT_METHOD(getGyroUpdateInterval:(RCTResponseSenderBlock) cb) {
    double interval = self->_motionManager.gyroUpdateInterval;
    NSLog(@"getGyroUpdateInterval: %f", interval);
    cb(@[[NSNull null], [NSNumber numberWithDouble:interval]]);
}

RCT_EXPORT_METHOD(getGyroData:(RCTResponseSenderBlock) cb) {
    double x = self->_motionManager.gyroData.rotationRate.x;
    double y = self->_motionManager.gyroData.rotationRate.y;
    double z = self->_motionManager.gyroData.rotationRate.z;
    double timestamp = self->_motionManager.gyroData.timestamp;

    NSLog(@"getGyroData: %f, %f, %f, %f", x, y, z, timestamp);

    cb(@[[NSNull null], @{
             @"rotationRate": @{
                     @"x" : [NSNumber numberWithDouble:x],
                     @"y" : [NSNumber numberWithDouble:y],
                     @"z" : [NSNumber numberWithDouble:z],
                     @"timestamp" : [NSNumber numberWithDouble:timestamp]
                     }
             }]
       );
}

RCT_EXPORT_METHOD(startGyroUpdates) {
    NSLog(@"startGyroUpdates");
    [self->_motionManager startGyroUpdates];

    /* Receive the gyroscope data on this block */
    [self->_motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue]
                                      withHandler:^(CMGyroData *gyroData, NSError *error)
     {
         double x = gyroData.rotationRate.x;
         double y = gyroData.rotationRate.y;
         double z = gyroData.rotationRate.z;
         double timestamp = gyroData.timestamp;
         NSLog(@"startGyroUpdates: %f, %f, %f, %f", x, y, z, timestamp);

         [self.bridge.eventDispatcher sendDeviceEventWithName:@"GyroData" body:@{
                                                                                 @"rotationRate": @{
                                                                                         @"x" : [NSNumber numberWithDouble:x],
                                                                                         @"y" : [NSNumber numberWithDouble:y],
                                                                                         @"z" : [NSNumber numberWithDouble:z],
                                                                                         @"timestamp" : [NSNumber numberWithDouble:timestamp]
                                                                                         }
                                                                                 }];
     }];

}

RCT_EXPORT_METHOD(stopGyroUpdates) {
    NSLog(@"stopGyroUpdates");
    [self->_motionManager stopGyroUpdates];
}

@end
