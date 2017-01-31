//
//  Magnetometer.h
//
//  Created by Patrick Williams in beautiful Seattle, WA.
//

#import <React/RCTBridgeModule.h>
#import <CoreMotion/CoreMotion.h>

@interface Magnetometer : NSObject <RCTBridgeModule> {
  CMMotionManager *_motionManager;
}
- (void) setMagnetometerUpdateInterval:(double) interval;
- (void) getMagnetometerUpdateInterval:(RCTResponseSenderBlock) cb;
- (void) getMagnetometerData:(RCTResponseSenderBlock) cb;
- (void) startMagnetometerUpdates;
- (void) stopMagnetometerUpdates;

@end
