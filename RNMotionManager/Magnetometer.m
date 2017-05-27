//
//  Magnetometer.m
//
//  Created by Patrick Williams in beautiful Seattle, WA.
//

#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import "Magnetometer.h"

@implementation Magnetometer

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (id) init {
  self = [super init];
  NSLog(@"Magnetometer");

  if (self) {
    self->_motionManager = [[CMMotionManager alloc] init];
    //Magnetometer
    if([self->_motionManager isMagnetometerAvailable])
    {
      NSLog(@"Magnetometer available");
      /* Start the Magnetometer if it is not active already */
      if([self->_motionManager isMagnetometerActive] == NO)
      {
        NSLog(@"Magnetometer active");
      } else {
        NSLog(@"Magnetometer not active");
      }
    }
    else
    {
      NSLog(@"Magnetometer not Available!");
    }
  }
  return self;
}

RCT_EXPORT_METHOD(setMagnetometerUpdateInterval:(double) interval) {
  NSLog(@"setMagnetometerUpdateInterval: %f", interval);

  [self->_motionManager setMagnetometerUpdateInterval:interval];
}

RCT_EXPORT_METHOD(getMagnetometerUpdateInterval:(RCTResponseSenderBlock) cb) {
  double interval = self->_motionManager.magnetometerUpdateInterval;
  NSLog(@"getMagnetometerUpdateInterval: %f", interval);
  cb(@[[NSNull null], [NSNumber numberWithDouble:interval]]);
}

RCT_EXPORT_METHOD(getMagnetometerData:(RCTResponseSenderBlock) cb) {
  double x = self->_motionManager.magnetometerData.magneticField.x;
  double y = self->_motionManager.magnetometerData.magneticField.y;
  double z = self->_motionManager.magnetometerData.magneticField.z;
  double timestamp = self->_motionManager.magnetometerData.timestamp;

  NSLog(@"getMagnetometerData: %f, %f, %f, %f", x, y, z, timestamp);

  cb(@[[NSNull null], @{
         @"magneticField": @{
             @"x" : [NSNumber numberWithDouble:x],
             @"y" : [NSNumber numberWithDouble:y],
             @"z" : [NSNumber numberWithDouble:z],
             @"timestamp" : [NSNumber numberWithDouble:timestamp]
             }
         }]
     );
}

RCT_EXPORT_METHOD(startMagnetometerUpdates) {
  NSLog(@"startMagnetometerUpdates");
  [self->_motionManager startMagnetometerUpdates];

  /* Receive the ccelerometer data on this block */
  [self->_motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue]
                                             withHandler:^(CMMagnetometerData *magnetometerData, NSError *error)
   {
     double x = magnetometerData.magneticField.x;
     double y = magnetometerData.magneticField.y;
     double z = magnetometerData.magneticField.z;
     double timestamp = magnetometerData.timestamp;
     NSLog(@"startMagnetometerUpdates: %f, %f, %f, %f", x, y, z, timestamp);

     [self.bridge.eventDispatcher sendDeviceEventWithName:@"MagnetometerData" body:@{
                                                                                     @"magneticField": @{
                                                                                         @"x" : [NSNumber numberWithDouble:x],
                                                                                         @"y" : [NSNumber numberWithDouble:y],
                                                                                         @"z" : [NSNumber numberWithDouble:z],
                                                                                         @"timestamp" : [NSNumber numberWithDouble:timestamp]
                                                                                         }
                                                                                     }];
   }];

}

RCT_EXPORT_METHOD(stopMagnetometerUpdates) {
  NSLog(@"stopMagnetometerUpdates");
  [self->_motionManager stopMagnetometerUpdates];
}

@end
