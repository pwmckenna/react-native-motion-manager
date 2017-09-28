#import "RCTBridgeModule.h"
#import <CoreMotion/CoreMotion.h>

@interface DeviceMotion : NSObject <RCTBridgeModule> {
  CMMotionManager *_motionManager;
}
- (void) setDeviceMotionUpdateInterval:(double) interval;
- (void) getDeviceMotionUpdateInterval:(RCTResponseSenderBlock) cb;
- (void) getDeviceMotionData:(RCTResponseSenderBlock) cb;
- (void) startDeviceMotionUpdates;
- (void) stopDeviceMotionUpdates;

@end
