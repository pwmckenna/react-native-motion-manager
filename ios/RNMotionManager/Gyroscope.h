//
//  Gyroscope.h
//
//  Created by Patrick Williams in beautiful Seattle, WA.
//

#import "RCTBridgeModule.h"
#import <CoreMotion/CoreMotion.h>

@interface Gyroscope : NSObject <RCTBridgeModule> {
    CMMotionManager *_motionManager;
}
- (void) setGyroUpdateInterval:(double) interval;
- (void) getGyroUpdateInterval:(RCTResponseSenderBlock) cb;
- (void) getGyroData:(RCTResponseSenderBlock) cb;
- (void) startGyroUpdates:(RCTResponseSenderBlock) cb;
- (void) stopGyroUpdates;

@end
