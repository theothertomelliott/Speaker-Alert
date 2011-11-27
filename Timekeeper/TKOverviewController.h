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
- (IBAction)greenEditing:(id)sender;
- (IBAction)amberEditing:(id)sender;
- (IBAction)redEditing:(id)sender;
- (IBAction)VibrateValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *VibrateSlider;

@end
