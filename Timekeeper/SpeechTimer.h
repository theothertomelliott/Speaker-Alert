//
//  SpeechTimer.h
//  Timekeeper
//
//  Created by Tom Elliott on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * Protocol for receiving timer events.
 * Handles updates to the time elapsed and state transitions.
 */
@protocol SpeechTimerListener
@required
- (void)timeUpdated:(NSTimeInterval) elapsed;
- (void)atGreen;
- (void)atAmber;
- (void)atRed;
@end

/*
 * State of timer (independant of elapsed time).
 */
typedef enum {
    kStopped,
    kRunning,
    kPaused
} TimingState;

/*
 * Possible states for Lights.
 */
typedef enum {
    kNone,
    kGreen,
    kAmber,
    kRed
} LightState;

@interface SpeechTimer : NSObject {
    NSTimer* timer;
    
    // Time the timer was last started or paused
    NSDate* startTime;
    
    // Time offset as a result of pausing
    NSTimeInterval timeOffset;
    
    // Times for each light
    int greenAtS;
    int amberAtS;
    int redAtS;
    
    // Current light state.
    LightState lightState;
    
    // Current timer state.
    TimingState timerState;
    
    // Listener to receive timer events.
    id<SpeechTimerListener> listener;

}

// Pause the timer if running, do nothing if paused.
-(void) pause;
// Resume the timer if paused, do nothing if running.
-(void) resume;

// Return timing state
-(TimingState) getTimingState;
// Return light state
-(LightState) getLightState;

// Stop the timer and clean up resources.
-(void) kill;

-(void) tick;

// Create a timer
-(SpeechTimer*) initTimerWithGreen:(int) green Amber: (int) amber Red:(int) red andDelegate: (id<SpeechTimerListener>) theListener;

// Start the timer
-(void) start;

// Returns the current elapsed time.
-(NSTimeInterval) getCurrentTime;

// Times for each light (at this point)
-(NSDate*) greenTime;
-(NSDate*) amberTime;
-(NSDate*) redTime;

@end