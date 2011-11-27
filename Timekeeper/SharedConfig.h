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

@interface SharedConfig : NSObject {

    int green;
    int amber;
    int red;
    
    int lastSpeech;
    
    BOOL shouldVibrate;
    
    LightState editingState;
    
}

@property (readwrite,assign) int green;
@property (readwrite,assign) int red;
@property (readwrite,assign) int amber;
@property (readwrite,assign) int lastSpeech;
@property (readwrite,assign) BOOL shouldVibrate;
@property (readwrite,assign) LightState editingState;

+(void)setup;
+(SharedConfig*)sharedInstance;

@end
