//
//  Accelerometer.m
//
//  Created by Patrick Williams in beautiful Seattle, WA.
//

#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import "Accelerometer.h"

@implementation Accelerometer

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (id) init {
  self = [super init];
  NSLog(@"Accelerometer");

  if (self) {
    self->_motionManager = [[CMMotionManager alloc] init];
    //Accelerometer
    if([self->_motionManager isAccelerometerAvailable])
    {
      NSLog(@"Accelerometer available");
      /* Start the accelerometer if it is not active already */
      if([self->_motionManager isAccelerometerActive] == NO)
      {
        NSLog(@"Accelerometer active");
      } else {
        NSLog(@"Accelerometer not active");
      }
    }
    else
    {
      NSLog(@"Accelerometer not Available!");
    }
  }
  return self;
}

RCT_EXPORT_METHOD(setAccelerometerUpdateInterval:(double) interval) {
  NSLog(@"setAccelerometerUpdateInterval: %f", interval);

  [self->_motionManager setAccelerometerUpdateInterval:interval];
}

RCT_EXPORT_METHOD(getAccelerometerUpdateInterval:(RCTResponseSenderBlock) cb) {
  double interval = self->_motionManager.accelerometerUpdateInterval;
  NSLog(@"getAccelerometerUpdateInterval: %f", interval);
  cb(@[[NSNull null], [NSNumber numberWithDouble:interval]]);
}

RCT_EXPORT_METHOD(getAccelerometerData:(RCTResponseSenderBlock) cb) {
  double x = self->_motionManager.accelerometerData.acceleration.x;
  double y = self->_motionManager.accelerometerData.acceleration.y;
  double z = self->_motionManager.accelerometerData.acceleration.z;
  double timestamp = self->_motionManager.accelerometerData.timestamp;

  NSLog(@"getAccelerometerData: %f, %f, %f, %f", x, y, z, timestamp);

  cb(@[[NSNull null], @{
         @"acceleration": @{
             @"x" : [NSNumber numberWithDouble:x],
             @"y" : [NSNumber numberWithDouble:y],
             @"z" : [NSNumber numberWithDouble:z],
             @"timestamp" : [NSNumber numberWithDouble:timestamp]
             }
         }]
     );
}

RCT_EXPORT_METHOD(startAccelerometerUpdates) {
  NSLog(@"startAccelerometerUpdates");
  [self->_motionManager startAccelerometerUpdates];

  /* Receive the ccelerometer data on this block */
  [self->_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue]
                                    withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
   {
     double x = accelerometerData.acceleration.x;
     double y = accelerometerData.acceleration.y;
     double z = accelerometerData.acceleration.z;
     double timestamp = accelerometerData.timestamp;
     NSLog(@"startAccelerometerUpdates: %f, %f, %f, %f", x, y, z, timestamp);

     [self.bridge.eventDispatcher sendDeviceEventWithName:@"AccelerationData" body:@{
                                                                             @"acceleration": @{
                                                                                 @"x" : [NSNumber numberWithDouble:x],
                                                                                 @"y" : [NSNumber numberWithDouble:y],
                                                                                 @"z" : [NSNumber numberWithDouble:z],
                                                                                 @"timestamp" : [NSNumber numberWithDouble:timestamp]
                                                                                 }
                                                                             }];
   }];

}

RCT_EXPORT_METHOD(stopAccelerometerUpdates) {
  NSLog(@"stopAccelerometerUpdates");
  [self->_motionManager stopAccelerometerUpdates];
}

@end
