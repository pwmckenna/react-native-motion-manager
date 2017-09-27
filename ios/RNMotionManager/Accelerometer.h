//
//  Accelerometer.h
//
//  Created by Patrick Williams in beautiful Seattle, WA.
//

#import "RCTBridgeModule.h"
#import <CoreMotion/CoreMotion.h>

@interface Accelerometer : NSObject <RCTBridgeModule>

- (void) setAccelerometerUpdateInterval:(double) interval;
- (void) getAccelerometerUpdateInterval:(nonnull RCTResponseSenderBlock) cb;
- (void) getAccelerometerData:(nonnull RCTResponseSenderBlock) cb;
- (void) startAccelerometerUpdates:(nonnull RCTResponseSenderBlock) cb;
- (void) stopAccelerometerUpdates;

@end
