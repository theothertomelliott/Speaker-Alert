//
//  TKOverviewController.h
//  Timekeeper
//
//  Created by Tom Elliott on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKConst.h"

@interface TKOverviewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *greenTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *amberTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *redTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *flashTimeLab;
@property (weak, nonatomic) IBOutlet UISwitch *VibrateSlider;
@property (weak, nonatomic) IBOutlet UILabel *lastSpeechTime;
@property (weak, nonatomic) IBOutlet UISwitch *DisplayTimeSlider;

- (NSString*) formatTimer:(int) time;

- (IBAction)greenEditing:(id)sender;
- (IBAction)amberEditing:(id)sender;
- (IBAction)redEditing:(id)sender;
- (IBAction)flashEditing:(id)sender;
- (IBAction)VibrateValueChanged:(id)sender;
- (IBAction)StartPressed:(id)sender;
- (IBAction)DisplayTimeValueChanged:(id)sender;

@end
