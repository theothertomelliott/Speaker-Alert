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
    SpeechTimer* myTimer;
}

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *myView;
- (IBAction)StopPressed:(id)sender;
- (IBAction)PausePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *PauseButton;

@end
