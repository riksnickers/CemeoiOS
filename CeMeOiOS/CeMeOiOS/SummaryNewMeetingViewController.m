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
#import "AFHTTPRequestOperationManager.h"
#import "IPHolder.h"
#import "UserHolder.h"

@interface SummaryNewMeetingViewController ()

-(void)SendData:(NSDictionary *)data;

@end

@implementation SummaryNewMeetingViewController{
    NSArray *options,*originalContacts;
}

@synthesize Contacts;
@synthesize lblDate;
@synthesize DateIndex;
@synthesize beforeDate;
@synthesize lblTime;
@synthesize lblBeHeld;
@synthesize Duration;
@synthesize lblDuration;


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
    
    originalContacts = [[NSMutableArray alloc] initWithArray:Contacts copyItems:YES];
    
    //shows wich option is selected from the options array via the DateIndex (from previous viewcontroller)
    if(DateIndex != 5){
        [lblDate setText:[options objectAtIndex:DateIndex]];
    }else{
        [lblBeHeld setText:@"To be held before"];
        
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
    
    //Displays the meeting duration in the textfield
    [lblDuration setText:[self stringFromTimeInterval:Duration]];
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
    
    if ([[[Contacts objectAtIndex:[indexPath row]] objectForKey:@"Important"]  isEqual: @YES]) {
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
    [toSend setObject:[[UserHolder UserData] objectForKey:@"UserId"] forKey:@"Creator"];
    
    for (NSMutableDictionary *dict in Contacts) {
        [dict removeObjectsForKeys:@[@"FirstName", @"LastName"]];
    }
    
    [toSend setObject:Contacts forKey:@"InvitedParticipants"];
    
    [toSend setObject:[NSNumber numberWithInt:DateIndex] forKey:@"Dateindex"];

    
    //if the "Before a date" option is selected then the selected date will be send along
    if(DateIndex == 5){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSString *dateString = [dateFormatter stringFromDate:beforeDate];
        [toSend setObject:dateString forKey:@"BeforeDate"];
    }else{
        [toSend setObject:[NSNumber numberWithInt:0] forKey:@"BeforeDate"];
    }
    
    [toSend setObject:[NSNumber numberWithDouble:Duration] forKey:@"Duration"];
    
    [self SendData:toSend];
    
}

/*!
 Sends the new meeting data to the server for processing
 *\param data The new meeting (nsdictionary) that will be converted to json and send
 */
-(void)SendData:(NSMutableDictionary *)data{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", [[TokenHolder Token] valueForKey:@"access_token"]] forHTTPHeaderField:@"Authorization"];

    
    UIAlertView *waitAlert = [[UIAlertView alloc] initWithTitle:@"Sending data..."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
    loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [waitAlert addSubview:loading];
    [loading startAnimating];
    [waitAlert show];

    
    [manager POST:[IPHolder IPWithPath:@"/api/Meeting/Schedule"] parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([operation.response statusCode] == 200){
            [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Sent"
                                                           message: @"Your meeting has been sent"
                                                          delegate: nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            
            
            [alert show];
            [self performSegueWithIdentifier:@"toUpcoming" sender:self];
        }else{
            [self saveMeeting:data];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Something went wrong"
                                                           message: @"Please try again later. Your meeting has been saved as draft"
                                                          delegate: nil
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil];
            
            [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
            [alert show];
            [self performSegueWithIdentifier:@"toUpcoming" sender:self];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@", error);
        [self saveMeeting:data];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Something went wrong"
                                                        message: @"Please try again later. Your meeting has been saved as draft"
                                                        delegate: nil
                                                        cancelButtonTitle:@"Ok"
                                                        otherButtonTitles:nil];
            
        [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
        [alert show];
        [self performSegueWithIdentifier:@"toUpcoming" sender:self];
        
    }];
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%li Hours %li Minutes", (long)hours, (long)minutes];
}

-(void)saveMeeting:(NSMutableDictionary *)data{
    [data setObject:[NSDate date] forKey:@"failDate"];
    [data setObject:originalContacts forKey:@"InvitedParticipants"];
    [UserHolder AddDraft:data];
}


@end
