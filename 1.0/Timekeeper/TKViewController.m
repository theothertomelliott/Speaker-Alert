//
//  TKViewController.m
//  Timekeeper
//
//  Created by Tom Elliott on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TKViewController.h"

@implementation TKViewController
@synthesize PauseButton;
@synthesize timeLabel;
@synthesize myView;

// Model for this Timer view.
static SpeechTimer* myTimer;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
     // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    if(myTimer){
        NSLog(@"Killing timer");
        [myTimer kill];
        myTimer = nil;
    }
    
    [self setTimeLabel:nil];
    [self setMyView:nil];
    [self setPauseButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if(myTimer){
        [myTimer kill];
        myTimer = nil;
    }
    
    NSInteger greenTime = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_GREEN_TIME];
    NSInteger amberTime = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_AMBER_TIME];
    NSInteger redTime = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_RED_TIME];
    NSInteger flashTime = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_FLASH_TIME];
    
    myTimer = [[SpeechTimer alloc] initTimerWithGreen:greenTime Amber:amberTime Red:redTime Flash:flashTime andDelegate:self];
    [myTimer start];
    
    [timeLabel setHidden:![[NSUserDefaults standardUserDefaults] boolForKey:KEY_SHOW_TIME]];
    
    // Prevent locking or dimming while idle.
    [UIApplication sharedApplication].idleTimerDisabled=YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    // Reset idle timer
    [UIApplication sharedApplication].idleTimerDisabled=NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark - Timer listener

- (void)timeUpdated:(NSTimeInterval) elapsed {

    int elapsedS = elapsed;
    elapsedS = elapsedS % SECONDS_IN_A_MINUTE;
    int elapsedM = floor(elapsed / SECONDS_IN_A_MINUTE);
    
    [timeLabel setText:[NSString stringWithFormat: @"%d:%02d", elapsedM, elapsedS]];
}

- (void)lightChanged:(LightState)state fromSuspension:(BOOL)wasSuspended {
    
    UIColor* color = nil;
    if(state == kGreen){
        color = [UIColor colorWithRed:0.0f green:0.75f blue:0.0f alpha:1.0f];    
    } else if(state == kAmber){
        color = [UIColor yellowColor];
    } else if(state == kRed){
        color = [UIColor redColor];
    } else if(state == kFlash){
        flashOn = NO;
        [self flash];
        flashTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(flash) userInfo:nil repeats:YES];
    }

    myView.backgroundColor = color;
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:KEY_VIBRATE] && !wasSuspended){
        [VibrateQueue vibrateWithRepetitions:state];
    }
}

- (IBAction)StopPressed:(id)sender {
    NSTimeInterval currentTime = [myTimer getCurrentTime];
    [[NSUserDefaults standardUserDefaults] setInteger:currentTime forKey:KEY_LAST_TIME];
    
    // Stop the timer
    if(myTimer){
        [myTimer kill];
        myTimer = nil;
    }
    
    // Clean up flash timer as required
    if(flashTimer){
        [flashTimer invalidate];
        flashTimer = nil;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)PausePressed:(id)sender {
    if([myTimer getTimingState] == kPaused){
        [myTimer resume];
        [PauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    } else {
        [myTimer pause];
        [PauseButton setTitle:@"Resume" forState:UIControlStateNormal];
    }
}

// Get the current speech timer
+ (SpeechTimer*) getTimer {
    return myTimer;
}

- (void) flash {
    flashOn = !flashOn;
    
    if(flashOn){
        myView.backgroundColor = [UIColor lightGrayColor];
        if([[NSUserDefaults standardUserDefaults] boolForKey:KEY_VIBRATE]){
            [VibrateQueue vibrateWithRepetitions:1];
        }
    } else {
        myView.backgroundColor = [UIColor redColor];
    }
}

@end
