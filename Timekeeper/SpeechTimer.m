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

-(void) start {    
    startTime = [NSDate date];
    timerState = kRunning;
    
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

-(SpeechTimer*) initTimerWithGreen:(int) green Amber: (int) amber Red:(int) red andDelegate: (id<SpeechTimerListener>) theListener;
{
    greenAtS = green;
    amberAtS = amber;
    redAtS = red;
    
    listener = theListener;
    
    lightState = kNone;
    timerState = kStopped;
    
    return self;
}

-(void) tick {
    NSTimeInterval interval = [self getCurrentTime];
    [listener timeUpdated:interval];
    
    if((interval >= greenAtS) && lightState == kNone){
        [listener atGreen];
        lightState = kGreen;
    }
    
    if((interval >= amberAtS) && lightState == kGreen){
        [listener atAmber];
        lightState = kAmber;
    }
    
    if((interval >= redAtS) && lightState == kAmber){
        [listener atRed];
        lightState = kRed;
    }
}

-(TimingState) getTimingState {
    return timerState;
}

-(LightState) getLightState {
    return lightState;
}

-(void) pause {
    if(!(timerState == kPaused)){
        [timer invalidate];
        timer = nil;
    
        timeOffset = [self getCurrentTime];
        timerState = kPaused;
    }
}

-(void) resume {
    if(timerState == kPaused){
        [self start];
    }
}

- (void) kill {
    NSLog(@"Stopping timer");
    [timer invalidate];
    timer = nil;
    timerState = kStopped;
}

-(NSDate*) greenTime {
    int offset = timeOffset != -1 ? timeOffset : 0;
    return [startTime dateByAddingTimeInterval:(greenAtS - offset)];
}

-(NSDate*) amberTime {
    int offset = timeOffset != -1 ? timeOffset : 0;
    return [startTime dateByAddingTimeInterval:(amberAtS - offset)];   
}

-(NSDate*) redTime {
    int offset = timeOffset != -1 ? timeOffset : 0;
    return [startTime dateByAddingTimeInterval:(redAtS - offset)];
}

@end
