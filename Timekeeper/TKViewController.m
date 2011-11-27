//
//  TKViewController.m
//  Timekeeper
//
//  Created by Tom Elliott on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TKViewController.h"

@implementation TKViewController
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
    [myView setBackgroundColor:[UIColor greenColor]];
    if([SharedConfig sharedInstance].shouldVibrate){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

- (void)atAmber {
    [myView setBackgroundColor:[UIColor yellowColor]]; 
    if([SharedConfig sharedInstance].shouldVibrate){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

- (void)atRed {
    [myView setBackgroundColor:[UIColor redColor]];
    if([SharedConfig sharedInstance].shouldVibrate){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

- (IBAction)StopPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)PausePressed:(id)sender {
}
@end
