//
//  SharedConfig.h
//  Timekeeper
//
//  Created by Tom Elliott on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpeechTimer.h"
#import "TKConst.h"

/*
 * Application-wide configuration.
 * Singleton class storing all shared settings.
 */
@interface SharedConfig : NSObject {

    // Times for each light
    int green;
    int amber;
    int red;
    
    // Vibrate on state transition?
    BOOL shouldVibrate;
    
    // Total time of most recent speech.
    int lastSpeech;
}

@property (readwrite,assign) int green;
@property (readwrite,assign) int red;
@property (readwrite,assign) int amber;
@property (readwrite,assign) int lastSpeech;
@property (readwrite,assign) BOOL shouldVibrate;

// Set up the config object, read in values from find.
+(void)setup;
// Retrieve the config object (will set up if required).
+(SharedConfig*)sharedInstance;
// Write settings to file.
- (void) saveSettings;

@end
