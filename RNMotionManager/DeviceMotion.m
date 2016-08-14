//
//  DeviceMotion.m
//
//  Created by Tuan PM.
//

#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "DeviceMotion.h"

@implementation DeviceMotion

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (id) init {
    self = [super init];
    NSLog(@"DeviceMotion");
    
    if (self) {
        self->_motionManager = [[CMMotionManager alloc] init];
        //Magnetometer
        if([self->_motionManager isDeviceMotionAvailable])
        {
            NSLog(@"deviceMotionAvailable available");
            /* Start the Magnetometer if it is not active already */
            if([self->_motionManager isDeviceMotionActive] == NO)
            {
                NSLog(@"DeviceMotion active");
            } else {
                NSLog(@"DeviceMotion not active");
            }
        }
        else
        {
            NSLog(@"DeviceMotion not Available!");
        }
    }
    return self;
}

RCT_EXPORT_METHOD(setDeviceMotionUpdateInterval:(double) interval) {
    NSLog(@"setDeviceMotionUpdateInterval: %f", interval);
    
    [self->_motionManager setDeviceMotionUpdateInterval:interval];
}

RCT_EXPORT_METHOD(getDeviceMotionUpdateInterval:(RCTResponseSenderBlock) cb) {
    double interval = self->_motionManager.deviceMotionUpdateInterval;
    NSLog(@"getDeviceMotionUpdateInterval: %f", interval);
    cb(@[[NSNull null], [NSNumber numberWithDouble:interval]]);
}

RCT_EXPORT_METHOD(getDeviceMotionData:(RCTResponseSenderBlock) cb) {
    double x = self->_motionManager.deviceMotion.gravity.x;
    double y = self->_motionManager.deviceMotion.gravity.y;
    double z = self->_motionManager.deviceMotion.gravity.z;
    
    NSLog(@"getDeviceMotionData: %f, %f, %f", x, y, z);
    
    cb(@[[NSNull null], @{
             @"gravity": @{
                     @"x" : [NSNumber numberWithDouble:x],
                     @"y" : [NSNumber numberWithDouble:y],
                     @"z" : [NSNumber numberWithDouble:z]
                     }
             }]
       );
}

RCT_EXPORT_METHOD(startDeviceMotionUpdates) {
    NSLog(@"startMagnetometerUpdates");
    [self->_motionManager startDeviceMotionUpdates];
    
    /* Receive the ccelerometer data on this block */
    [self->_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                              withHandler:^(CMDeviceMotion *motionData, NSError *error)
     {
         double x = motionData.gravity.x;
         double y = motionData.gravity.y;
         double z = motionData.gravity.z;
         NSLog(@"startDeviceMotionUpdates: %f, %f, %f", x, y, z);
         
         [self.bridge.eventDispatcher sendDeviceEventWithName:@"MotionData" body:@{
                                                                                         @"gravity": @{
                                                                                                 @"x" : [NSNumber numberWithDouble:x],
                                                                                                 @"y" : [NSNumber numberWithDouble:y],
                                                                                                 @"z" : [NSNumber numberWithDouble:z]
                                                                                                 }
                                                                                         }];
     }];
    
}

RCT_EXPORT_METHOD(stopDeviceMotionUpdates) {
    NSLog(@"stopDeviceMotionUpdates");
    [self->_motionManager stopDeviceMotionUpdates];
}

@end
