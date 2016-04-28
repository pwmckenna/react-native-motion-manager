//
//  Proximity.h
//
//  Created by zxcpoiu.
//

#import "RCTBridgeModule.h"
#import <UIKit/UIKit.h>

@interface Proximity : NSObject <RCTBridgeModule> {
  UIDevice *_currentDevice;
}
- (void) getProximityData:(RCTResponseSenderBlock) cb;
- (void) startProximityUpdates;
- (void) stopProximityUpdates;

@end
