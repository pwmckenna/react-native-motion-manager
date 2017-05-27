//
//  Accelerometer.h
//
//  Created by Patrick Williams in beautiful Seattle, WA.
//

#import <React/RCTBridgeModule.h>
#import <CoreMotion/CoreMotion.h>

@interface Accelerometer : NSObject <RCTBridgeModule> {
  CMMotionManager *_motionManager;
}
- (void) setAccelerometerUpdateInterval:(double) interval;
- (void) getAccelerometerUpdateInterval:(RCTResponseSenderBlock) cb;
- (void) getAccelerometerData:(RCTResponseSenderBlock) cb;
- (void) startAccelerometerUpdates;
- (void) stopAccelerometerUpdates;

@end
