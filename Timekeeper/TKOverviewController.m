//
//  TKOverviewController.m
//  Timekeeper
//
//  Created by Tom Elliott on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TKOverviewController.h"
#import "TKTimePickerController.h"

@implementation TKOverviewController
@synthesize lastSpeechTime;
@synthesize greenTimeLab;
@synthesize amberTimeLab;
@synthesize redTimeLab;
@synthesize flashTimeLab;

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
    
    greenTimeLab.text = [self formatTimer:[[NSUserDefaults standardUserDefaults] integerForKey:KEY_GREEN_TIME]];   
    amberTimeLab.text = [self formatTimer:[[NSUserDefaults standardUserDefaults] integerForKey:KEY_AMBER_TIME]];
    redTimeLab.text = [self formatTimer:[[NSUserDefaults standardUserDefaults] integerForKey:KEY_RED_TIME]];
    flashTimeLab.text = [self formatTimer:[[NSUserDefaults standardUserDefaults] integerForKey:KEY_FLASH_TIME]];
    
    int lastTime = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_LAST_TIME];
    if(lastTime != -1){
        lastSpeechTime.text = [self formatTimer:lastTime];
    } else {
        lastSpeechTime.text = @"--:--";
    }
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
    [self setLastSpeechTime:nil];
    [self setFlashTimeLab:nil];
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

- (IBAction)flashEditing:(id)sender {
    [TKTimePickerController setEditingState:kFlash];
    [self performSegueWithIdentifier:@"editingSegue" sender:self];
}

- (IBAction)StartPressed:(id)sender {
    
    int green = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_GREEN_TIME];
    int amber = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_AMBER_TIME];
    int red = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_RED_TIME];
    int flash = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_FLASH_TIME];
    
    // Validate config
    if(green < amber && amber < red && red < flash){
        [self performSegueWithIdentifier:@"startTimer" sender:self];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invalid light times" message:@"Times for the Green, Amber, Red and flashing lights must be different and in order." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

@end
