//
//  DraftsSummaryViewController.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 30/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import "DraftsSummaryViewController.h"
#import "SummaryContactCell.h"
#import "TokenHolder.h"
#import "AFHTTPRequestOperationManager.h"
#import "IPHolder.h"
#import "UserHolder.h"

@interface DraftsSummaryViewController ()

@end

@implementation DraftsSummaryViewController{
    NSArray *Contacts, *options;
}

@synthesize Draft,lblDate,lblDuration,lblTime,lblHeld,draftIndex;

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
    
    Contacts = [Draft objectForKey:@"InvitedParticipants"];
    
    if([[Draft objectForKey:@"Dateindex"] intValue] != 5){
        [lblDate setText:[options objectAtIndex:[[Draft objectForKey:@"Dateindex"] intValue]]];
    }else{
        [lblHeld setText:@"To be held before"];
        
        //if the selected option is "Before a date" the date will be displayed and the time label will be displayed
        //the actual date and time will be displayed separately
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        
        NSDate *beforeDate = [dateFormatter dateFromString:[Draft objectForKey:@"BeforeDate"]];
        
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
    
    [lblDuration setText:[self stringFromTimeInterval:[[Draft objectForKey:@"Duration"]doubleValue]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*!
 Send the new meeting to the server
 */
- (IBAction)Send:(id)sender {
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
    
    //this is only used to store the drafts, we remove is for the request
    [Draft removeObjectForKey:@"failDate"];
    
    
    //names from contacts are not necessary, we remove them
    for (NSMutableDictionary *dict in [Draft objectForKey:@"InvitedParticipants"]) {
        [dict removeObjectsForKeys:@[@"FirstName", @"LastName"]];
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", [[TokenHolder Token] valueForKey:@"access_token"]] forHTTPHeaderField:@"Authorization"];
    
    
    [manager POST:[IPHolder IPWithPath:@"/api/Meeting/Schedule"] parameters:Draft success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([operation.response statusCode] == 200){
            //remove the draft after successful send
            [[UserHolder Drafts] removeObjectAtIndex:draftIndex];
            [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Sent"
                                                           message: @"Your meeting has been sent"
                                                          delegate: nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            
            
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Something went wrong"
                                                           message: @"Please try again later."
                                                          delegate: nil
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil];
            
            [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@", error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Something went wrong"
                                                       message: @"Please try again later."
                                                      delegate: nil
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil];
        
        [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [Contacts count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"DraftContactCell";
    SummaryContactCell *cell = (SummaryContactCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    [[cell lblName]setText:[[NSString alloc] initWithFormat:@"%@ %@", [[Contacts objectAtIndex:[indexPath row]] valueForKey:@"FirstName"], [[Contacts objectAtIndex:[indexPath row]] valueForKey:@"LastName"]]];
    
    if ([[[Contacts objectAtIndex:[indexPath row]] objectForKey:@"Important"]  isEqual: @YES]) {
        [cell.reqImage setHidden:NO];
    }
    
    return cell;
}


/*!
 make the timeinterval readable
 */
- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%li Hours %li Minutes", (long)hours, (long)minutes];
}

@end
