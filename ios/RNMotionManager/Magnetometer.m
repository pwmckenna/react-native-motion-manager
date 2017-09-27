//
//  Magnetometer.m
//
//  Created by Patrick Williams in beautiful Seattle, WA.
//

#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "Magnetometer.h"

@interface Magnetometer()

@property (nonatomic, readonly, nonnull) CMMotionManager* motionManager;

+ (NSDictionary*) dictionaryFromMagnetometerData:(CMMagnetometerData*)magnetometerData;

@end


@implementation Magnetometer

@synthesize motionManager = _motionManager;

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (id) init {
  self = [super init];
  NSLog(@"Magnetometer");

  if (self) {
    self->_motionManager = [[CMMotionManager alloc] init];
    //Magnetometer
    if(self.motionManager.magnetometerAvailable)
    {
      NSLog(@"Magnetometer available");
      /* Start the Magnetometer if it is not active already */
      if(self.motionManager.magnetometerActive)
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

  self.motionManager.magnetometerUpdateInterval = interval;
}

RCT_EXPORT_METHOD(getMagnetometerUpdateInterval:(nonnull RCTResponseSenderBlock) cb) {
  double interval = self.motionManager.magnetometerUpdateInterval;
  NSLog(@"getMagnetometerUpdateInterval: %f", interval);
  cb(@[[NSNull null], [NSNumber numberWithDouble:interval]]);
}

RCT_EXPORT_METHOD(getMagnetometerData:(nonnull RCTResponseSenderBlock) cb) {
  CMMagnetometerData* magnetometerData = self.motionManager.magnetometerData;
    
  NSLog(@"getMagnetometerData: %f, %f, %f, %f", magnetometerData.magneticField.x, magnetometerData.magneticField.y, magnetometerData.magneticField.z, magnetometerData.timestamp);

  cb(@[ [NSNull null], [Magnetometer dictionaryFromMagnetometerData:magnetometerData] ]);
}

RCT_EXPORT_METHOD(startMagnetometerUpdates:(nonnull RCTResponseSenderBlock) cb) {
  NSLog(@"startMagnetometerUpdates");

  [self.motionManager startMagnetometerUpdates];
    
  /* Receive the magnometer data on this block */
  [self.motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue]
                                          withHandler:^(CMMagnetometerData *magnetometerData, NSError *error)
   {
     NSLog(@"startMagnetometerUpdates: %f, %f, %f, %f", magnetometerData.magneticField.x, magnetometerData.magneticField.y, magnetometerData.magneticField.z, magnetometerData.timestamp);

     [self.bridge.eventDispatcher sendDeviceEventWithName:@"MagnetometerData" body:[Magnetometer dictionaryFromMagnetometerData:magnetometerData]];
   }];

  cb(@[[NSNull null]]);
}

RCT_EXPORT_METHOD(stopMagnetometerUpdates) {
  NSLog(@"stopMagnetometerUpdates");
  [self.motionManager stopMagnetometerUpdates];
}


+ (NSDictionary*) dictionaryFromMagnetometerData:(CMMagnetometerData*)magnetometerData {
    return @{
             @"magneticField": @{
                     @"x" : [NSNumber numberWithDouble:magnetometerData.magneticField.x],
                     @"y" : [NSNumber numberWithDouble:magnetometerData.magneticField.y],
                     @"z" : [NSNumber numberWithDouble:magnetometerData.magneticField.z],
                     @"timestamp" : [NSNumber numberWithDouble:magnetometerData.timestamp]
                     }
             };
}

@end
