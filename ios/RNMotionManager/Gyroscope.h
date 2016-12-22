//
//  Gyroscope.h
//
//  Created by Patrick Williams in beautiful Seattle, WA.
//

#import "RCTBridgeModule.h"
#import <CoreMotion/CoreMotion.h>

@interface Gyroscope : NSObject <RCTBridgeModule>

- (void) setGyroUpdateInterval:(double) interval;
- (void) getGyroUpdateInterval:(nonnull RCTResponseSenderBlock) cb;
- (void) getGyroData:(nonnull RCTResponseSenderBlock) cb;
- (void) startGyroUpdates:(nonnull RCTResponseSenderBlock) cb;
- (void) stopGyroUpdates;

@end
