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

+(void)setup{
    sharedInstance = [[SharedConfig alloc] init];
}

-(SharedConfig*) init{

    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"TimerSettings.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"TimerSettings" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    self.green = [[temp objectForKey:@"GreenTime"] intValue];
    self.amber = [[temp objectForKey:@"AmberTime"] intValue];
    self.red = [[temp objectForKey:@"RedTime"] intValue];
    self.shouldVibrate = [[temp objectForKey:@"ShouldVibrate"] boolValue];

    lastSpeech = -1;
    
    return self;
}

- (void) saveSettings {

    NSLog(@"Saving settings");
    
    NSString *error;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"TimerSettings.plist"];
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
                               [NSArray arrayWithObjects:
                                    [NSNumber numberWithInt:green],
                                    [NSNumber numberWithInt:amber], 
                                    [NSNumber numberWithInt:red], 
                                    [NSNumber numberWithBool:shouldVibrate],
                                    nil] forKeys:
                               [NSArray arrayWithObjects:   @"GreenTime", 
                                                            @"AmberTime",
                                                            @"RedTime",
                                                            @"ShouldVibrate", nil]];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    }
    else {
        NSLog(@"Error writing settings out: %@",error);
    }
    
}

+(SharedConfig*)sharedInstance{
    if(sharedInstance == nil){
        [SharedConfig setup];
    }
    return sharedInstance;
}

@end
