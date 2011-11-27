//
//  VibrateQueue.m
//  Timekeeper
//
//  Created by Tom Elliott on 27/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VibrateQueue.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation VibrateQueue

+ (void) vibrateWithRepetitions:(int) times {
    VibrateQueue* queue = [[VibrateQueue alloc] initWithRepetitions:times];
    [queue go];
    queue = nil;
}

- (VibrateQueue*) initWithRepetitions:(int) times{
    repetitionsRemaining = times;
    return self;
}

- (void) go {
    // Play a vibration.
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    // Get rid of the timer as required.
    if(timer != nil){
        [timer invalidate];
        timer = nil;
    }
    
    // Start a new timer if any further vibrations are needed.
    repetitionsRemaining--;
    if(repetitionsRemaining > 0){
        timer = [NSTimer scheduledTimerWithTimeInterval:VIBRATE_INTERVAL target:self selector:@selector(go) userInfo:nil repeats:NO];
    }
}

@end
