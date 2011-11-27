//
//  SpeechTimer.m
//  Timekeeper
//
//  Created by Tom Elliott on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SpeechTimer.h"

@implementation SpeechTimer

-(NSTimeInterval) getCurrentTime {
    NSDate* now = [NSDate date];
    int offset = timeOffset != -1 ? timeOffset : 0;
    return [now timeIntervalSinceDate: startTime] + offset;
}

-(void) doStart {    
    startTime = [NSDate date];
    
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

-(SpeechTimer*) init {
    timeOffset = -1;
    return self;
}

-(void) startTimerWithGreen:(int) green Amber: (int) amber Red:(int) red andDelegate: (id<SpeechTimerListener>) theListener;
{
    greenAtS = green;
    amberAtS = amber;
    redAtS = red;
    
    listener = theListener;
    
    state = kNone;
    
    [self doStart];
}

-(void) tick {
    NSTimeInterval interval = [self getCurrentTime];
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

-(BOOL) isPaused {
    return (timer == nil && timeOffset != -1);
}

-(void) pause {
    if(![self isPaused]){
        [timer invalidate];
        timer = nil;
    
        timeOffset = [self getCurrentTime];
    }
}

-(void) resume {
    if([self isPaused]){
        [self doStart];
    }
}

- (void) kill {
    NSLog(@"Stopping timer");
    [timer invalidate];
    timer = nil;
}

@end
