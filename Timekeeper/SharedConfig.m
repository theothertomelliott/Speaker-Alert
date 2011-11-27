//
//  SharedConfig.m
//  Timekeeper
//
//  Created by Tom Elliott on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SharedConfig.h"

static SharedConfig* sharedInstance;

@implementation SharedConfig

@synthesize green;
@synthesize amber;
@synthesize red;
@synthesize lastSpeech;
@synthesize shouldVibrate;
@synthesize editingState;

+(void)setup{
    sharedInstance = [[SharedConfig alloc] init];
}

-(SharedConfig*) init{
    green = INITIAL_GREEN_S;
    amber = INITIAL_AMBER_S;
    red = INITIAL_RED_S;
    editingState = kGreen;
    shouldVibrate = true;
    lastSpeech = -1;
    
    return self;
}

+(SharedConfig*)sharedInstance{
    if(sharedInstance == nil){
        [SharedConfig setup];
    }
    return sharedInstance;
}

@end
