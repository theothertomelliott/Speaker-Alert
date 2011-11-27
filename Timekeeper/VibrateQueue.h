//
//  VibrateQueue.h
//  Timekeeper
//
//  Created by Tom Elliott on 27/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VIBRATE_INTERVAL 0.8f

@interface VibrateQueue : NSObject {
    NSTimer* timer;
    int repetitionsRemaining;
}

// Play the specified number of vibrations.
+ (void) vibrateWithRepetitions:(int) times;

// Initialize a VibrateQueue that will generate the specified number of vibrations.
- (VibrateQueue*) initWithRepetitions:(int) times;
- (void) go;

@end
