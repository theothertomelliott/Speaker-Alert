//
//  TimePickerDataSource.h
//  Timekeeper
//
//  Created by Tom Elliott on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpeechTimer.h"
#import "TKConst.h"

@interface TimePickerDataSource : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    
    LightState editingState;
    int mins;
    int secs;
    
}
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *lightLabel;

@end
