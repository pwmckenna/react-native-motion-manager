//
//  Accelerometer.m
//
//  Created by Patrick Williams in beautiful Seattle, WA.
//

#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "Accelerometer.h"

@interface Accelerometer()

@property (nonatomic, readonly, nonnull) CMMotionManager* motionManager;

+ (NSDictionary*) dictionaryFromAccelerometerData:(CMAccelerometerData*)accelData;

@end


@implementation Accelerometer

@synthesize motionManager = _motionManager;

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (id) init {
  self = [super init];
  NSLog(@"Accelerometer");

  if (self) {
    self->_motionManager = [[CMMotionManager alloc] init];
    //Accelerometer
    if(self.motionManager.accelerometerAvailable)
    {
      NSLog(@"Accelerometer available");
      /* Start the accelerometer if it is not active already */
      if(self.motionManager.accelerometerActive)
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

  self.motionManager.accelerometerUpdateInterval = interval;
}

RCT_EXPORT_METHOD(getAccelerometerUpdateInterval:(nonnull RCTResponseSenderBlock) cb) {
  double interval = self.motionManager.accelerometerUpdateInterval;
  NSLog(@"getAccelerometerUpdateInterval: %f", interval);
  cb(@[[NSNull null], [NSNumber numberWithDouble:interval]]);
}

RCT_EXPORT_METHOD(getAccelerometerData:(nonnull RCTResponseSenderBlock) cb) {
  CMAccelerometerData* accelerometerData = self.motionManager.accelerometerData;
    
  NSLog(@"getAccelerometerData: %f, %f, %f, %f", accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z, accelerometerData.timestamp);

  cb(@[ [NSNull null], [Accelerometer dictionaryFromAccelerometerData: accelerometerData] ]);
}

RCT_EXPORT_METHOD(startAccelerometerUpdates:(nonnull RCTResponseSenderBlock) cb) {
  NSLog(@"startAccelerometerUpdates");

  [self.motionManager startAccelerometerUpdates];
  
  /* Receive the accelerometer data on this block */
  [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue]
                                           withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
    {
     NSLog(@"startAccelerometerUpdates: %f, %f, %f, %f", accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z, accelerometerData.timestamp);

     [self.bridge.eventDispatcher sendDeviceEventWithName:@"AccelerationData" body:[Accelerometer dictionaryFromAccelerometerData: accelerometerData]];
   }];
    
  cb(@[[NSNull null]]);
}

RCT_EXPORT_METHOD(stopAccelerometerUpdates) {
  NSLog(@"stopAccelerometerUpdates");
  [self.motionManager stopAccelerometerUpdates];
}

+ (NSDictionary*) dictionaryFromAccelerometerData:(CMAccelerometerData*)accelData {
    return @{
             @"acceleration": @{
                     @"x" : [NSNumber numberWithDouble:accelData.acceleration.x],
                     @"y" : [NSNumber numberWithDouble:accelData.acceleration.y],
                     @"z" : [NSNumber numberWithDouble:accelData.acceleration.z],
                     @"timestamp" : [NSNumber numberWithDouble:accelData.timestamp]
                     }
             };
}

@end
