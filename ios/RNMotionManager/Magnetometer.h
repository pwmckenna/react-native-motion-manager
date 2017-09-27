//
//  Magnetometer.h
//
//  Created by Patrick Williams in beautiful Seattle, WA.
//

#import "RCTBridgeModule.h"
#import <CoreMotion/CoreMotion.h>

@interface Magnetometer : NSObject <RCTBridgeModule>

- (void) setMagnetometerUpdateInterval:(double) interval;
- (void) getMagnetometerUpdateInterval:(nonnull RCTResponseSenderBlock) cb;
- (void) getMagnetometerData:(nonnull RCTResponseSenderBlock) cb;
- (void) startMagnetometerUpdates:(nonnull RCTResponseSenderBlock) cb;
- (void) stopMagnetometerUpdates;

@end
