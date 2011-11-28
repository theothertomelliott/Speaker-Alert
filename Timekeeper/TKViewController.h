//
//  TKViewController.h
//  Timekeeper
//
//  Created by Tom Elliott on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SpeechTimer.h"
#import "SharedConfig.h"
#import "TKConst.h"
#import "VibrateQueue.h"

@interface TKViewController : UIViewController <SpeechTimerListener> {
}

// Label displaying the current time
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
// Full view object - outlet required for background colour changes.
@property (weak, nonatomic) IBOutlet UIView *myView;
// Pause button - outlet required to change title to Pause/Resume.
@property (weak, nonatomic) IBOutlet UIButton *PauseButton;

// Stop button action (stop the timer and return to the Overview)
- (IBAction)StopPressed:(id)sender;
// Pause button pressed (pause myTimer)
- (IBAction)PausePressed:(id)sender;

// Get the current speech timer
+ (SpeechTimer*) getTimer;

@end
