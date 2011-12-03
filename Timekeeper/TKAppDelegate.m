//
//  TKAppDelegate.m
//  Timekeeper
//
//  Created by Tom Elliott on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TKAppDelegate.h"
#import "SharedConfig.h"
#import "TKViewController.h"

@implementation TKAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [[SharedConfig sharedInstance] saveSettings];
}

- (void) createNotification:(NSString*) light withDate:(NSDate*) time {
    UIApplication* app = [UIApplication sharedApplication];

    // Create a new notification.
    UILocalNotification* alarm = [[UILocalNotification alloc] init];
    if (alarm)
    {
        alarm.fireDate = time;
        alarm.timeZone = [NSTimeZone defaultTimeZone];
        alarm.repeatInterval = 0;
        alarm.soundName = UILocalNotificationDefaultSoundName;
        alarm.alertBody = [NSString stringWithFormat:@"%@ light.",light];
        
        [app scheduleLocalNotification:alarm];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"Received local notification: %@", notification.alertBody);
}

/*
 * Clear out all old notifications and reset the badge number
 * We can assume that all notifications have become void once the
 * app reloads, as current state will be visible to the user.
 */
- (void) clearNotifications {
    UIApplication* app = [UIApplication sharedApplication];

    NSArray* notifications = [app scheduledLocalNotifications];
    for (id notification in notifications) {
        NSLog(@"Body: %@", ((UILocalNotification*)notification).alertBody);
    }
    
    [app cancelAllLocalNotifications];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    [self clearNotifications];
    
    // Create local alerts and suspend the timer if running
    SpeechTimer* timer = [TKViewController getTimer];
    if([timer getTimingState] == kRunning){
        LightState light = [timer getLightState];
        
        if(light < kGreen){
            [self createNotification:@"Green" withDate:[timer greenTime]];
        }
        if(light < kAmber){
            [self createNotification:@"Amber" withDate:[timer amberTime]];
        }
        if(light < kRed){
            [self createNotification:@"Red" withDate:[timer redTime]];
        }
        
        [timer suspend];
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */

    [self clearNotifications];

    // Resume the timer if suspended
    SpeechTimer* timer = [TKViewController getTimer];
    if([timer getTimingState] == kSuspended){
        [timer resume];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
