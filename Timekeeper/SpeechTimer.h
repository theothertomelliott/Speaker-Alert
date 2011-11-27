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
 * Possible states for Lights
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
    LightState state;
    
    // Listener to receive timer events.
    id<SpeechTimerListener> listener;

}

// Pause the timer if running, do nothing if paused.
-(void) pause;
// Resume the timer if paused, do nothing if running.
-(void) resume;
// Returns true when the timer is paused.
-(BOOL) isPaused;

// Stop the timer and clean up resources.
-(void) kill;

-(void) tick;

// 
-(void) startTimerWithGreen:(int) green Amber: (int) amber Red:(int) red andDelegate: (id<SpeechTimerListener>) theListener;

// Returns the current elapsed time.
-(NSTimeInterval) getCurrentTime;

@end