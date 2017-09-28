//
//  Proximity.m
//
//  Created by zxcpoiu.
//

#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "Proximity.h"

@implementation Proximity

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (id) init {
  self = [super init];
  NSLog(@"Proximity");

  if (self) {

    self->_currentDevice = [UIDevice currentDevice];
    [self->_currentDevice setProximityMonitoringEnabled:YES];

    if ([self->_currentDevice isProximityMonitoringEnabled] == YES)
    {
      NSLog(@"Proximity available");
    }
    else
    {
      NSLog(@"Proximity not Available!");
    }
    [self->_currentDevice setProximityMonitoringEnabled:NO];
  }
  return self;
}

RCT_EXPORT_METHOD(getProximityData:(RCTResponseSenderBlock) cb) {
  BOOL state = self->_currentDevice.proximityState;
  
  NSLog(@"getProximityData: %@", (state) ? @"YES" : @"NO");
  
  cb(@[[NSNull null], @{
             @"isNear" : [NSNumber numberWithBool:state]
         }]
     );
}

RCT_EXPORT_METHOD(startProximityUpdates) {
  NSLog(@"startProximityUpdates");
  [self->_currentDevice setProximityMonitoringEnabled:YES];
  [self->_currentDevice addObserver:self forKeyPath:@"proximityState" options:NSKeyValueObservingOptionNew context:nil];
}

RCT_EXPORT_METHOD(stopProximityUpdates) {
  NSLog(@"stopProximityUpdates");
  [self->_currentDevice setProximityMonitoringEnabled:NO];
  [self->_currentDevice removeObserver:self forKeyPath:@"proximityState"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
  if ([keyPath isEqualToString:@"proximityState"]) {
    BOOL state = self->_currentDevice.proximityState;
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"Proximity" body:@{
                                                                               @"isNear" : [NSNumber numberWithBool:state]
                                                                           }];

  }
}

@end
