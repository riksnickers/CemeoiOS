//
//  SummaryNewMeetingViewController.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 18/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import "SummaryNewMeetingViewController.h"
#import "SummaryContactCell.h"
#import "TokenHolder.h"

@interface SummaryNewMeetingViewController ()

@end

@implementation SummaryNewMeetingViewController{
    NSArray *options;
}

@synthesize Contacts;
@synthesize lblDate;
@synthesize DateIndex;
@synthesize beforeDate;
@synthesize lblTime;

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
	options = [[NSArray alloc] initWithObjects:
               @"Today",
               @"Within this work week",
               @"Within 7 days",
               @"Within this month",
               @"Within 30 days",
               @"Before a date",
               nil];
    
    //shows wich option is selected from the options array via the DateIndex (from previous viewcontroller)
    if(DateIndex != 5){
        [lblDate setText:[options objectAtIndex:DateIndex]];
    }else{
        //if the selected option is "Before a date" the date will be displayed and the time label will be displayed
        //the actual date and time will be displayed separately
        NSString *dateString = [NSDateFormatter localizedStringFromDate:beforeDate
                                                              dateStyle:NSDateFormatterFullStyle
                                                              timeStyle:NSDateFormatterNoStyle];
        [lblDate setText:dateString];
        
        NSString *timeString = [NSDateFormatter localizedStringFromDate:beforeDate
                                                              dateStyle:NSDateFormatterNoStyle
                                                              timeStyle:NSDateFormatterShortStyle];
        [lblTime setHidden:NO];
        [lblTime setText:timeString];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [Contacts count];
}

/*! Uses a custom cell to display table data received from the previous viewcontroller.
 displays the req image in the cell if the contact is required to be present at the meeting
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"SummaryContactCell";
    
    SummaryContactCell *cell = (SummaryContactCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SummaryContactCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblName.text = [[NSString alloc] initWithFormat:@"%@ %@", [[Contacts objectAtIndex:[indexPath row]] valueForKey:@"FirstName"], [[Contacts objectAtIndex:[indexPath row]] valueForKey:@"LastName"]];
    
    if ([[[Contacts objectAtIndex:[indexPath row]] objectForKey:@"required"]  isEqual: @YES]) {
        [cell.reqImage setHidden:NO];
    }
    
    return cell;
    
}

/*!
 Sets all the data that needs to be send to the external service in a NSMutableDictionary.
 The sending to the service will be implemented in the next sprint.
 Return to the upcoming meetings list via an unwind segue
 */
- (IBAction)send:(id)sender {
    NSMutableDictionary *toSend = [[NSMutableDictionary alloc] init];
    [toSend setObject:[[TokenHolder Token] objectForKey:@"userName"] forKey:@"creator"];
    [toSend setObject:[NSNumber numberWithInt:DateIndex] forKey:@"dateIndex"];
    [toSend setObject:Contacts forKey:@"members"];
    
    //if the "Before a date" option is selected then the selected date will be send along
    if(DateIndex == 5){
        [toSend setObject:beforeDate forKey:@"beforeDate"];
    }
    
    //the NSMutableDictionary gets serialized to json to show the data in the console
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:toSend
                                                      options:NSJSONWritingPrettyPrinted
                                                        error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"json data: %@", jsonString);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Send"
                                                   message: @"Your meeting has been send"
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    
    
    [alert show];
    
    [self performSegueWithIdentifier:@"toUpcoming" sender:self];
    
}
@end
