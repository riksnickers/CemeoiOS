//
//  SelectDurationNewMeetingViewController.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 06/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import "SelectDurationNewMeetingViewController.h"
#import "SummaryNewMeetingViewController.h"

@interface SelectDurationNewMeetingViewController ()

@end

@implementation SelectDurationNewMeetingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*!
 Sends the Contacts, The selected date option and the chosen duration to the next viewcontroller.
 Sends the selected date if the "Before a date" option is the active option
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toSummary"]) {
        SummaryNewMeetingViewController *dest = segue.destinationViewController;
        dest.Contacts = self.Contacts;
        dest.DateIndex = self.DateIndex;
        dest.Duration = [self.DurationPicker countDownDuration];
        if (self.DateIndex == 5) {
            dest.beforeDate = self.beforeDate;
        }
    }
}

@end
