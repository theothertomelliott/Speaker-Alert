//
//  TKOverviewController.m
//  Timekeeper
//
//  Created by Tom Elliott on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TKOverviewController.h"
#import "SharedConfig.h"

@implementation TKOverviewController
@synthesize VibrateSlider;
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

- (void)viewWillAppear:(BOOL)animated {
    SharedConfig* config = [SharedConfig sharedInstance];
    
    greenTimeLab.text = [NSString stringWithFormat:@"%02d:%02d", (int)(config.green/SECONDS_IN_A_MINUTE),(config.green%SECONDS_IN_A_MINUTE)];
    amberTimeLab.text = [NSString stringWithFormat:@"%02d:%02d", (int)(config.amber/SECONDS_IN_A_MINUTE),(config.amber%SECONDS_IN_A_MINUTE)];
    redTimeLab.text = [NSString stringWithFormat:@"%02d:%02d",(int)(config.red/SECONDS_IN_A_MINUTE),(config.red%SECONDS_IN_A_MINUTE)];
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
    [SharedConfig sharedInstance].editingState = kGreen;
    [self performSegueWithIdentifier:@"editingSegue" sender:self];
}

- (IBAction)amberEditing:(id)sender {
    [SharedConfig sharedInstance].editingState = kAmber;
    [self performSegueWithIdentifier:@"editingSegue" sender:self];
}

- (IBAction)redEditing:(id)sender {
    [SharedConfig sharedInstance].editingState = kRed;
    [self performSegueWithIdentifier:@"editingSegue" sender:self];
}

- (IBAction)VibrateValueChanged:(id)sender {
    [SharedConfig sharedInstance].shouldVibrate = [VibrateSlider isOn];
}
@end
