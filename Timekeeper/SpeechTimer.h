//
//  SpeechTimer.h
//  Timekeeper
//
//  Created by Tom Elliott on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SpeechTimerListener
@required
- (void)timeUpdated:(NSTimeInterval) elapsed;
- (void)atGreen;
- (void)atAmber;
- (void)atRed;
@end

typedef enum {
    kNone,
    kGreen,
    kAmber,
    kRed
} LightState;

@interface SpeechTimer : NSObject {
    NSTimer* timer;
    NSDate* startTime;
    
    // Times for each light
    int greenAtS;
    int amberAtS;
    int redAtS;
    
    LightState state;
    
    id<SpeechTimerListener> listener;

}

-(void) kill;
-(void) tick;
-(void) startTimerWithGreen:(int) green Amber: (int) amber Red:(int) red andDelegate: (id<SpeechTimerListener>) theListener;
-(NSTimeInterval) getCurrentTime;

@end