//
//  SelectTimeViewController.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 18/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import "SelectTimeViewController.h"
#import "SelectDurationNewMeetingViewController.h"

@interface SelectTimeViewController ()

@end

@implementation SelectTimeViewController{
    NSArray *options;
}
@synthesize  datePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    options = [[NSArray alloc] initWithObjects:
               @"Today",
               @"Within this work week",
               @"Within 7 days",
               @"Within this month",
               @"Within 30 days",
               @"Before a date",
               nil];
    
    [datePicker setAlpha:0.0];
    [datePicker setMinimumDate:[[NSDate date]dateByAddingTimeInterval:600]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [options count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [options objectAtIndex:row];
}

/*!
 Shows the datepicker when the "Before a date" option is selected
 Hides it when deselected.
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(row == 5){
        [UIView animateWithDuration:0.3 animations:^() {
            datePicker.alpha = 1.0;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^() {
            datePicker.alpha = 0.0;
        }];
    }
}

/*!
 Sends the Contacts, The selected date option to the next viewcontroller.
 Sends the selected date if the "Before a date" option is the active option
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toDuration"]) {
        SelectDurationNewMeetingViewController *dest = segue.destinationViewController;
        dest.Contacts = self.Contacts;
        dest.DateIndex = [self.timePicker selectedRowInComponent:0];
        if ([self.timePicker selectedRowInComponent:0] == 5) {
            dest.beforeDate = [datePicker date];
        }
    }
}

@end
