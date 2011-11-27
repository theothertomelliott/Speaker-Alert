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
    
    SharedConfig* config = [SharedConfig sharedInstance];
    
    int greenTime = [config green];
    int amberTime = [config amber];
    int redTime = [config red];
    
    myTimer = [[SpeechTimer alloc] init];
    [myTimer startTimerWithGreen:greenTime Amber:amberTime Red:redTime andDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Timer listener

- (void)timeUpdated:(NSTimeInterval) elapsed {

    int elapsedS = elapsed;
    elapsedS = elapsedS % SECONDS_IN_A_MINUTE;
    int elapsedM = floor(elapsed / SECONDS_IN_A_MINUTE);
    
    [timeLabel setText:[NSString stringWithFormat: @"%d:%02d", elapsedM, elapsedS]];
}

- (void)atGreen {
    myView.backgroundColor = [UIColor colorWithRed:0.0f green:0.75f blue:0.0f alpha:1.0f];
    if([SharedConfig sharedInstance].shouldVibrate){
        [VibrateQueue vibrateWithRepetitions:1];
    }
}

- (void)atAmber {
    myView.backgroundColor = [UIColor yellowColor]; 
    if([SharedConfig sharedInstance].shouldVibrate){
        [VibrateQueue vibrateWithRepetitions:2];
    }
}

- (void)atRed {
    myView.backgroundColor = [UIColor redColor];
    if([SharedConfig sharedInstance].shouldVibrate){
        [VibrateQueue vibrateWithRepetitions:3];
    }
}

- (IBAction)StopPressed:(id)sender {
    NSTimeInterval currentTime = [myTimer getCurrentTime];
    [SharedConfig sharedInstance].lastSpeech = currentTime;
    
    // Stop the timer
    if(myTimer){
        [myTimer kill];
        myTimer = nil;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)PausePressed:(id)sender {
    if([myTimer isPaused]){
        [myTimer resume];
        [PauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    } else {
        [myTimer pause];
        [PauseButton setTitle:@"Resume" forState:UIControlStateNormal];
    }
}
@end
