//
//  SpeechTimer.m
//  Timekeeper
//
//  Created by Tom Elliott on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SpeechTimer.h"

@implementation SpeechTimer

-(void) startTimerWithGreen:(int) green Amber: (int) amber Red:(int) red andDelegate: (id<SpeechTimerListener>) theListener;
{
    
    startTime = [NSDate date];
    greenAtS = green;
    amberAtS = amber;
    redAtS = red;
    
    listener = theListener;
    
    state = kNone;
    
    if(timer){
        [timer invalidate];
         timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

-(void) tick {
    NSDate* now = [NSDate date];
    NSTimeInterval interval = [now timeIntervalSinceDate: startTime];
    [listener timeUpdated:interval];
    
    if((interval >= greenAtS) && state == kNone){
        [listener atGreen];
        state = kGreen;
    }
    
    if((interval >= amberAtS) && state == kGreen){
        [listener atAmber];
        state = kAmber;
    }
    
    if((interval >= redAtS) && state == kAmber){
        [listener atRed];
        state = kRed;
    }
}

- (void) kill {
    NSLog(@"Stopping timer");
    [timer invalidate];
    timer = nil;
}

@end
