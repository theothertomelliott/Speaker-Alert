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
    NSInteger offset = timeOffset != -1 ? timeOffset : 0;
    return [now timeIntervalSinceDate: startTime] + offset;
}

-(void) createTimer{
    timerState = kRunning;
    
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}


-(void) start {
    startTime = [NSDate date];
    [self createTimer];
}

-(SpeechTimer*) init {
    timeOffset = -1;
    return self;
}

-(SpeechTimer*) initTimerWithGreen:(NSInteger) green Amber: (NSInteger) amber Red:(NSInteger) red Flash:(NSInteger) flash andDelegate: (id<SpeechTimerListener>) theListener;
{
    times = [NSArray arrayWithObjects: 
             [NSNumber numberWithInt:0],
             [NSNumber numberWithInt:green],
             [NSNumber numberWithInt:amber],
             [NSNumber numberWithInt:red],
             [NSNumber numberWithInt:flash], nil];
    
    listener = theListener;
    
    lightState = kNone;
    timerState = kStopped;
    
    NSLog(@"Green = %@, Amber = %@, Red = %@, Flash = %@", 
          [times objectAtIndex:kGreen], 
          [times objectAtIndex:kAmber], 
          [times objectAtIndex:kRed],
          [times objectAtIndex:kFlash]);
    
    return self;
}

-(void) doTick:(BOOL) wasSuspended {
    NSTimeInterval interval = [self getCurrentTime];
    [listener timeUpdated:interval];
    
    if(lightState+1 < [times count] && 
       (interval >= [[times objectAtIndex:lightState+1] integerValue])){
        lightState++;
        [listener lightChanged:lightState fromSuspension:wasSuspended];
    }
}

-(void) tick {
    [self doTick:NO];
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
    } else if(timerState == kSuspended){
        [self doTick:YES];
        [self createTimer];
    }
}

-(void) suspend {
    if(timerState == kRunning){
        [timer invalidate];
        timer = nil;
        timerState = kSuspended;
    }
}

- (void) kill {
    NSLog(@"Stopping timer");
    [timer invalidate];
    timer = nil;
    timerState = kStopped;
}

-(NSDate*) getTimeForState:(LightState) state {
    if(state < kGreen){
        return nil;
    }
    
    NSInteger offset = timeOffset != -1 ? timeOffset : 0;
    return [startTime dateByAddingTimeInterval:([[times objectAtIndex:state] integerValue] - offset)];
}

@end
