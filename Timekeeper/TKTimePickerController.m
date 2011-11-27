//
//  TKTimePickerController.m
//  Timekeeper
//
//  Created by Tom Elliott on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TKTimePickerController.h"
#import "SharedConfig.h"

static LightState stateToEdit;

@implementation TKTimePickerController 
@synthesize picker;
@synthesize lightLabel;

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
    
    if(stateToEdit == kGreen){
        lightLabel.text = @"Green";
        lightLabel.textColor = [UIColor colorWithRed:0.0f green:0.5f blue:0.0f alpha:1.0f];
        int time = [SharedConfig sharedInstance].green;
        [picker selectRow:(int)(time/SECONDS_IN_A_MINUTE) inComponent:0 animated:NO];
        [picker selectRow:(time%SECONDS_IN_A_MINUTE)/SECOND_INCREMENTS inComponent:1 animated:NO];
    }
    if(stateToEdit == kAmber){
        lightLabel.text = @"Amber";
        lightLabel.textColor = [UIColor yellowColor];
        int time = [SharedConfig sharedInstance].amber;
        [picker selectRow:(int)(time/SECONDS_IN_A_MINUTE) inComponent:0 animated:NO];
        [picker selectRow:(time%SECONDS_IN_A_MINUTE)/SECOND_INCREMENTS inComponent:1 animated:NO];
    }
    if(stateToEdit == kRed){
        lightLabel.text = @"Red";
        lightLabel.textColor = [UIColor redColor];
        int time = [SharedConfig sharedInstance].red;
        [picker selectRow:(int)(time/SECONDS_IN_A_MINUTE) inComponent:0 animated:NO];
        [picker selectRow:(time%SECONDS_IN_A_MINUTE)/SECOND_INCREMENTS inComponent:1 animated:NO];
    }
}

#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0){
        return MAX_MINUTES;
    }
    
    if(component == 1){
        return SECONDS_IN_A_MINUTE/SECOND_INCREMENTS;
    }
    
    return 0;
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    
    NSLog(@"Getting title for (%d,%d)", row, component);
    
    if(component == 0){
        return [NSString stringWithFormat:@"%d min", (int) row];
    }
    
    if(component == 1){
        return [NSString stringWithFormat:@"%d sec", (int) row*SECOND_INCREMENTS];
    }
    
    return @"Unexpected component!";
} 

#pragma mark PickerView Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    SharedConfig* config = [SharedConfig sharedInstance];
    
    int time = [picker selectedRowInComponent:0]*SECONDS_IN_A_MINUTE + [picker selectedRowInComponent:1]*SECOND_INCREMENTS;
    
    if(stateToEdit == kGreen){
        config.green = time;
    } else if(stateToEdit == kAmber){
        config.amber = time;
    } else if(stateToEdit == kRed){
        config.red = time;
    } else {
        NSLog(@"Unknown editing state!");
    }
}

- (void)viewDidUnload {
    [self setPicker:nil];
    [self setLightLabel:nil];
    [super viewDidUnload];
}

+ (void) setEditingState:(LightState) newState {
    stateToEdit = newState;
}

@end
