//
//  TKOverviewController.m
//  Timekeeper
//
//  Created by Tom Elliott on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TKOverviewController.h"
#import "SharedConfig.h"
#import "TKTimePickerController.h"

@implementation TKOverviewController
@synthesize VibrateSlider;
@synthesize lastSpeechTime;
@synthesize greenTimeLab;
@synthesize amberTimeLab;
@synthesize redTimeLab;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (NSString*) formatTimer:(int) time {
    return [NSString stringWithFormat:@"%02d:%02d", (int)(time/SECONDS_IN_A_MINUTE),(time%SECONDS_IN_A_MINUTE)];

}

- (void)viewWillAppear:(BOOL)animated {
    SharedConfig* config = [SharedConfig sharedInstance];
    
    greenTimeLab.text = [self formatTimer:config.green];   
    amberTimeLab.text = [self formatTimer:config.amber];
    redTimeLab.text = [self formatTimer:config.red];
    
    if(config.lastSpeech != -1){
        lastSpeechTime.text = [self formatTimer:config.lastSpeech];
    } else {
        lastSpeechTime.text = @"--:--";
    }
    
    [VibrateSlider setOn:config.shouldVibrate];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [self setGreenTimeLab:nil];
    [self setAmberTimeLab:nil];
    [self setRedTimeLab:nil];
    [self setVibrateSlider:nil];
    [self setLastSpeechTime:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)greenEditing:(id)sender {
    [TKTimePickerController setEditingState:kGreen];
    [self performSegueWithIdentifier:@"editingSegue" sender:self];
}

- (IBAction)amberEditing:(id)sender {
    [TKTimePickerController setEditingState:kAmber];
    [self performSegueWithIdentifier:@"editingSegue" sender:self];
}

- (IBAction)redEditing:(id)sender {
    [TKTimePickerController setEditingState:kRed];
    [self performSegueWithIdentifier:@"editingSegue" sender:self];
}

- (IBAction)VibrateValueChanged:(id)sender {
    [SharedConfig sharedInstance].shouldVibrate = [VibrateSlider isOn];
}

- (IBAction)StartPressed:(id)sender {
    
    SharedConfig* config = [SharedConfig sharedInstance];
    // Validate config
    if(config.green < config.amber && config.amber < config.red){
        [self performSegueWithIdentifier:@"startTimer" sender:self];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invalid light times" message:@"Times for the Green, Amber and Red lights must be different and in order." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}
@end
